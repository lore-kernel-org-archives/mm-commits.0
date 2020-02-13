From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch added to -mm
 tree
Date: Wed, 12 Feb 2020 18:57:02 -0800
Message-ID: <20200213025702._j_tgrMo2%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbgBMC5F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 21:57:05 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, davem@davemloft.net, edumazet@google.com, mm-commits@vger.kernel.org, soheil@google.com


The patch titled
     Subject: net-zerocopy: use vm_insert_pages() for tcp rcv zerocopy
has been added to the -mm tree.  Its filename is
     net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arjun Roy <arjunroy@google.com>
Subject: net-zerocopy: use vm_insert_pages() for tcp rcv zerocopy

Use vm_insert_pages() for tcp receive zerocopy.  Spin lock cycles (as
reported by perf) drop from a couple of percentage points to a fraction of
a percent.  This results in a roughly 6% increase in efficiency, measured
roughly as zerocopy receive count divided by CPU utilization.

The intention of this patchset is to reduce atomic ops for tcp zerocopy
receives, which normally hits the same spinlock multiple times
consecutively.

Link: http://lkml.kernel.org/r/20200128025958.43490-3-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp.c |   67 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 61 insertions(+), 6 deletions(-)

--- a/net/ipv4/tcp.c~net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy
+++ a/net/ipv4/tcp.c
@@ -1734,14 +1734,48 @@ int tcp_mmap(struct file *file, struct s
 }
 EXPORT_SYMBOL(tcp_mmap);
 
+static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
+					struct page **pages,
+					unsigned long pages_to_map,
+					unsigned long *insert_addr,
+					u32 *length_with_pending,
+					u32 *seq,
+					struct tcp_zerocopy_receive *zc)
+{
+	unsigned long pages_remaining = pages_to_map;
+	int bytes_mapped;
+	int ret;
+
+	ret = vm_insert_pages(vma, *insert_addr, pages, &pages_remaining);
+	bytes_mapped = PAGE_SIZE * (pages_to_map - pages_remaining);
+	/* Even if vm_insert_pages fails, it may have partially succeeded in
+	 * mapping (some but not all of the pages).
+	 */
+	*seq += bytes_mapped;
+	*insert_addr += bytes_mapped;
+	if (ret) {
+		/* But if vm_insert_pages did fail, we have to unroll some state
+		 * we speculatively touched before.
+		 */
+		const int bytes_not_mapped = PAGE_SIZE * pages_remaining;
+		*length_with_pending -= bytes_not_mapped;
+		zc->recv_skip_hint += bytes_not_mapped;
+	}
+	return ret;
+}
+
 static int tcp_zerocopy_receive(struct sock *sk,
 				struct tcp_zerocopy_receive *zc)
 {
 	unsigned long address = (unsigned long)zc->address;
 	u32 length = 0, seq, offset, zap_len;
+	#define PAGE_BATCH_SIZE 8
+	struct page *pages[PAGE_BATCH_SIZE];
 	const skb_frag_t *frags = NULL;
 	struct vm_area_struct *vma;
 	struct sk_buff *skb = NULL;
+	unsigned long pg_idx = 0;
+	unsigned long curr_addr;
 	struct tcp_sock *tp;
 	int inq;
 	int ret;
@@ -1774,8 +1808,20 @@ static int tcp_zerocopy_receive(struct s
 		zc->recv_skip_hint = zc->length;
 	}
 	ret = 0;
+	curr_addr = address;
 	while (length + PAGE_SIZE <= zc->length) {
 		if (zc->recv_skip_hint < PAGE_SIZE) {
+			/* If we're here, finish the current batch. */
+			if (pg_idx) {
+				ret = tcp_zerocopy_vm_insert_batch(vma, pages,
+								   pg_idx,
+								   &curr_addr,
+								   &length,
+								   &seq, zc);
+				if (ret)
+					goto out;
+				pg_idx = 0;
+			}
 			if (skb) {
 				if (zc->recv_skip_hint > 0)
 					break;
@@ -1784,7 +1830,6 @@ static int tcp_zerocopy_receive(struct s
 			} else {
 				skb = tcp_recv_skb(sk, seq, &offset);
 			}
-
 			zc->recv_skip_hint = skb->len - offset;
 			offset -= skb_headlen(skb);
 			if ((int)offset < 0 || skb_has_frag_list(skb))
@@ -1808,14 +1853,24 @@ static int tcp_zerocopy_receive(struct s
 			zc->recv_skip_hint -= remaining;
 			break;
 		}
-		ret = vm_insert_page(vma, address + length,
-				     skb_frag_page(frags));
-		if (ret)
-			break;
+		pages[pg_idx] = skb_frag_page(frags);
+		pg_idx++;
 		length += PAGE_SIZE;
-		seq += PAGE_SIZE;
 		zc->recv_skip_hint -= PAGE_SIZE;
 		frags++;
+		if (pg_idx == PAGE_BATCH_SIZE) {
+			ret = tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
+							   &curr_addr, &length,
+							   &seq, zc);
+			if (ret)
+				goto out;
+			pg_idx = 0;
+		}
+	}
+	if (pg_idx) {
+		ret = tcp_zerocopy_vm_insert_batch(vma, pages, pg_idx,
+						   &curr_addr, &length, &seq,
+						   zc);
 	}
 out:
 	up_read(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from arjunroy@google.com are

mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch
mm-add-vm_insert_pages.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch
