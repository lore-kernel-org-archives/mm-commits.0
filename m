From: akpm@linux-foundation.org
Subject: [folded] userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:23:26 -0700
Message-ID: <201103232323.p2NNNQsp004534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1CWXYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     userns-security-make-capabilities-relative-to-the-user-namespace-fix
has been removed from the -mm tree.  Its filename was
     userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch

This patch was dropped because it was folded into userns-security-make-capabilities-relative-to-the-user-namespace.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns-security-make-capabilities-relative-to-the-user-namespace-fix
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 linux-next allmodconfig:

security/selinux/hooks.c: In function 'selinux_file_ioctl':
security/selinux/hooks.c:2890: warning: passing argument 3 of 'task_has_capability' makes pointer from integer without a cast
security/selinux/hooks.c:1420: note: expected 'struct user_namespace *' but argument is of type 'int'
security/selinux/hooks.c:2890: error: too few arguments to function 'task_has_capability'

This patch is surely wrong?

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/selinux/hooks.c~userns-security-make-capabilities-relative-to-the-user-namespace-fix security/selinux/hooks.c
--- a/security/selinux/hooks.c~userns-security-make-capabilities-relative-to-the-user-namespace-fix
+++ a/security/selinux/hooks.c
@@ -2971,8 +2971,8 @@ static int selinux_file_ioctl(struct fil
 
 	case KDSKBENT:
 	case KDSKBSENT:
-		error = task_has_capability(current, cred, CAP_SYS_TTY_CONFIG,
-					    SECURITY_CAP_AUDIT);
+		error = task_has_capability(current, cred, &init_user_ns,
+					CAP_SYS_TTY_CONFIG, SECURITY_CAP_AUDIT);
 		break;
 
 	/* default case assumes that the command will go
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

