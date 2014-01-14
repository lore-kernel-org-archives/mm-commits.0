From: akpm@linux-foundation.org
Subject: +
 kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch added
 to -mm tree
Date: Tue, 14 Jan 2014 15:56:47 -0800
Message-ID: <52d5cebf.lDeNzidjPIZ+8ojX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaANX4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 18:56:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, ebiederm@xmission.com, paul.gortmaker@windriver.com

Subject: + kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch added to -mm tree
To: paul.gortmaker@windriver.com,ebiederm@xmission.com,mingo@redhat.com,peterz@infradead.org
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 15:56:47 -0800


The patch titled
     Subject: kernel: audit/fix non-modular users of module_init in core code
has been added to the -mm tree.  Its filename is
     kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -244,5 +244,4 @@ static int __init hung_task_init(void)
 
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
-
-module_init(uid_cache_init);
+subsys_initcall(uid_cache_init);
diff -puN kernel/user_namespace.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code kernel/user_namespace.c
--- a/kernel/user_namespace.c~kernel-audit-fix-non-modular-users-of-module_init-in-core-code
+++ a/kernel/user_namespace.c
@@ -902,4 +902,4 @@ static __init int user_namespaces_init(v
 	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC);
 	return 0;
 }
-module_init(user_namespaces_init);
+subsys_initcall(user_namespaces_init);
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

lib-percpu_counterc-fix-__percpu_counter_add.patch
fs-ramfs-dont-use-module_init-for-non-modular-core-code.patch
mm-make-creation-of-the-mm_kobj-happen-earlier-than-device_initcall.patch
printk-flush-conflicting-continuation-line.patch
printk-flush-conflicting-continuation-line-fix.patch
fs-proc-dont-use-module_init-for-non-modular-core-code.patch
linux-next.patch
kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch
mm-audit-fix-non-modular-users-of-module_init-in-core-code.patch

