From: akpm@linux-foundation.org
Subject: + proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch added to -mm tree
Date: Thu, 04 Feb 2016 15:26:29 -0800
Message-ID: <56b3de25.n6uSTr71TvPdcJHm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018AbcBDX0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, koct9i@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: /proc/kpageflags: return KPF_SLAB for slab tail pages
has been added to the -mm tree.  Its filename is
     proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: /proc/kpageflags: return KPF_SLAB for slab tail pages

Currently /proc/kpageflags returns just KPF_COMPOUND_TAIL for slab tail
pages, which is inconvenient when grasping how slab pages are distributed
(userspace always needs to check which kind of tail pages by itself). 
This patch sets KPF_SLAB for such pages.

With this patch:

  $ grep Slab /proc/meminfo ; tools/vm/page-types -b slab
  Slab:              64880 kB
               flags      page-count       MB  symbolic-flags                     long-symbolic-flags
  0x0000000000000080           16220       63  _______S__________________________________ slab
               total           16220       63

16220 pages equals to 64880 kB, so returned result is consistent with the
global counter.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/page.c~proc-kpageflags-return-kpf_slab-for-slab-tail-pages fs/proc/page.c
--- a/fs/proc/page.c~proc-kpageflags-return-kpf_slab-for-slab-tail-pages
+++ a/fs/proc/page.c
@@ -160,6 +160,8 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
+	if (PageTail(page) && PageSlab(compound_head(page)))
+		u |= 1 << KPF_SLAB;
 
 	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-madvise-pass-return-code-of-memory_failure-to-userspace.patch
mm-madvise-update-comment-on-sys_madvise.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages.patch
proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch
tools-vm-page-typesc-support-swap-entry.patch

