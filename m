Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F568C0729B
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjHNT1A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbjHNT05 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:26:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB53DBF;
        Mon, 14 Aug 2023 12:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA506449B;
        Mon, 14 Aug 2023 19:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910F8C433C8;
        Mon, 14 Aug 2023 19:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692041214;
        bh=wWYLJ0DTpi+in2KBkvhNzxp3/ScSct0qbqvrng5plMI=;
        h=Date:To:From:Subject:From;
        b=dBdzVHkLOaDPmBjwM4Ej3Zi0Kr1C4sBpWdsNxJGDc4HTScchFeAIK72aLNPdwjKdi
         8676P9IE3q3noFUxJ0rzDPEuw9hnCIWGwRzpLr0qkIhsNLgkpJmDGWHj/7dqCi0g7p
         E5ckogVkjeCiXCAvE57D/AlN5knUy3FHPjUhfgh8=
Date:   Mon, 14 Aug 2023 12:26:54 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, keescook@chromium.org, jeffxu@google.com,
        dverkamp@chromium.org, brauner@kernel.org, asmadeus@codewreck.org,
        cyphar@cyphar.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy.patch added to mm-unstable branch
Message-Id: <20230814192654.910F8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memfd: replace ratcheting feature from vm.memfd_noexec with hierarchy
has been added to the -mm mm-unstable branch.  Its filename is
     memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Aleksa Sarai <cyphar@cyphar.com>
Subject: memfd: replace ratcheting feature from vm.memfd_noexec with hierarchy
Date: Mon, 14 Aug 2023 18:41:00 +1000

This sysctl has the very unusual behaviour of not allowing any user (even
CAP_SYS_ADMIN) to reduce the restriction setting, meaning that if you were
to set this sysctl to a more restrictive option in the host pidns you
would need to reboot your machine in order to reset it.

The justification given in [1] is that this is a security feature and thus
it should not be possible to disable.  Aside from the fact that we have
plenty of security-related sysctls that can be disabled after being
enabled (fs.protected_symlinks for instance), the protection provided by
the sysctl is to stop users from being able to create a binary and then
execute it.  A user with CAP_SYS_ADMIN can trivially do this without
memfd_create(2):

  % cat mount-memfd.c
  #include <fcntl.h>
  #include <string.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <unistd.h>
  #include <linux/mount.h>

  #define SHELLCODE "#!/bin/echo this file was executed from this totally private tmpfs:"

  int main(void)
  {
  	int fsfd = fsopen("tmpfs", FSOPEN_CLOEXEC);
  	assert(fsfd >= 0);
  	assert(!fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 2));

  	int dfd = fsmount(fsfd, FSMOUNT_CLOEXEC, 0);
  	assert(dfd >= 0);

  	int execfd = openat(dfd, "exe", O_CREAT | O_RDWR | O_CLOEXEC, 0782);
  	assert(execfd >= 0);
  	assert(write(execfd, SHELLCODE, strlen(SHELLCODE)) == strlen(SHELLCODE));
  	assert(!close(execfd));

  	char *execpath = NULL;
  	char *argv[] = { "bad-exe", NULL }, *envp[] = { NULL };
  	execfd = openat(dfd, "exe", O_PATH | O_CLOEXEC);
  	assert(execfd >= 0);
  	assert(asprintf(&execpath, "/proc/self/fd/%d", execfd) > 0);
  	assert(!execve(execpath, argv, envp));
  }
  % ./mount-memfd
  this file was executed from this totally private tmpfs: /proc/self/fd/5
  %

Given that it is possible for CAP_SYS_ADMIN users to create executable
binaries without memfd_create(2) and without touching the host filesystem
(not to mention the many other things a CAP_SYS_ADMIN process would be
able to do that would be equivalent or worse), it seems strange to cause a
fair amount of headache to admins when there doesn't appear to be an
actual security benefit to blocking this.  There appear to be concerns
about confused-deputy-esque attacks[2] but a confused deputy that can
write to arbitrary sysctls is a bigger security issue than executable
memfds.

/* New API */

The primary requirement from the original author appears to be more based
on the need to be able to restrict an entire system in a hierarchical
manner[3], such that child namespaces cannot re-enable executable memfds.

