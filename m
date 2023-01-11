Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0672AC46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 00:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbjAKAT2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 19:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbjAKATJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 19:19:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1155958D
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 16:19:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E6656194C
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 00:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF420C433EF;
        Wed, 11 Jan 2023 00:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673396347;
        bh=J7PyvRVWwUq6c/eteurSvfxAjbnRqaHTlrdzV0HWypc=;
        h=Date:To:From:Subject:From;
        b=YNYC214CujuugwGHqyDZn/0HSvzXsMromPxSI/vCeKElAXzJmSF2ko4N8WE+T4NwZ
         nGO+S+8PjyJuFrRT+7xT18w3kW1e6FGqc0eJFIKGRSvNTfAzT8J/pSRpntjKP7melE
         UlQ0VNq1l17zr8uEENFFV2KZxE/ragQ/gt7HTrsc=
Date:   Tue, 10 Jan 2023 16:19:07 -0800
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        senozhatsky@chromium.org, rostedt@goodmis.org, prudo@redhat.com,
        joel@joelfernandes.org, gpiccoli@igalia.com, ebiederm@xmission.com,
        corbet@lwn.net, bhe@redhat.com, bagasdotme@gmail.com,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-introduce-sysctl-parameters-kexec_load_limit_.patch added to mm-nonmm-unstable branch
Message-Id: <20230111001907.BF420C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: introduce sysctl parameters kexec_load_limit_*
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-introduce-sysctl-parameters-kexec_load_limit_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-introduce-sysctl-parameters-kexec_load_limit_.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ricardo Ribalda <ribalda@chromium.org>
Subject: kexec: introduce sysctl parameters kexec_load_limit_*
Date: Wed, 04 Jan 2023 15:38:48 +0100

kexec allows replacing the current kernel with a different one.  This is
usually a source of concerns for sysadmins that want to harden a system.

Linux already provides a way to disable loading new kexec kernel via
kexec_load_disabled, but that control is very coard, it is all or nothing
and does not make distinction between a panic kexec and a normal kexec.

This patch introduces new sysctl parameters, with finner tunning to
specify how many times a kexec kernel can be loaded.  The sysadmin can set
different limits for kexec panic and kexec reboot kernels.  The value can
be modified at runtime via sysctl, but only with a stricter value.

With these new parameters on place, a system with loadpin and verity
enabled, using the following kernel parameters:
sysctl.kexec_load_limit_reboot=0 sysct.kexec_load_limit_panic=1 can have a
good warranty that if initrd tries to load a panic kernel, a malitious
user will have small chances to replace that kernel with a different one,
even if they can trigger timeouts on the disk where the panic kernel
lives.

Link: https://lkml.kernel.org/r/20221114-disable-kexec-reset-v6-3-6a8531a09b9a@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com> # Steam Deck
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |   18 +++
 include/linux/kexec.h                       |    2 
 kernel/kexec.c                              |    4 
 kernel/kexec_core.c                         |   87 +++++++++++++++++-
 kernel/kexec_file.c                         |   11 +-
 5 files changed, 114 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~kexec-introduce-sysctl-parameters-kexec_load_limit_
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -464,6 +464,24 @@ allowing a system to set up (and later u
 altered.
 Generally used together with the `modules_disabled`_ sysctl.
 
+kexec_load_limit_panic
+======================
+
+This parameter specifies a limit to the number of times the syscalls
+``kexec_load`` and ``kexec_file_load`` can be called with a crash
+image. It can only be set with a more restrictive value than the
+current one.
+
+== ======================================================
+-1 Unlimited calls to kexec. This is the default setting.
+N  Number of calls left.
+== ======================================================
+
+kexec_load_limit_reboot
+=======================
+
+Similar functionality as ``kexec_load_limit_panic``, but for a normal
+image.
 
 kptr_restrict
 =============
--- a/include/linux/kexec.h~kexec-introduce-sysctl-parameters-kexec_load_limit_
+++ a/include/linux/kexec.h
@@ -404,7 +404,7 @@ extern int kimage_crash_copy_vmcoreinfo(
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
 
-bool kexec_load_permitted(void);
+bool kexec_load_permitted(int kexec_image_type);
 
 #ifndef kexec_flush_icache_page
 #define kexec_flush_icache_page(page)
--- a/kernel/kexec.c~kexec-introduce-sysctl-parameters-kexec_load_limit_
+++ a/kernel/kexec.c
@@ -190,10 +190,12 @@ out_unlock:
 static inline int kexec_load_check(unsigned long nr_segments,
 				   unsigned long flags)
 {
+	int image_type = (flags & KEXEC_ON_CRASH) ?
+			 KEXEC_TYPE_CRASH : KEXEC_TYPE_DEFAULT;
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!kexec_load_permitted())
+	if (!kexec_load_permitted(image_type))
 		return -EPERM;
 
 	/* Permit LSMs and IMA to fail the kexec */
--- a/kernel/kexec_core.c~kexec-introduce-sysctl-parameters-kexec_load_limit_
+++ a/kernel/kexec_core.c
@@ -920,10 +920,64 @@ int kimage_load_segment(struct kimage *i
 	return result;
 }
 
+struct kexec_load_limit {
+	/* Mutex protects the limit count. */
+	struct mutex mutex;
+	int limit;
+};
+
+static struct kexec_load_limit load_limit_reboot = {
+	.mutex = __MUTEX_INITIALIZER(load_limit_reboot.mutex),
+	.limit = -1,
+};
+
+static struct kexec_load_limit load_limit_panic = {
+	.mutex = __MUTEX_INITIALIZER(load_limit_panic.mutex),
+	.limit = -1,
+};
+
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
 static int kexec_load_disabled;
+
 #ifdef CONFIG_SYSCTL
+static int kexec_limit_handler(struct ctl_table *table, int write,
+			       void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct kexec_load_limit *limit = table->data;
+	int val;
+	struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(val),
+		.mode = table->mode,
+	};
+	int ret;
+
+	if (write) {
+		ret = proc_dointvec(&tmp, write, buffer, lenp, ppos);
+		if (ret)
+			return ret;
+
+		if (val < 0)
+			return -EINVAL;
+
+		mutex_lock(&limit->mutex);
+		if (limit->limit != -1 && val >= limit->limit)
+			ret = -EINVAL;
+		else
+			limit->limit = val;
+		mutex_unlock(&limit->mutex);
+
+		return ret;
+	}
+
+	mutex_lock(&limit->mutex);
+	val = limit->limit;
+	mutex_unlock(&limit->mutex);
+
+	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
+}
+
 static struct ctl_table kexec_core_sysctls[] = {
 	{
 		.procname	= "kexec_load_disabled",
@@ -935,6 +989,18 @@ static struct ctl_table kexec_core_sysct
 		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_ONE,
 	},
+	{
+		.procname	= "kexec_load_limit_panic",
+		.data		= &load_limit_panic,
+		.mode		= 0644,
+		.proc_handler	= kexec_limit_handler,
+	},
+	{
+		.procname	= "kexec_load_limit_reboot",
+		.data		= &load_limit_reboot,
+		.mode		= 0644,
+		.proc_handler	= kexec_limit_handler,
+	},
 	{ }
 };
 
@@ -946,13 +1012,30 @@ static int __init kexec_core_sysctl_init
 late_initcall(kexec_core_sysctl_init);
 #endif
 
-bool kexec_load_permitted(void)
+bool kexec_load_permitted(int kexec_image_type)
 {
+	struct kexec_load_limit *limit;
+
 	/*
 	 * Only the superuser can use the kexec syscall and if it has not
 	 * been disabled.
 	 */
-	return capable(CAP_SYS_BOOT) && !kexec_load_disabled;
+	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
+		return false;
+
+	/* Check limit counter and decrease it.*/
+	limit = (kexec_image_type == KEXEC_TYPE_CRASH) ?
+		&load_limit_panic : &load_limit_reboot;
+	mutex_lock(&limit->mutex);
+	if (!limit->limit) {
+		mutex_unlock(&limit->mutex);
+		return false;
+	}
+	if (limit->limit != -1)
+		limit->limit--;
+	mutex_unlock(&limit->mutex);
+
+	return true;
 }
 
 /*
--- a/kernel/kexec_file.c~kexec-introduce-sysctl-parameters-kexec_load_limit_
+++ a/kernel/kexec_file.c
@@ -326,11 +326,13 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 		unsigned long, cmdline_len, const char __user *, cmdline_ptr,
 		unsigned long, flags)
 {
-	int ret = 0, i;
+	int image_type = (flags & KEXEC_FILE_ON_CRASH) ?
+			 KEXEC_TYPE_CRASH : KEXEC_TYPE_DEFAULT;
 	struct kimage **dest_image, *image;
+	int ret = 0, i;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!kexec_load_permitted())
+	if (!kexec_load_permitted(image_type))
 		return -EPERM;
 
 	/* Make sure we have a legal set of flags */
@@ -342,11 +344,12 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 	if (!kexec_trylock())
 		return -EBUSY;
 
-	dest_image = &kexec_image;
-	if (flags & KEXEC_FILE_ON_CRASH) {
+	if (image_type == KEXEC_TYPE_CRASH) {
 		dest_image = &kexec_crash_image;
 		if (kexec_crash_image)
 			arch_kexec_unprotect_crashkres();
+	} else {
+		dest_image = &kexec_image;
 	}
 
 	if (flags & KEXEC_FILE_UNLOAD)
_

Patches currently in -mm which might be from ribalda@chromium.org are

scripts-spellingtxt-add-permitted.patch
kvm-x86-fix-trivial-typo.patch
documentation-sysctl-correct-kexec_load_disabled.patch
kexec-factor-out-kexec_load_permitted.patch
kexec-introduce-sysctl-parameters-kexec_load_limit_.patch

