Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B34C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 03:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376767AbiEMDdF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 23:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376797AbiEMDdE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 23:33:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3BA10115C
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 20:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE76A61187
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 03:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F06DC34114;
        Fri, 13 May 2022 03:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652412782;
        bh=BB2KtlaO9/RvBcMIn2Q+xybYpmtkvgaVME5I/kFl0/w=;
        h=Date:To:From:Subject:From;
        b=rmJy0CqDWa4CPK5C9kZhsdD+GC+3c2dKvRFw20qvJg1j5PtSS6P2tFCS7HrwZXSVY
         BmKlZHMAsgLNiVvCi+Ny6XPqrdSOq1HSlRgrzu854no3HxTruKVbcXovQINPl53hY/
         aYXaXHnJD7p9MleH8WjhmNE0DKFprpYNWGcN3Su0=
Date:   Thu, 12 May 2022 20:33:01 -0700
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        ahalaney@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] init-mainc-silence-some-wunused-parameter-warnings.patch removed from -mm tree
Message-Id: <20220513033302.2F06DC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init/main.c: silence some -Wunused-parameter warnings
has been removed from the -mm tree.  Its filename was
     init-mainc-silence-some-wunused-parameter-warnings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Halaney <ahalaney@redhat.com>
Subject: init/main.c: silence some -Wunused-parameter warnings

There are a bunch of callbacks with unused arguments, go ahead and silence
those so "make KCFLAGS=-W init/main.o" is a little quieter.  Here's a
little sample:

init/main.c:182:43: warning: unused parameter 'str' [-Wunused-parameter]
static int __init set_reset_devices(char *str)

Link: https://lkml.kernel.org/r/20210519162341.1275452-1-ahalaney@redhat.com
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/init/main.c~init-mainc-silence-some-wunused-parameter-warnings
+++ a/init/main.c
@@ -182,7 +182,7 @@ EXPORT_SYMBOL_GPL(static_key_initialized
 unsigned int reset_devices;
 EXPORT_SYMBOL(reset_devices);
 
-static int __init set_reset_devices(char *str)
+static int __init set_reset_devices(char *str __always_unused)
 {
 	reset_devices = 1;
 	return 1;
@@ -232,13 +232,13 @@ static bool __init obsolete_checksetup(c
 unsigned long loops_per_jiffy = (1<<12);
 EXPORT_SYMBOL(loops_per_jiffy);
 
-static int __init debug_kernel(char *str)
+static int __init debug_kernel(char *str __always_unused)
 {
 	console_loglevel = CONSOLE_LOGLEVEL_DEBUG;
 	return 0;
 }
 
-static int __init quiet_kernel(char *str)
+static int __init quiet_kernel(char *str __always_unused)
 {
 	console_loglevel = CONSOLE_LOGLEVEL_QUIET;
 	return 0;
@@ -475,7 +475,7 @@ static void __init setup_boot_config(voi
 	get_boot_config_from_initrd(NULL, NULL);
 }
 
-static int __init warn_bootconfig(char *str)
+static int __init warn_bootconfig(char *str __always_unused)
 {
 	pr_warn("WARNING: 'bootconfig' found on the kernel command line but CONFIG_BOOT_CONFIG is not set.\n");
 	return 0;
@@ -504,7 +504,8 @@ static void __init repair_env_string(cha
 
 /* Anything after -- gets handed straight to init. */
 static int __init set_init_arg(char *param, char *val,
-			       const char *unused, void *arg)
+			       const char *unused __always_unused,
+			       void *arg __always_unused)
 {
 	unsigned int i;
 
@@ -529,7 +530,8 @@ static int __init set_init_arg(char *par
  * unused parameters (modprobe will find them in /proc/cmdline).
  */
 static int __init unknown_bootoption(char *param, char *val,
-				     const char *unused, void *arg)
+				     const char *unused __always_unused,
+				     void *arg __always_unused)
 {
 	size_t len = strlen(param);
 
@@ -729,7 +731,8 @@ noinline void __ref rest_init(void)
 
 /* Check for early params. */
 static int __init do_early_param(char *param, char *val,
-				 const char *unused, void *arg)
+				 const char *unused __always_unused,
+				 void *arg __always_unused)
 {
 	const struct obs_kernel_param *p;
 
@@ -1352,8 +1355,10 @@ static const char *initcall_level_names[
 	"late",
 };
 
-static int __init ignore_unknown_bootoption(char *param, char *val,
-			       const char *unused, void *arg)
+static int __init ignore_unknown_bootoption(char *param __always_unused,
+					    char *val __always_unused,
+					    const char *unused __always_unused,
+					    void *arg __always_unused)
 {
 	return 0;
 }
@@ -1492,7 +1497,7 @@ void __weak free_initmem(void)
 	free_initmem_default(POISON_FREE_INITMEM);
 }
 
-static int __ref kernel_init(void *unused)
+static int __ref kernel_init(void *unused __always_unused)
 {
 	int ret;
 
_

Patches currently in -mm which might be from ahalaney@redhat.com are


