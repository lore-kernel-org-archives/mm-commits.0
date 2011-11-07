From: akpm@linux-foundation.org
Subject: [merged] sysctl-make-config_sysctl_syscall-default-to-n.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:57 -0800
Message-ID: <201111072028.pA7KSvP7028132@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5859 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, adobriyan@gmail.com, andi@firstfloor.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: make CONFIG_SYSCTL_SYSCALL default to n
has been removed from the -mm tree.  Its filename was
     sysctl-make-config_sysctl_syscall-default-to-n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: WANG Cong <amwang@redhat.com>
Subject: sysctl: make CONFIG_SYSCTL_SYSCALL default to n

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
@@ -947,7 +947,7 @@ config UID16
 config SYSCTL_SYSCALL
 	bool "Sysctl syscall support" if EXPERT
 	depends on PROC_SYSCTL
-	default y
+	default n
 	select SYSCTL
 	---help---
 	  sys_sysctl uses binary paths that have been found challenging
@@ -959,7 +959,7 @@ config SYSCTL_SYSCALL
 	  trying to save some space it is probably safe to disable this,
 	  making your kernel marginally smaller.
 
-	  If unsure say Y here.
+	  If unsure say N here.
 
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch

