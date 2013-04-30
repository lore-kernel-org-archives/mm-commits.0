From: akpm@linux-foundation.org
Subject: [merged] mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:56 -0700
Message-ID: <20130430184856.7851331C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:65185 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3Ss5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:57 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so84994qcs.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agshew@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace hardcoded 3% with admin_reserve_pages knob
has been removed from the -mm tree.  Its filename was
     mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Shewmaker <agshew@gmail.com>
Subject: mm: replace hardcoded 3% with admin_reserve_pages knob

Add an admin_reserve_kbytes knob to allow admins to change the
hardcoded memory reserve to something other than 3%, which
may be multiple gigabytes on large memory systems. Only about
8MB is necessary to enable recovery in the default mode, and
only a few hundred MB are required even when overcommit is
disabled.

This affects OVERCOMMIT_GUESS and OVERCOMMIT_NEVER.

admin_reserve_kbytes is initialized to min(3% free pages, 8MB)

I arrived at 8MB by summing the RSS of sshd or login,
bash, and top.

Please see first patch in this series for full background,
motivation, testing, and full changelog.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: make init_admin_reserve() static]
Signed-off-by: Andrew Shewmaker <agshew@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   30 ++++++++++++++++++++++++++++++
 include/linux/mm.h          |    1 +
 kernel/sysctl.c             |    7 +++++++
 mm/mmap.c                   |   30 ++++++++++++++++++++++++++----
 mm/nommu.c                  |   30 ++++++++++++++++++++++++++----
 5 files changed, 90 insertions(+), 8 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob
+++ a/Documentation/sysctl/vm.txt
@@ -18,6 +18,7 @@ files can be found in mm/swap.c.
 
 Currently, these files are in /proc/sys/vm:
 
+- admin_reserve_kbytes
 - block_dump
 - compact_memory
 - dirty_background_bytes
@@ -59,6 +60,35 @@ Currently, these files are in /proc/sys/
 
 ==============================================================
 
+admin_reserve_kbytes
+
+The amount of free memory in the system that should be reserved for users
+with the capability cap_sys_admin.
+
+admin_reserve_kbytes defaults to min(3% of free pages, 8MB)
+
+That should provide enough for the admin to log in and kill a process,
+if necessary, under the default overcommit 'guess' mode.
+
+Systems running under overcommit 'never' should increase this to account
+for the full Virtual Memory Size of programs used to recover. Otherwise,
+root may not be able to log in to recover the system.
+
+How do you calculate a minimum useful reserve?
+
+sshd or login + bash (or some other shell) + top (or ps, kill, etc.)
+
+For overcommit 'guess', we can sum resident set sizes (RSS).
+On x86_64 this is about 8MB.
+
+For overcommit 'never', we can take the max of their virtual sizes (VSZ)
+and add the sum of their RSS.
+On x86_64 this is about 128MB.
+
+Changing this takes effect whenever an application requests memory.
+
+==============================================================
+
 block_dump
 
 block_dump enables block I/O debugging when set to a nonzero value. More
diff -puN include/linux/mm.h~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob include/linux/mm.h
--- a/include/linux/mm.h~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob
+++ a/include/linux/mm.h
@@ -45,6 +45,7 @@ extern int sysctl_legacy_va_layout;
 #include <asm/processor.h>
 
 extern unsigned long sysctl_user_reserve_kbytes;
+extern unsigned long sysctl_admin_reserve_kbytes;
 
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
diff -puN kernel/sysctl.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob kernel/sysctl.c
--- a/kernel/sysctl.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob
+++ a/kernel/sysctl.c
@@ -1436,6 +1436,13 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
+	{
+		.procname	= "admin_reserve_kbytes",
+		.data		= &sysctl_admin_reserve_kbytes,
+		.maxlen		= sizeof(sysctl_admin_reserve_kbytes),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
 	{ }
 };
 
