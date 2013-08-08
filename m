From: akpm@linux-foundation.org
Subject: + mm-kconfig-add-mmu-dependency-for-migration.patch added to -mm
 tree
Date: Thu, 08 Aug 2013 13:52:07 -0700
Message-ID: <520404f7.OGEBinM87hxGW9mf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966415Ab3HHUwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 16:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, gang.chen@asianux.com

Subject: + mm-kconfig-add-mmu-dependency-for-migration.patch added to -mm tree
To: gang.chen@asianux.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 13:52:07 -0700


The patch titled
     Subject: mm/Kconfig: add MMU dependency for MIGRATION.
has been added to the -mm tree.  Its filename is
     mm-kconfig-add-mmu-dependency-for-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kconfig-add-mmu-dependency-for-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kconfig-add-mmu-dependency-for-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/Kconfig: add MMU dependency for MIGRATION.

MIGRATION must depend on MMU, or allmodconfig for the nommu sh
architecture fails to build:

    CC      mm/migrate.o
  mm/migrate.c: In function 'remove_migration_pte':
  mm/migrate.c:134:3: error: implicit declaration of function 'pmd_trans_huge' [-Werror=implicit-function-declaration]
     if (pmd_trans_huge(*pmd))
     ^
  mm/migrate.c:149:2: error: implicit declaration of function 'is_swap_pte' [-Werror=implicit-function-declaration]
    if (!is_swap_pte(pte))
    ^
  ...

Also let CMA depend on MMU, or when NOMMU, if we select CMA, it will
select MIGRATION by force.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/Kconfig~mm-kconfig-add-mmu-dependency-for-migration mm/Kconfig
--- a/mm/Kconfig~mm-kconfig-add-mmu-dependency-for-migration
+++ a/mm/Kconfig
@@ -245,7 +245,7 @@ config COMPACTION
 config MIGRATION
 	bool "Page migration"
 	def_bool y
-	depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION || CMA
+	depends on (NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful in
@@ -522,7 +522,7 @@ config MEM_SOFT_DIRTY
 
 config CMA
 	bool "Contiguous Memory Allocator"
-	depends on HAVE_MEMBLOCK
+	depends on HAVE_MEMBLOCK && MMU
 	select MIGRATION
 	select MEMORY_ISOLATION
 	help
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
arch-kconfig-add-kernel-kconfigfreezer-to-arch-kconfig.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
mm-page_allocc-use-__paginginit-instead-of-__init.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
linux-next.patch
mm-kconfig-add-mmu-dependency-for-migration.patch

