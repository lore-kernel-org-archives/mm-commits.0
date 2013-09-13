From: akpm@linux-foundation.org
Subject: [merged] mm-kconfig-add-mmu-dependency-for-migration.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 13:03:08 -0700
Message-ID: <52336f7c.aqHTEd0mNtyf6YRV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, gang.chen@asianux.com

Subject: [merged] mm-kconfig-add-mmu-dependency-for-migration.patch removed from -mm tree
To: gang.chen@asianux.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:03:08 -0700


The patch titled
     Subject: mm/Kconfig: add MMU dependency for MIGRATION.
has been removed from the -mm tree.  Its filename was
     mm-kconfig-add-mmu-dependency-for-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -480,7 +480,7 @@ config FRONTSWAP
 
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
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
linux-next.patch

