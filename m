From: akpm@linux-foundation.org
Subject: [merged]
 proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:38:08 -0700
Message-ID: <56f03f90.pnp+s2koAkJZv+i7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbcCUT4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, koct9i@gmail.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: /proc/kpageflags: return KPF_SLAB for slab tail pages
has been removed from the -mm tree.  Its filename was
     proc-kpageflags-return-kpf_slab-for-slab-tail-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


