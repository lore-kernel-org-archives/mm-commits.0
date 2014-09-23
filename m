From: akpm@linux-foundation.org
Subject: + mm-debug-mm-introduce-vm_bug_on_mm-fixpatch.patch added to -mm
 tree
Date: Tue, 23 Sep 2014 13:46:25 -0700
Message-ID: <5421dc21.RZTXDNOIQpPOBunu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbaIWUq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 16:46:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, Valdis.Kletnieks@vt.edu, davej@redhat.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: mm-introduce-vm_bug_on_mm-fix.patch
has been added to the -mm tree.  Its filename is
     mm-debug-mm-introduce-vm_bug_on_mm-fixpatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-mm-introduce-vm_bug_on_mm-fixpatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-mm-introduce-vm_bug_on_mm-fixpatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm, debug: mm-introduce-vm_bug_on_mm-fix.patch

dump_mm wants to dump mm->owner even when CONFIG_MEMCG is not defined
which leads to a compilation error:
mm/debug.c: In function `dump_mm':
mm/debug.c:212:5: error: `const struct mm_struct' has no member named `owner'
   mm->owner, mm->exe_file,

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fixpatch mm/debug.c
--- a/mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fixpatch
+++ a/mm/debug.c
@@ -184,7 +184,10 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_AIO
 		"ioctx_table %p\n"
 #endif
-		"owner %p exe_file %p\n"
+#ifdef CONFIG_MEMCG
+		"owner %p "
+#endif
+		"exe_file %p\n"
 #ifdef CONFIG_MMU_NOTIFIER
 		"mmu_notifier_mm %p\n"
 #endif
@@ -212,7 +215,10 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_AIO
 		mm->ioctx_table,
 #endif
-		mm->owner, mm->exe_file,
+#ifdef CONFIG_MEMCG
+		mm->owner,
+#endif
+		mm->exe_file,
 #ifdef CONFIG_MMU_NOTIFIER
 		mm->mmu_notifier_mm,
 #endif
_

Patches currently in -mm which might be from mhocko@suse.cz are

introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-debug-mm-introduce-vm_bug_on_mm-fixpatch.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch.patch
free-the-reserved-memblock-when-free-cma-pages.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
linux-next.patch