diff -puN mm/mmap.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob mm/mmap.c
--- a/mm/mmap.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob
+++ a/mm/mmap.c
@@ -85,6 +85,7 @@ int sysctl_overcommit_memory __read_most
 int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
+unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
 /*
  * Make sure vm_committed_as in one cacheline and not cacheline shared with
  * other variables. It can be updated by several CPUs frequently.
@@ -164,10 +165,10 @@ int __vm_enough_memory(struct mm_struct
 			free -= totalreserve_pages;
 
 		/*
-		 * Leave the last 3% for root
+		 * Reserve some for root
 		 */
 		if (!cap_sys_admin)
-			free -= free / 32;
+			free -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
 
 		if (free > pages)
 			return 0;
@@ -178,10 +179,10 @@ int __vm_enough_memory(struct mm_struct
 	allowed = (totalram_pages - hugetlb_total_pages())
 	       	* sysctl_overcommit_ratio / 100;
 	/*
-	 * Leave the last 3% for root
+	 * Reserve some for root
 	 */
 	if (!cap_sys_admin)
-		allowed -= allowed / 32;
+		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
 	allowed += total_swap_pages;
 
 	/*
@@ -3119,3 +3120,24 @@ static int __meminit init_user_reserve(v
 	return 0;
 }
 module_init(init_user_reserve)
+
+/*
+ * Initialise sysctl_admin_reserve_kbytes.
+ *
+ * The purpose of sysctl_admin_reserve_kbytes is to allow the sys admin
+ * to log in and kill a memory hogging process.
+ *
+ * Systems with more than 256MB will reserve 8MB, enough to recover
+ * with sshd, bash, and top in OVERCOMMIT_GUESS. Smaller systems will
+ * only reserve 3% of free pages by default.
+ */
+static int __meminit init_admin_reserve(void)
+{
+	unsigned long free_kbytes;
+
+	free_kbytes = global_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+
+	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
+	return 0;
+}
+module_init(init_admin_reserve)
diff -puN mm/nommu.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob mm/nommu.c
--- a/mm/nommu.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob
+++ a/mm/nommu.c
@@ -64,6 +64,7 @@ int sysctl_overcommit_ratio = 50; /* def
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
 int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
+unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
 int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
@@ -1939,10 +1940,10 @@ int __vm_enough_memory(struct mm_struct
 			free -= totalreserve_pages;
 
 		/*
-		 * Leave the last 3% for root
+		 * Reserve some for root
 		 */
 		if (!cap_sys_admin)
-			free -= free / 32;
+			free -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
 
 		if (free > pages)
 			return 0;
@@ -1952,10 +1953,10 @@ int __vm_enough_memory(struct mm_struct
 
 	allowed = totalram_pages * sysctl_overcommit_ratio / 100;
 	/*
-	 * Leave the last 3% for root
+	 * Reserve some 3% for root
 	 */
 	if (!cap_sys_admin)
-		allowed -= allowed / 32;
+		allowed -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
 	allowed += total_swap_pages;
 
 	/*
@@ -2147,3 +2148,24 @@ static int __meminit init_user_reserve(v
 	return 0;
 }
 module_init(init_user_reserve)
+
+/*
+ * Initialise sysctl_admin_reserve_kbytes.
+ *
+ * The purpose of sysctl_admin_reserve_kbytes is to allow the sys admin
+ * to log in and kill a memory hogging process.
+ *
+ * Systems with more than 256MB will reserve 8MB, enough to recover
+ * with sshd, bash, and top in OVERCOMMIT_GUESS. Smaller systems will
+ * only reserve 3% of free pages by default.
+ */
+static int __meminit init_admin_reserve(void)
+{
+	unsigned long free_kbytes;
+
+	free_kbytes = global_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+
+	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
+	return 0;
+}
+module_init(init_admin_reserve)
_

Patches currently in -mm which might be from agshew@gmail.com are

origin.patch

