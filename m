From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 14:48:41 -0800
Message-ID: <5a7b8249.aANNWkL02eyrJeEr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbeBGWsm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 17:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix
has been removed from the -mm tree.  Its filename was
     fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch

This patch was dropped because it was folded into fs-elf-drop-map_fixed-usage-from-elf_map.patch

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

mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
mm-unclutter-thp-migration.patch
net-netfilter-x_tablesc-remove-size-check.patch

