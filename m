Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FB5C61DB3
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 00:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbjAKAT3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 19:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbjAKATJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 19:19:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759DEBF6F
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 16:19:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B5E1B81A1F
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 00:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEADC433D2;
        Wed, 11 Jan 2023 00:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673396344;
        bh=NB+RAYeiz2dECbhoFXofinXROuQ6WPcLmYtVzPWh2eE=;
        h=Date:To:From:Subject:From;
        b=H54dS3cDoStDdJBkzJUd259nOhcCLITn8M3Uu6mI2znq7C5bvFGsQTtj4A7UFe0Hv
         7SK8ZpnhHuXm+c85x8z3yL1fRZ9eBedCnsGLr1Tc1sreXlEXCoMxXCa1PWGUzICHpK
         U2vhqslDzHMFi5i9NhJaU0Z3bTcvnWqoRexWdIhU=
Date:   Tue, 10 Jan 2023 16:19:04 -0800
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        senozhatsky@chromium.org, rostedt@goodmis.org, prudo@redhat.com,
        joel@joelfernandes.org, gpiccoli@igalia.com, ebiederm@xmission.com,
        corbet@lwn.net, bhe@redhat.com, bagasdotme@gmail.com,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-factor-out-kexec_load_permitted.patch added to mm-nonmm-unstable branch
Message-Id: <20230111001904.BDEADC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: factor out kexec_load_permitted
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-factor-out-kexec_load_permitted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-factor-out-kexec_load_permitted.patch

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
Subject: kexec: factor out kexec_load_permitted
Date: Wed, 04 Jan 2023 15:38:47 +0100

Both syscalls (kexec and kexec_file) do the same check, let's factor it
out.

Link: https://lkml.kernel.org/r/20221114-disable-kexec-reset-v6-2-6a8531a09b9a@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    3 ++-
 kernel/kexec.c        |    2 +-
 kernel/kexec_core.c   |   11 ++++++++++-
 kernel/kexec_file.c   |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

--- a/include/linux/kexec.h~kexec-factor-out-kexec_load_permitted
+++ a/include/linux/kexec.h
@@ -403,7 +403,8 @@ extern int kimage_crash_copy_vmcoreinfo(
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
-extern int kexec_load_disabled;
+
+bool kexec_load_permitted(void);
 
 #ifndef kexec_flush_icache_page
 #define kexec_flush_icache_page(page)
--- a/kernel/kexec.c~kexec-factor-out-kexec_load_permitted
+++ a/kernel/kexec.c
@@ -193,7 +193,7 @@ static inline int kexec_load_check(unsig
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
+	if (!kexec_load_permitted())
 		return -EPERM;
 
 	/* Permit LSMs and IMA to fail the kexec */
--- a/kernel/kexec_core.c~kexec-factor-out-kexec_load_permitted
+++ a/kernel/kexec_core.c
@@ -922,7 +922,7 @@ int kimage_load_segment(struct kimage *i
 
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
-int kexec_load_disabled;
+static int kexec_load_disabled;
 #ifdef CONFIG_SYSCTL
 static struct ctl_table kexec_core_sysctls[] = {
 	{
@@ -946,6 +946,15 @@ static int __init kexec_core_sysctl_init
 late_initcall(kexec_core_sysctl_init);
 #endif
 
+bool kexec_load_permitted(void)
+{
+	/*
+	 * Only the superuser can use the kexec syscall and if it has not
+	 * been disabled.
+	 */
+	return capable(CAP_SYS_BOOT) && !kexec_load_disabled;
+}
+
 /*
  * No panic_cpu check version of crash_kexec().  This function is called
  * only when panic_cpu holds the current CPU number; this is the only CPU
--- a/kernel/kexec_file.c~kexec-factor-out-kexec_load_permitted
+++ a/kernel/kexec_file.c
@@ -330,7 +330,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 	struct kimage **dest_image, *image;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
+	if (!kexec_load_permitted())
 		return -EPERM;
 
 	/* Make sure we have a legal set of flags */
_

Patches currently in -mm which might be from ribalda@chromium.org are

scripts-spellingtxt-add-permitted.patch
kvm-x86-fix-trivial-typo.patch
documentation-sysctl-correct-kexec_load_disabled.patch
kexec-factor-out-kexec_load_permitted.patch
kexec-introduce-sysctl-parameters-kexec_load_limit_.patch

