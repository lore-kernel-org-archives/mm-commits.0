From: akpm@linux-foundation.org
Subject: + sysctl-make-config_sysctl_syscall-default-to-n.patch added to -mm tree
Date: Thu, 18 Aug 2011 14:48:59 -0700
Message-ID: <201108182148.p7ILmxW9029582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313Ab1HRVtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, adobriyan@gmail.com, andi@firstfloor.org, ebiederm@xmission.com


The patch titled
     sysctl: make CONFIG_SYSCTL_SYSCALL default to n
has been added to the -mm tree.  Its filename is
     sysctl-make-config_sysctl_syscall-default-to-n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: make CONFIG_SYSCTL_SYSCALL default to n
From: WANG Cong <amwang@redhat.com>

When I tried to send a patch to remove it, Andi told me we still need to
keep compabitlies for old libc, so we can't remove this completely.  Then
just make it default to n and remove the doc from
feature-removal-schedule.txt.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   35 -------------------
 init/Kconfig                               |    4 +-
 2 files changed, 2 insertions(+), 37 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~sysctl-make-config_sysctl_syscall-default-to-n Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~sysctl-make-config_sysctl_syscall-default-to-n
+++ a/Documentation/feature-removal-schedule.txt
@@ -133,41 +133,6 @@ Who:	Pavel Machek <pavel@ucw.cz>
 
 ---------------------------
 
-What:	sys_sysctl
-When:	September 2010
-Option: CONFIG_SYSCTL_SYSCALL
-Why:	The same information is available in a more convenient from
-	/proc/sys, and none of the sysctl variables appear to be
-	important performance wise.
-
-	Binary sysctls are a long standing source of subtle kernel
-	bugs and security issues.
-
-	When I looked several months ago all I could find after
-	searching several distributions were 5 user space programs and
-	glibc (which falls back to /proc/sys) using this syscall.
-
-	The man page for sysctl(2) documents it as unusable for user
-	space programs.
-
-	sysctl(2) is not generally ABI compatible to a 32bit user
-	space application on a 64bit and a 32bit kernel.
-
-	For the last several months the policy has been no new binary
-	sysctls and no one has put forward an argument to use them.
-
-	Binary sysctls issues seem to keep happening appearing so
-	properly deprecating them (with a warning to user space) and a
-	2 year grace warning period will mean eventually we can kill
-	them and end the pain.
-
-	In the mean time individual binary sysctls can be dealt with
-	in a piecewise fashion.
-
-Who:	Eric Biederman <ebiederm@xmission.com>
-
----------------------------
-
 What:	/proc/<pid>/oom_adj
 When:	August 2012
 Why:	/proc/<pid>/oom_adj allows userspace to influence the oom killer's
diff -puN init/Kconfig~sysctl-make-config_sysctl_syscall-default-to-n init/Kconfig
--- a/init/Kconfig~sysctl-make-config_sysctl_syscall-default-to-n
+++ a/init/Kconfig
@@ -935,7 +935,7 @@ config UID16
 config SYSCTL_SYSCALL
 	bool "Sysctl syscall support" if EXPERT
 	depends on PROC_SYSCTL
-	default y
+	default n
 	select SYSCTL
 	---help---
 	  sys_sysctl uses binary paths that have been found challenging
@@ -947,7 +947,7 @@ config SYSCTL_SYSCALL
 	  trying to save some space it is probably safe to disable this,
 	  making your kernel marginally smaller.
 
-	  If unsure say Y here.
+	  If unsure say N here.
 
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
sched-fix-a-memory-leak-in-__sdt_free.patch
sysctl-make-config_sysctl_syscall-default-to-n.patch
nbd-use-task_pid_nr-to-get-current-pid.patch
nbd-replace-sysfs_create_file-with-device_create_file.patch
nbd-replace-printk-kern_err-with-dev_err.patch
nbd-lower-the-loglevel-of-an-error-message.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch

