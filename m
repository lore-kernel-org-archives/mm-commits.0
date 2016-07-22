From: akpm@linux-foundation.org
Subject: + mm-optimize-copy_page_to-from_iter_iovec.patch added to -mm
 tree
Date: Fri, 22 Jul 2016 14:33:16 -0700
Message-ID: <5792911c.NoxoJObNXbhG+RRB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbcGVVdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jul 2016 17:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpatocka@redhat.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimize copy_page_to/from_iter_iovec
has been added to the -mm tree.  Its filename is
     mm-optimize-copy_page_to-from_iter_iovec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-optimize-copy_page_to-from_iter_iovec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-optimize-copy_page_to-from_iter_iovec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mm: optimize copy_page_to/from_iter_iovec

copy_page_to_iter_iovec() and copy_page_from_iter_iovec() copy some data
to userspace or from userspace.  These functions have a fast path where
they map a page using kmap_atomic and a slow path where they use kmap.

kmap is slower than kmap_atomic, so the fast path is preferred.

However, on kernels without highmem support, kmap just calls page_address,
so there is no need to avoid kmap.  On kernels without highmem support,
the fast path just increases code size (and cache footprint) and it
doesn't improve copy performance in any way.

This patch enables the fast path only if CONFIG_HIGHMEM is defined.

Code size reduced by this patch:
x86 (without highmem)	928
x86-64			960
sparc64			848
alpha			1136
pa-risc			1200

Link: http://lkml.kernel.org/r/alpine.LRH.2.02.1607221711410.4818@file01.intranet.prod.int.rdu2.redhat.com
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iov_iter.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN lib/iov_iter.c~mm-optimize-copy_page_to-from_iter_iovec lib/iov_iter.c
--- a/lib/iov_iter.c~mm-optimize-copy_page_to-from_iter_iovec
+++ a/lib/iov_iter.c
@@ -159,6 +159,7 @@ static size_t copy_page_to_iter_iovec(st
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
+#ifdef CONFIG_HIGHMEM
 	if (!fault_in_pages_writeable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		from = kaddr + offset;
@@ -190,6 +191,8 @@ static size_t copy_page_to_iter_iovec(st
 		copy = min(bytes, iov->iov_len - skip);
 	}
 	/* Too bad - revert to non-atomic kmap */
+#endif
+
 	kaddr = kmap(page);
 	from = kaddr + offset;
 	left = __copy_to_user(buf, from, copy);
@@ -208,7 +211,10 @@ static size_t copy_page_to_iter_iovec(st
 		bytes -= copy;
 	}
 	kunmap(page);
+
+#ifdef CONFIG_HIGHMEM
 done:
+#endif
 	if (skip == iov->iov_len) {
 		iov++;
 		skip = 0;
@@ -240,6 +246,7 @@ static size_t copy_page_from_iter_iovec(
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
+#ifdef CONFIG_HIGHMEM
 	if (!fault_in_pages_readable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		to = kaddr + offset;
@@ -271,6 +278,8 @@ static size_t copy_page_from_iter_iovec(
 		copy = min(bytes, iov->iov_len - skip);
 	}
 	/* Too bad - revert to non-atomic kmap */
+#endif
+
 	kaddr = kmap(page);
 	to = kaddr + offset;
 	left = __copy_from_user(to, buf, copy);
@@ -289,7 +298,10 @@ static size_t copy_page_from_iter_iovec(
 		bytes -= copy;
 	}
 	kunmap(page);
+
+#ifdef CONFIG_HIGHMEM
 done:
+#endif
 	if (skip == iov->iov_len) {
 		iov++;
 		skip = 0;
_

Patches currently in -mm which might be from mpatocka@redhat.com are

mm-add-cond_resched-to-generic_swapfile_activate.patch
mm-optimize-copy_page_to-from_iter_iovec.patch

