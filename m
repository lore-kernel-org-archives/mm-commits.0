Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BEEC433DB
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DEB64F5F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCOWuK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 18:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhCOWtq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 18:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EFE964F51;
        Mon, 15 Mar 2021 22:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615848586;
        bh=nKRLm61RTY8MCEliUAnU9kTjcgjp8rkuJ4TYk7JfeNc=;
        h=Date:From:To:Subject:From;
        b=Q+DXstRxGsQo8WNSUjzfWuwOAlCz6jrcYsdOJvhTD/ZZBcR9ojPkxHzCnofJIfkrX
         2KmfX/Eb342eXuX7tdqcGWxZ+1StEqEgi6Z4r12Amez/+giG835GcHDQbzxr3PWFKo
         7hEdqUadIfsVriScUWnGg1TZA0qoWCps7+qCut8c=
Date:   Mon, 15 Mar 2021 15:49:45 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, corbet@lwn.net, gregkh@linuxfoundation.org,
        jeyu@kernel.org, linux@rasmusvillemoes.dk, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, ndesaulniers@google.com, tiwai@suse.de
Subject:  + modules-add-config_modprobe_path.patch added to -mm
 tree
Message-ID: <20210315224945.50JS5m_-k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: modules: add CONFIG_MODPROBE_PATH
has been added to the -mm tree.  Its filename is
     modules-add-config_modprobe_path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/modules-add-config_modprobe_path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/modules-add-config_modprobe_path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: modules: add CONFIG_MODPROBE_PATH

Allow the developer to specifiy the initial value of the modprobe_path[]
string.  This can be used to set it to the empty string initially, thus
effectively disabling request_module() during early boot until userspace
writes a new value via the /proc/sys/kernel/modprobe interface.  [1]

When building a custom kernel (often for an embedded target), it's normal
to build everything into the kernel that is needed for booting, and indeed
the initramfs often contains no modules at all, so every such
request_module() done before userspace init has mounted the real rootfs is
a waste of time.

This is particularly useful when combined with the previous patch, which
made the initramfs unpacking asynchronous - for that to work, it had to
make any usermodehelper call wait for the unpacking to finish before
attempting to invoke the userspace helper.  By eliminating all such
(known-to-be-futile) calls of usermodehelper, the initramfs unpacking and
the {device,late}_initcalls can proceed in parallel for much longer.

For a relatively slow ppc board I'm working on, the two patches combined
lead to 0.2s faster boot - but more importantly, the fact that the
initramfs unpacking proceeds completely in the background while devices
get probed means I get to handle the gpio watchdog in time without getting
reset.

[1] __request_module() already has an early -ENOENT return when
modprobe_path is the empty string.

Link: https://lkml.kernel.org/r/20210313212528.2956377-3-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Jessica Yu <jeyu@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig  |   12 ++++++++++++
 kernel/kmod.c |    2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/init/Kconfig~modules-add-config_modprobe_path
+++ a/init/Kconfig
@@ -2268,6 +2268,18 @@ config MODULE_ALLOW_MISSING_NAMESPACE_IM
 
 	  If unsure, say N.
 
+config MODPROBE_PATH
+	string "Path to modprobe binary"
+	default "/sbin/modprobe"
+	help
+	  When kernel code requests a module, it does so by calling
+	  the "modprobe" userspace utility. This option allows you to
+	  set the path where that binary is found. This can be changed
+	  at runtime via the sysctl file
+	  /proc/sys/kernel/modprobe. Setting this to the empty string
+	  removes the kernel's ability to request modules (but
+	  userspace can still load modules explicitly).
+
 config TRIM_UNUSED_KSYMS
 	bool "Trim unused exported kernel symbols" if EXPERT
 	depends on !COMPILE_TEST
--- a/kernel/kmod.c~modules-add-config_modprobe_path
+++ a/kernel/kmod.c
@@ -58,7 +58,7 @@ static DECLARE_WAIT_QUEUE_HEAD(kmod_wq);
 /*
 	modprobe_path is set via /proc/sys.
 */
-char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
+char modprobe_path[KMOD_PATH_LEN] = CONFIG_MODPROBE_PATH;
 
 static void free_modprobe_argv(struct subprocess_info *info)
 {
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

kernel-asyncc-fix-pr_debug-statement.patch
kernel-credc-make-init_groups-static.patch
kernel-asyncc-stop-guarding-pr_debug-statements.patch
kernel-asyncc-remove-async_unregister_domain.patch
init-initramfsc-do-unpacking-asynchronously.patch
modules-add-config_modprobe_path.patch