So, implement that behaviour explicitly -- the vm.memfd_noexec scope is
evaluated up the pidns tree to &init_pid_ns and you have the most
restrictive value applied to you.  The new lower limit you can set
vm.memfd_noexec is whatever limit applies to your parent.

Note that a pidns will inherit a copy of the parent pidns's effective
vm.memfd_noexec setting at unshare() time.  This matches the existing
behaviour, and it also ensures that a pidns will never have its
vm.memfd_noexec setting *lowered* behind its back (but it will be raised
if the parent raises theirs).

/* Backwards Compatibility */

As the previous version of the sysctl didn't allow you to lower the
setting at all, there are no backwards compatibility issues with this
aspect of the change.

However it should be noted that now that the setting is completely
hierarchical.  Previously, a cloned pidns would just copy the current
pidns setting, meaning that if the parent's vm.memfd_noexec was changed it
wouldn't propoagate to existing pid namespaces.  Now, the restriction
applies recursively.  This is a uAPI change, however:

 * The sysctl is very new, having been merged in 6.3.
 * Several aspects of the sysctl were broken up until this patchset and
   the other patchset by Jeff Xu last month.

And thus it seems incredibly unlikely that any real users would run into
this issue. In the worst case, if this causes userspace isues we could
make it so that modifying the setting follows the hierarchical rules but
the restriction checking uses the cached copy.

[1]: https://lore.kernel.org/CABi2SkWnAgHK1i6iqSqPMYuNEhtHBkO8jUuCvmG3RmUB5TKHJw@mail.gmail.com/
[2]: https://lore.kernel.org/CALmYWFs_dNCzw_pW1yRAo4bGCPEtykroEQaowNULp7svwMLjOg@mail.gmail.com/
[3]: https://lore.kernel.org/CALmYWFuahdUF7cT4cm7_TGLqPanuHXJ-hVSfZt7vpTnc18DPrw@mail.gmail.com/

Link: https://lkml.kernel.org/r/20230814-memfd-vm-noexec-uapi-fixes-v2-4-7ff9e3e10ba6@cyphar.com
Fixes: 105ff5339f49 ("mm/memfd: add MFD_NOEXEC_SEAL and MFD_EXEC")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |   23 ++++++++++++++++++++++-
 kernel/pid.c                  |    3 +++
 kernel/pid_namespace.c        |    6 +++---
 kernel/pid_sysctl.h           |   30 +++++++++++++-----------------
 mm/memfd.c                    |    3 ++-
 5 files changed, 43 insertions(+), 22 deletions(-)

--- a/include/linux/pid_namespace.h~memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy
+++ a/include/linux/pid_namespace.h
@@ -39,7 +39,6 @@ struct pid_namespace {
 	int reboot;	/* group exit code if this pidns was rebooted */
 	struct ns_common ns;
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
-	/* sysctl for vm.memfd_noexec */
 	int memfd_noexec_scope;
 #endif
 } __randomize_layout;
@@ -56,6 +55,23 @@ static inline struct pid_namespace *get_
 	return ns;
 }
 
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
+static inline int pidns_memfd_noexec_scope(struct pid_namespace *ns)
+{
+	int scope = MEMFD_NOEXEC_SCOPE_EXEC;
+
+	for (; ns; ns = ns->parent)
+		scope = max(scope, READ_ONCE(ns->memfd_noexec_scope));
+
+	return scope;
+}
+#else
+static inline int pidns_memfd_noexec_scope(struct pid_namespace *ns)
+{
+	return 0;
+}
+#endif
+
 extern struct pid_namespace *copy_pid_ns(unsigned long flags,
 	struct user_namespace *user_ns, struct pid_namespace *ns);
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
@@ -70,6 +86,11 @@ static inline struct pid_namespace *get_
 	return ns;
 }
 
+static inline int pidns_memfd_noexec_scope(struct pid_namespace *ns)
+{
+	return 0;
+}
+
 static inline struct pid_namespace *copy_pid_ns(unsigned long flags,
 	struct user_namespace *user_ns, struct pid_namespace *ns)
 {
--- a/kernel/pid.c~memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy
+++ a/kernel/pid.c
@@ -83,6 +83,9 @@ struct pid_namespace init_pid_ns = {
 #ifdef CONFIG_PID_NS
 	.ns.ops = &pidns_operations,
 #endif
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
+	.memfd_noexec_scope = MEMFD_NOEXEC_SCOPE_EXEC,
+#endif
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
--- a/kernel/pid_namespace.c~memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy
+++ a/kernel/pid_namespace.c
@@ -110,9 +110,9 @@ static struct pid_namespace *create_pid_
 	ns->user_ns = get_user_ns(user_ns);
 	ns->ucounts = ucounts;
 	ns->pid_allocated = PIDNS_ADDING;
-
-	initialize_memfd_noexec_scope(ns);
-
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
+	ns->memfd_noexec_scope = pidns_memfd_noexec_scope(parent_pid_ns);
+#endif
 	return ns;
 
 out_free_idr:
--- a/kernel/pid_sysctl.h~memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy
+++ a/kernel/pid_sysctl.h
@@ -5,33 +5,30 @@
 #include <linux/pid_namespace.h>
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
-static inline void initialize_memfd_noexec_scope(struct pid_namespace *ns)
-{
-	ns->memfd_noexec_scope =
-		task_active_pid_ns(current)->memfd_noexec_scope;
-}
-
 static int pid_mfd_noexec_dointvec_minmax(struct ctl_table *table,
 	int write, void *buf, size_t *lenp, loff_t *ppos)
 {
 	struct pid_namespace *ns = task_active_pid_ns(current);
 	struct ctl_table table_copy;
+	int err, scope, parent_scope;
 
 	if (write && !ns_capable(ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	table_copy = *table;
-	if (ns != &init_pid_ns)
-		table_copy.data = &ns->memfd_noexec_scope;
-
-	/*
-	 * set minimum to current value, the effect is only bigger
-	 * value is accepted.
-	 */
-	if (*(int *)table_copy.data > *(int *)table_copy.extra1)
-		table_copy.extra1 = table_copy.data;
 
-	return proc_dointvec_minmax(&table_copy, write, buf, lenp, ppos);
+	/* You cannot set a lower enforcement value than your parent. */
+	parent_scope = pidns_memfd_noexec_scope(ns->parent);
+	/* Equivalent to pidns_memfd_noexec_scope(ns). */
+	scope = max(READ_ONCE(ns->memfd_noexec_scope), parent_scope);
+
+	table_copy.data = &scope;
+	table_copy.extra1 = &parent_scope;
+
+	err = proc_dointvec_minmax(&table_copy, write, buf, lenp, ppos);
+	if (!err && write)
+		WRITE_ONCE(ns->memfd_noexec_scope, scope);
+	return err;
 }
 
 static struct ctl_table pid_ns_ctl_table_vm[] = {
@@ -51,7 +48,6 @@ static inline void register_pid_ns_sysct
 	register_sysctl("vm", pid_ns_ctl_table_vm);
 }
 #else
-static inline void initialize_memfd_noexec_scope(struct pid_namespace *ns) {}
 static inline void register_pid_ns_sysctl_table_vm(void) {}
 #endif
 
--- a/mm/memfd.c~memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy
+++ a/mm/memfd.c
@@ -271,7 +271,8 @@ long memfd_fcntl(struct file *file, unsi
 static int check_sysctl_memfd_noexec(unsigned int *flags)
 {
 #ifdef CONFIG_SYSCTL
-	int sysctl = task_active_pid_ns(current)->memfd_noexec_scope;
+	struct pid_namespace *ns = task_active_pid_ns(current);
+	int sysctl = pidns_memfd_noexec_scope(ns);
 
 	if (!(*flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
 		if (sysctl >= MEMFD_NOEXEC_SCOPE_NOEXEC_SEAL)
_

Patches currently in -mm which might be from cyphar@cyphar.com are

selftests-memfd-error-out-test-process-when-child-test-fails.patch
memfd-do-not-eacces-old-memfd_create-users-with-vmmemfd_noexec=2.patch
memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch
memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy.patch
selftests-improve-vmmemfd_noexec-sysctl-tests.patch

