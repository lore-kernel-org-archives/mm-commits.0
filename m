From: akpm@linux-foundation.org
Subject: [to-be-updated] userns-allow-sethostname-in-a-container.patch removed from -mm tree
Date: Mon, 28 Feb 2011 16:11:51 -0800
Message-ID: <201103010011.p210Bp2L006177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801Ab1CAAM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 19:12:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, adobriyan@gmail.com, ebiederm@xmission.com, jmorris@namei.org, kees.cook@canonical.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns: allow sethostname in a container
has been removed from the -mm tree.  Its filename was
     userns-allow-sethostname-in-a-container.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: allow sethostname in a container
From: "Serge E. Hallyn" <serge@hallyn.com>

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~userns-allow-sethostname-in-a-container kernel/sys.c
--- a/kernel/sys.c~userns-allow-sethostname-in-a-container
+++ a/kernel/sys.c
@@ -1177,7 +1177,7 @@ SYSCALL_DEFINE2(sethostname, char __user
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (len < 0 || len > __NEW_UTS_LEN)
 		return -EINVAL;
_

Patches currently in -mm which might be from serge@hallyn.com are

lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
pid-remove-the-child_reaper-special-case-in-init-mainc.patch
pidns-call-pid_ns_prepare_proc-from-create_pid_namespace.patch
procfs-kill-the-global-proc_mnt-variable.patch
userns-allow-killing-tasks-in-your-own-or-child-userns.patch
userns-allow-ptrace-from-non-init-user-namespaces.patch
userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric.patch
userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch
userns-add-a-user-namespace-owner-of-ipc-ns.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch

