Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B8DC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjBCGvk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjBCGvO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82C64FC22
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F50CB82989
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7A9C433EF;
        Fri,  3 Feb 2023 06:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407068;
        bh=SlPNwStmF2BytKEV0J0m3tBAGnBvCyfUr6GJ2OvN4Rs=;
        h=Date:To:From:Subject:From;
        b=ayCCAXt7pjBr+5m3rGLyu6tdcoVogZSSQDV4nPb/foPvJi0IC2RIUlye1TTfjGGbe
         6tf9Y1FYicWdsb3WngFuVUBNjYbKbyfDj1Z/VgLZChnjFdRc1/0xD6Cm84jD1seAlk
         qpvj9F8bhR+P8bXi+FB/Dky4jHN3UmmVWm4NN7+A=
Date:   Thu, 02 Feb 2023 22:51:07 -0800
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        senozhatsky@chromium.org, rostedt@goodmis.org, prudo@redhat.com,
        joel@joelfernandes.org, gpiccoli@igalia.com, ebiederm@xmission.com,
        corbet@lwn.net, bhe@redhat.com, bagasdotme@gmail.com,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-factor-out-kexec_load_permitted.patch removed from -mm tree
Message-Id: <20230203065107.EF7A9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: factor out kexec_load_permitted
has been removed from the -mm tree.  Its filename was
     kexec-factor-out-kexec_load_permitted.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


