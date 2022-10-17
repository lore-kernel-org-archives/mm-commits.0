Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472BEC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 02:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiJQCad (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 22:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiJQCab (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 22:30:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEE62B18E
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 19:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9402DB80E57
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 02:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E6EC433D6;
        Mon, 17 Oct 2022 02:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665973828;
        bh=/UrKjfntHlmx4T4BH2quBgDmICpn93B80VeJLRko+OY=;
        h=Date:To:From:Subject:From;
        b=kw1Adu8xw6GftZryPYCuU7Czw0EPX5fURadqxXqwcWGETVk/Hoh3C2vSCNcs//em4
         hBVKfSsrYd2CoUdCpBrGBXigWUTvImQWt12jSN5LoxuAtcC4nZHEN8nUzabLHzOXmd
         p0MssZho4rHTZzCU1KkFWpxi12sQRe6+qc55jlPw=
Date:   Sun, 16 Oct 2022 19:30:27 -0700
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        ahalaney@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] init-mainc-silence-some-wunused-parameter-warnings.patch removed from -mm tree
Message-Id: <20221017023028.46E6EC433D6@smtp.kernel.org>
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
@@ -184,7 +184,7 @@ EXPORT_SYMBOL_GPL(static_key_initialized
 unsigned int reset_devices;
 EXPORT_SYMBOL(reset_devices);
 
-static int __init set_reset_devices(char *str)
+static int __init set_reset_devices(char *str __always_unused)
 {
 	reset_devices = 1;
 	return 1;
@@ -234,13 +234,13 @@ static bool __init obsolete_checksetup(c
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
@@ -477,7 +477,7 @@ static void __init setup_boot_config(voi
 	get_boot_config_from_initrd(NULL);
 }
 
-static int __init warn_bootconfig(char *str)
+static int __init warn_bootconfig(char *str __always_unused)
 {
 	pr_warn("WARNING: 'bootconfig' found on the kernel command line but CONFIG_BOOT_CONFIG is not set.\n");
 	return 0;
@@ -506,7 +506,8 @@ static void __init repair_env_string(cha
 
 /* Anything after -- gets handed straight to init. */
 static int __init set_init_arg(char *param, char *val,
-			       const char *unused, void *arg)
+			       const char *unused __always_unused,
+			       void *arg __always_unused)
 {
 	unsigned int i;
 
@@ -531,7 +532,8 @@ static int __init set_init_arg(char *par
  * unused parameters (modprobe will find them in /proc/cmdline).
  */
 static int __init unknown_bootoption(char *param, char *val,
-				     const char *unused, void *arg)
+				     const char *unused __always_unused,
+				     void *arg __always_unused)
 {
 	size_t len = strlen(param);
 
@@ -731,7 +733,8 @@ noinline void __ref rest_init(void)
 
 /* Check for early params. */
 static int __init do_early_param(char *param, char *val,
-				 const char *unused, void *arg)
+				 const char *unused __always_unused,
+				 void *arg __always_unused)
 {
 	const struct obs_kernel_param *p;
 
@@ -1355,8 +1358,10 @@ static const char *initcall_level_names[
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
@@ -1507,7 +1512,7 @@ void __weak free_initmem(void)
 	free_initmem_default(POISON_FREE_INITMEM);
 }
 
-static int __ref kernel_init(void *unused)
+static int __ref kernel_init(void *unused __always_unused)
 {
 	int ret;
 
_

Patches currently in -mm which might be from ahalaney@redhat.com are


