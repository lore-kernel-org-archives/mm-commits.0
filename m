Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E2AC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 18:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A883461059
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 18:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhG1Syb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jul 2021 14:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230164AbhG1Syb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jul 2021 14:54:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E08A60F9B;
        Wed, 28 Jul 2021 18:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627498469;
        bh=Li2qvWKQllxhB0MLpub7RdvH+UveZIJwvMeNsojrzLc=;
        h=Date:From:To:Subject:From;
        b=MOat69hZ77ajXCPMFE4gkqR4+gvi73YNa7ycFZznGxwAQC/TmwflFBc6fp22IVatm
         Xu8BCHzJX0T7zX174dw028oXe8dr1LziaB9fbw4UbOe6xz4reYIhL8/NX2NgjDKvMF
         4zX+M5S2eGm1XWKejy6oCmFPmZ9a7ZM9TiqNPUNo=
Date:   Wed, 28 Jul 2021 11:54:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        hkallweit1@gmail.com, egorenar@linux.ibm.com, bgoncalv@redhat.com,
        linux@rasmusvillemoes.dk
Subject:  + init-move-usermodehelper_enable-to-populate_rootfs.patch
 added to -mm tree
Message-ID: <20210728185429.gIOLR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: move usermodehelper_enable() to populate_rootfs()
has been added to the -mm tree.  Its filename is
     init-move-usermodehelper_enable-to-populate_rootfs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-move-usermodehelper_enable-to-populate_rootfs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-move-usermodehelper_enable-to-populate_rootfs.patch

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
Subject: init: move usermodehelper_enable() to populate_rootfs()

Currently, usermodehelper is enabled right before PID1 starts going
through the initcalls. However, any call of a usermodehelper from a
pure_, core_, postcore_, arch_, subsys_ or fs_ initcall is futile, as
there is no filesystem contents yet.

Up until commit e7cb072eb988 ("init/initramfs.c: do unpacking
asynchronously"), such calls, whether via some request_module(), a
legacy uevent "/sbin/hotplug" notification or something else, would
just fail silently with (presumably) -ENOENT from
kernel_execve(). However, that commit introduced the
wait_for_initramfs() synchronization hook which must be called from
the usermodehelper exec path right before the kernel_execve, in order
that request_module() et al done from *after* rootfs_initcall()
time (i.e. device_ and late_ initcalls) would continue to find a
populated initramfs as they used to.

Any call of wait_for_initramfs() done before the unpacking has been
scheduled (i.e. before rootfs_initcall time) must just return
immediately [and let the caller find an empty file system] in order
not to deadlock the machine. I mistakenly thought, and my limited
testing confirmed, that there were no such calls, so I added a
pr_warn_once() in wait_for_initramfs(). It turns out that one can
indeed hit request_module() as well as kobject_uevent_env() during
those early init calls, leading to a user-visible warning in the
kernel log emitted consistently for certain configurations.

We could just remove the pr_warn_once(), but I think it's better to
postpone enabling the usermodehelper framework until there is at least
some chance of finding the executable. That is also a little more
efficient in that a lot of work done in umh.c will be elided. However,
it does change the error seen by those early callers from -ENOENT to
-EBUSY, so there is a risk of a regression if any caller care about
the exact error value.

Link: https://lkml.kernel.org/r/20210728134638.329060-1-linux@rasmusvillemoes.dk
Fixes: e7cb072eb988 ("init/initramfs.c: do unpacking asynchronously")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c   |    2 ++
 init/main.c        |    1 -
 init/noinitramfs.c |    2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/init/initramfs.c~init-move-usermodehelper_enable-to-populate_rootfs
+++ a/init/initramfs.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/namei.h>
 #include <linux/init_syscalls.h>
+#include <linux/umh.h>
 
 static ssize_t __init xwrite(struct file *file, const char *p, size_t count,
 		loff_t *pos)
@@ -727,6 +728,7 @@ static int __init populate_rootfs(void)
 {
 	initramfs_cookie = async_schedule_domain(do_populate_rootfs, NULL,
 						 &initramfs_domain);
+	usermodehelper_enable();
 	if (!initramfs_async)
 		wait_for_initramfs();
 	return 0;
--- a/init/main.c~init-move-usermodehelper_enable-to-populate_rootfs
+++ a/init/main.c
@@ -1387,7 +1387,6 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_ctors();
-	usermodehelper_enable();
 	do_initcalls();
 }
 
--- a/init/noinitramfs.c~init-move-usermodehelper_enable-to-populate_rootfs
+++ a/init/noinitramfs.c
@@ -10,6 +10,7 @@
 #include <linux/kdev_t.h>
 #include <linux/syscalls.h>
 #include <linux/init_syscalls.h>
+#include <linux/umh.h>
 
 /*
  * Create a simple rootfs that is similar to the default initramfs
@@ -18,6 +19,7 @@ static int __init default_rootfs(void)
 {
 	int err;
 
+	usermodehelper_enable();
 	err = init_mkdir("/dev", 0755);
 	if (err < 0)
 		goto out;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

init-move-usermodehelper_enable-to-populate_rootfs.patch

