Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A911DC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7DE222B3
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbhAQVf1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729348AbhAQVex (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:34:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3288C222B3;
        Sun, 17 Jan 2021 21:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610919250;
        bh=Gp92TlYjDJ3xoUjPJMYZsa7I15a+wCrs6+aoOL+Y5fo=;
        h=Date:From:To:Subject:From;
        b=FshCAxpfHQBbh0/qT5j3pg6emUQYc8cgv3Tej/oSGArVjdhIPgp5SxDL12+rwwXze
         uUrdXdsBEMQA2dH1i5HNVjR4+JXxXRDqeyeHWwAqKYf1pYMqHbuQoyFsuIkvge/U6r
         2cvA14vpJxYZeTCaiGUV6QPzqOIwsOeH2ttagHrM=
Date:   Sun, 17 Jan 2021 13:34:09 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, brho@google.com, f.fainelli@gmail.com,
        mm-commits@vger.kernel.org
Subject:  + initramfs-panic-with-memory-information.patch added to
 -mm tree
Message-ID: <20210117213409.5JKZxp3LN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: panic with memory information
has been added to the -mm tree.  Its filename is
     initramfs-panic-with-memory-information.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/initramfs-panic-with-memory-information.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/initramfs-panic-with-memory-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: initramfs: panic with memory information

On systems with large amounts of reserved memory we may fail to
successfully complete unpack_to_rootfs() and be left with:

 Kernel panic - not syncing: write error

this is not too helpful to understand what happened, so let's wrap the
panic() calls with a surrounding show_mem() such that we have a chance of
understanding the memory conditions leading to these allocation failures.

Link: https://lkml.kernel.org/r/20210114231517.1854379-1-f.fainelli@gmail.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Barret Rhoden <brho@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/init/initramfs.c~initramfs-panic-with-memory-information
+++ a/init/initramfs.c
@@ -11,6 +11,7 @@
 #include <linux/utime.h>
 #include <linux/file.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
 #include <linux/namei.h>
 #include <linux/init_syscalls.h>
 
@@ -45,6 +46,11 @@ static void __init error(char *x)
 		message = x;
 }
 
+#define panic_show_mem(...) {	\
+	show_mem(0, NULL);	\
+	panic(__VA_ARGS__);	\
+}
+
 /* link hash */
 
 #define N_ALIGN(len) ((((len) + 1) & ~3) + 2)
@@ -80,7 +86,7 @@ static char __init *find_link(int major,
 	}
 	q = kmalloc(sizeof(struct hash), GFP_KERNEL);
 	if (!q)
-		panic("can't allocate link hash entry");
+		panic_show_mem("can't allocate link hash entry");
 	q->major = major;
 	q->minor = minor;
 	q->ino = ino;
@@ -125,7 +131,7 @@ static void __init dir_add(const char *n
 {
 	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
 	if (!de)
-		panic("can't allocate dir_entry buffer");
+		panic_show_mem("can't allocate dir_entry buffer");
 	INIT_LIST_HEAD(&de->list);
 	de->name = kstrdup(name, GFP_KERNEL);
 	de->mtime = mtime;
@@ -460,7 +466,7 @@ static char * __init unpack_to_rootfs(ch
 	name_buf = kmalloc(N_ALIGN(PATH_MAX), GFP_KERNEL);
 
 	if (!header_buf || !symlink_buf || !name_buf)
-		panic("can't allocate buffers");
+		panic_show_mem("can't allocate buffers");
 
 	state = Start;
 	this_header = 0;
@@ -607,7 +613,7 @@ static int __init populate_rootfs(void)
 	/* Load the built in initramfs */
 	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
 	if (err)
-		panic("%s", err); /* Failed to decompress INTERNAL initramfs */
+		panic_show_mem("%s", err); /* Failed to decompress INTERNAL initramfs */
 
 	if (!initrd_start || IS_ENABLED(CONFIG_INITRAMFS_FORCE))
 		goto done;
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

initramfs-panic-with-memory-information.patch

