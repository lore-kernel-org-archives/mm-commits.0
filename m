From: akpm@linux-foundation.org
Subject: [merged]
 mm-audit-fix-non-modular-users-of-module_init-in-core-code.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:59:29 -0800
Message-ID: <52e2b811.5+kRmzeLUS3UF/vk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com

Subject: [merged] mm-audit-fix-non-modular-users-of-module_init-in-core-code.patch removed from -mm tree
To: paul.gortmaker@windriver.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:29 -0800


The patch titled
     Subject: mm: audit/fix non-modular users of module_init in core code
has been removed from the -mm tree.  Its filename was
     mm-audit-fix-non-modular-users-of-module_init-in-core-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: mm: audit/fix non-modular users of module_init in core code

Code that is obj-y (always built-in) or dependent on a bool Kconfig
(built-in or absent) can never be modular.  So using module_init as an
alias for __initcall can be somewhat misleading.

Fix these up now, so that we can relocate module_init from init.h into
module.h in the future.  If we don't do this, we'd have to add module.h to
obviously non-modular code, and that would be a worse thing.

The audit targets the following module_init users for change:
 mm/ksm.c                       bool KSM
 mm/mmap.c                      bool MMU
 mm/huge_memory.c               bool TRANSPARENT_HUGEPAGE
 mm/mmu_notifier.c              bool MMU_NOTIFIER

Note that direct use of __initcall is discouraged, vs.  one of the
priority categorized subgroups.  As __initcall gets mapped onto
device_initcall, our use of subsys_initcall (which makes sense for these
files) will thus change this registration from level 6-device to level
4-subsys (i.e.  slightly earlier).

However no observable impact of that difference has been observed
during testing.

One might think that core_initcall (l2) or postcore_initcall (l3) would be
more appropriate for anything in mm/ but if we look at some actual init
functions themselves, we see things like:

mm/huge_memory.c --> hugepage_init     --> hugepage_init_sysfs
mm/mmap.c        --> init_user_reserve --> sysctl_user_reserve_kbytes
mm/ksm.c         --> ksm_init          --> sysfs_create_group

and hence the choice of subsys_initcall (l4) seems reasonable, and at the
same time minimizes the risk of changing the priority too drastically all
at once.  We can adjust further in the future.

Also, several instances of missing ";" at EOL are fixed.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c  |    2 +-
 mm/ksm.c          |    2 +-
 mm/mmap.c         |    6 +++---
 mm/mmu_notifier.c |    3 +--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/huge_memory.c~mm-audit-fix-non-modular-users-of-module_init-in-core-code mm/huge_memory.c
--- a/mm/huge_memory.c~mm-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/mm/huge_memory.c
@@ -661,7 +661,7 @@ out:
 	hugepage_exit_sysfs(hugepage_kobj);
 	return err;
 }
-module_init(hugepage_init)
+subsys_initcall(hugepage_init);
 
 static int __init setup_transparent_hugepage(char *str)
 {
diff -puN mm/ksm.c~mm-audit-fix-non-modular-users-of-module_init-in-core-code mm/ksm.c
--- a/mm/ksm.c~mm-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/mm/ksm.c
@@ -2345,4 +2345,4 @@ out_free:
 out:
 	return err;
 }
-module_init(ksm_init)
+subsys_initcall(ksm_init);
diff -puN mm/mmap.c~mm-audit-fix-non-modular-users-of-module_init-in-core-code mm/mmap.c
--- a/mm/mmap.c~mm-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/mm/mmap.c
@@ -3142,7 +3142,7 @@ static int init_user_reserve(void)
 	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
 	return 0;
 }
-module_init(init_user_reserve)
+subsys_initcall(init_user_reserve);
 
 /*
  * Initialise sysctl_admin_reserve_kbytes.
@@ -3163,7 +3163,7 @@ static int init_admin_reserve(void)
 	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
 	return 0;
 }
-module_init(init_admin_reserve)
+subsys_initcall(init_admin_reserve);
 
 /*
  * Reinititalise user and admin reserves if memory is added or removed.
@@ -3233,4 +3233,4 @@ static int __meminit init_reserve_notifi
 
 	return 0;
 }
-module_init(init_reserve_notifier)
+subsys_initcall(init_reserve_notifier);
diff -puN mm/mmu_notifier.c~mm-audit-fix-non-modular-users-of-module_init-in-core-code mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/mm/mmu_notifier.c
@@ -329,5 +329,4 @@ static int __init mmu_notifier_init(void
 {
 	return init_srcu_struct(&srcu);
 }
