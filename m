From: akpm@linux-foundation.org
Subject: + mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99.patch added to -mm tree
Date: Wed, 18 May 2016 13:35:59 -0700
Message-ID: <573cd22f.0NpMDVDhdTq5vWd1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbcERUgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2016 16:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, arnd@arndb.de, cl@linux.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99
has been added to the -mm tree.  Its filename is
     mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99

Sorry for my noise, sorry for my silence, thanks to Arnd and everyone
for chipping in.  But now I try it, I find that even Michal's is not
quite right: if you build without CONFIG_PROC_FS, then it gives you
mm/vmstat.c:1381:13: warning: `refresh_vm_stats' defined but not used [-Wunused-function]
(well, that was on a tree with different line numbering).
So here's my attempt...

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1605171750010.24624@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmstat.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99 mm/vmstat.c
--- a/mm/vmstat.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99
+++ a/mm/vmstat.c
@@ -1379,6 +1379,7 @@ static DEFINE_PER_CPU(struct delayed_wor
 int sysctl_stat_interval __read_mostly = HZ;
 static cpumask_var_t cpu_stat_off;
 
+#ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
 {
 	refresh_cpu_vm_stats(true);
@@ -1436,6 +1437,7 @@ int vmstat_refresh(struct ctl_table *tab
 		*lenp = 0;
 	return 0;
 }
+#endif /* CONFIG_PROC_FS */
 
 static void vmstat_update(struct work_struct *w)
 {
_

Patches currently in -mm which might be from hughd@google.com are

mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-99.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
radix-tree-rewrite-radix_tree_locate_item-fix.patch

