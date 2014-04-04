From: akpm@linux-foundation.org
Subject: [merged]
 kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:40 -0700
Message-ID: <533f08d8.efI+YdZ4QDtUqEyF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaDDTcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, ebiederm@xmission.com, paul.gortmaker@windriver.com

Subject: [merged] kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch removed from -mm tree
To: paul.gortmaker@windriver.com,ebiederm@xmission.com,mingo@redhat.com,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:40 -0700


The patch titled
     Subject: kernel: audit/fix non-modular users of module_init in core code
has been removed from the -mm tree.  Its filename was
     kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: kernel: audit/fix non-modular users of module_init in core code

Code that is obj-y (always built-in) or dependent on a bool Kconfig
(built-in or absent) can never be modular.  So using module_init as an
alias for __initcall can be somewhat misleading.

Fix these up now, so that we can relocate module_init from init.h into
module.h in the future.  If we don't do this, we'd have to add module.h to
obviously non-modular code, and that would be a worse thing.

The audit targets the following module_init users for change:
 kernel/user.c                  obj-y
 kernel/kexec.c                 bool KEXEC (one instance per arch)
 kernel/profile.c               bool PROFILING
 kernel/hung_task.c             bool DETECT_HUNG_TASK
 kernel/sched/stats.c           bool SCHEDSTATS
 kernel/user_namespace.c        bool USER_NS

Note that direct use of __initcall is discouraged, vs.  one of the
priority categorized subgroups.  As __initcall gets mapped onto
device_initcall, our use of subsys_initcall (which makes sense for these
files) will thus change this registration from level 6-device to level
4-subsys (i.e.  slightly earlier).  However no observable impact of that
difference has been observed during testing.

Also, two instances of missing ";" at EOL are fixed in kexec.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c      |    3 +--
 kernel/kexec.c          |    4 ++--
 kernel/profile.c        |    2 +-
 kernel/sched/stats.c    |    2 +-
 kernel/user.c           |    3 +--
 kernel/user_namespace.c |    2 +-
 6 files changed, 7 insertions(+), 9 deletions(-)

diff -puN kernel/hung_task.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code kernel/hung_task.c
--- a/kernel/hung_task.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/kernel/hung_task.c
@@ -246,5 +246,4 @@ static int __init hung_task_init(void)
 
 	return 0;
 }
-
-module_init(hung_task_init);
+subsys_initcall(hung_task_init);
diff -puN kernel/kexec.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code kernel/kexec.c
--- a/kernel/kexec.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/kernel/kexec.c
@@ -1235,7 +1235,7 @@ static int __init crash_notes_memory_ini
 	}
 	return 0;
 }
-module_init(crash_notes_memory_init)
+subsys_initcall(crash_notes_memory_init);
 
 
 /*
@@ -1629,7 +1629,7 @@ static int __init crash_save_vmcoreinfo_
 	return 0;
 }
 
-module_init(crash_save_vmcoreinfo_init)
+subsys_initcall(crash_save_vmcoreinfo_init);
 
 /*
  * Move into place and start executing a preloaded standalone
diff -puN kernel/profile.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code kernel/profile.c
--- a/kernel/profile.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/kernel/profile.c
@@ -604,5 +604,5 @@ int __ref create_proc_profile(void) /* f
 	hotcpu_notifier(profile_cpu_callback, 0);
 	return 0;
 }
-module_init(create_proc_profile);
+subsys_initcall(create_proc_profile);
 #endif /* CONFIG_PROC_FS */
diff -puN kernel/sched/stats.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code kernel/sched/stats.c
--- a/kernel/sched/stats.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/kernel/sched/stats.c
@@ -142,4 +142,4 @@ static int __init proc_schedstat_init(vo
 	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
 	return 0;
 }
-module_init(proc_schedstat_init);
+subsys_initcall(proc_schedstat_init);
diff -puN kernel/user.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code kernel/user.c
--- a/kernel/user.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/kernel/user.c
@@ -222,5 +222,4 @@ static int __init uid_cache_init(void)
 
 	return 0;
 }
