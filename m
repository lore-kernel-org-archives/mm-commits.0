From: akpm@linux-foundation.org
Subject: + fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch added to -mm tree
Date: Mon, 08 Jan 2018 17:29:09 -0800
Message-ID: <5a541ae5.Z1et02zX4SIyeGDR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33654 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbeAIB3K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jan 2018 20:29:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix
has been added to the -mm tree.  Its filename is
     fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix

The following build error is seen when building metag:meta2_defconfig
or metag:tz1090_defconfig.

arch/metag/kernel/process.c: In function '__metag_elf_map':
arch/metag/kernel/process.c:421: error: 'tsk' undeclared

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/metag/kernel/process.c~fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix arch/metag/kernel/process.c
--- a/arch/metag/kernel/process.c~fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix
+++ a/arch/metag/kernel/process.c
@@ -419,7 +419,7 @@ unsigned long __metag_elf_map(struct fil
 
 	if ((type & MAP_FIXED_NOREPLACE) && BAD_ADDR(map_addr))
 		pr_info("%d (%s): Uhuuh, elf segment at %p requested but the memory is mapped already\n",
-				task_pid_nr(current), tsk->comm, (void *)addr);
+				task_pid_nr(current), current->comm, (void *)addr);
 
 	if (!BAD_ADDR(map_addr) && tcm_tag != TCM_INVALID_TAG) {
 		struct tcm_allocation *tcm;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch

