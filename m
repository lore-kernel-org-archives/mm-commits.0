Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7D2C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 04:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF89D611C2
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 04:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhETEjV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 00:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhETEjV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 00:39:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937DE611BD;
        Thu, 20 May 2021 04:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621485480;
        bh=P8R3opN2ALP84VDdSfKxHk/bpH+DF/1/o0s3bB6gdVY=;
        h=Date:From:To:Subject:From;
        b=N/ew+SaPqMoojLjsk2XTND5yzuoLNyOEKqbUymNaEBxSFjB+B59V8LoOODVsy57Dy
         dMh4KdNEUzkpZXSzM0cSV35PgTO5RMJCqtguMKbyssPfeYegFxuO7kRiBdao1yMh3/
         95tL5vbrITcuf2STXBINDbetAzvbFeYQWDJAOcKw=
Date:   Wed, 19 May 2021 21:38:00 -0700
From:   akpm@linux-foundation.org
To:     ahalaney@redhat.com, mm-commits@vger.kernel.org
Subject:  +
 init-mainc-silence-some-wunused-parameter-warnings.patch added to -mm tree
Message-ID: <20210520043800.S01E6fwbk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: silence some -Wunused-parameter warnings
has been added to the -mm tree.  Its filename is
     init-mainc-silence-some-wunused-parameter-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-mainc-silence-some-wunused-parameter-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-silence-some-wunused-parameter-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/init/main.c~init-mainc-silence-some-wunused-parameter-warnings
+++ a/init/main.c
@@ -179,7 +179,7 @@ EXPORT_SYMBOL_GPL(static_key_initialized
 unsigned int reset_devices;
 EXPORT_SYMBOL(reset_devices);
 
-static int __init set_reset_devices(char *str)
+static int __init set_reset_devices(char *str __always_unused)
 {
 	reset_devices = 1;
 	return 1;
@@ -229,13 +229,13 @@ static bool __init obsolete_checksetup(c
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
@@ -478,7 +478,7 @@ static void __init setup_boot_config(voi
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
 
@@ -723,7 +725,8 @@ noinline void __ref rest_init(void)
 
 /* Check for early params. */
 static int __init do_early_param(char *param, char *val,
-				 const char *unused, void *arg)
+				 const char *unused __always_unused,
+				 void *arg __always_unused)
 {
 	const struct obs_kernel_param *p;
 
@@ -1343,8 +1346,10 @@ static const char *initcall_level_names[
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
@@ -1482,7 +1487,7 @@ void __weak free_initmem(void)
 	free_initmem_default(POISON_FREE_INITMEM);
 }
 
-static int __ref kernel_init(void *unused)
+static int __ref kernel_init(void *unused __always_unused)
 {
 	int ret;
 
_

Patches currently in -mm which might be from ahalaney@redhat.com are

init-print-out-unknown-kernel-parameters.patch
init-mainc-silence-some-wunused-parameter-warnings.patch

