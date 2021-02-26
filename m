Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FC4C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8908D64EFA
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBZBXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhBZBX3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B724D64F21;
        Fri, 26 Feb 2021 01:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302567;
        bh=Z4OZFLP4p2Slm9Zm3Lpu1TBStzSfdRWcR5QaR4MZnxs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UEOJVATUPCRD62DAUV4W4PahCBgTEc8lB0DxUtnTzIyqYAWXbx4igVX2U+3JUypEa
         qR0xEjnumczZ9v1jrA0VWn2dd/ch+4WKkquAbeDMT0Wd/nv+4YwHjTOqEHUrtFBqkp
         VnGZTTjmaLK0K5/Y/z21k+cL6WI2l7FWr0NtlGww=
Date:   Thu, 25 Feb 2021 17:22:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, brho@google.com,
        f.fainelli@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 117/118] initramfs: panic with memory information
Message-ID: <20210226012246.rwUstM4sZ%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Subject: initramfs: panic with memory information

On systems with large amounts of reserved memory we may fail to
successfully complete unpack_to_rootfs() and be left with:

 Kernel panic - not syncing: write error

this is not too helpful to understand what happened, so let's wrap the
panic() calls with a surrounding show_mem() such that we have a chance of
understanding the memory conditions leading to these allocation failures.

[akpm@linux-foundation.org: replace macro with C function]
Link: https://lkml.kernel.org/r/20210114231517.1854379-1-f.fainelli@gmail.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Barret Rhoden <brho@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/init/initramfs.c~initramfs-panic-with-memory-information
+++ a/init/initramfs.c
@@ -11,6 +11,7 @@
 #include <linux/utime.h>
 #include <linux/file.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
 #include <linux/namei.h>
 #include <linux/init_syscalls.h>
 
@@ -45,6 +46,16 @@ static void __init error(char *x)
 		message = x;
 }
 
+static void panic_show_mem(const char *fmt, ...)
+{
+	va_list args;
+
+	show_mem(0, NULL);
+	va_start(args, fmt);
+	panic(fmt, args);
+	va_end(args);
+}
+
 /* link hash */
 
 #define N_ALIGN(len) ((((len) + 1) & ~3) + 2)
@@ -80,7 +91,7 @@ static char __init *find_link(int major,
 	}
 	q = kmalloc(sizeof(struct hash), GFP_KERNEL);
 	if (!q)
-		panic("can't allocate link hash entry");
+		panic_show_mem("can't allocate link hash entry");
 	q->major = major;
 	q->minor = minor;
 	q->ino = ino;
@@ -125,7 +136,7 @@ static void __init dir_add(const char *n
 {
 	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
 	if (!de)
-		panic("can't allocate dir_entry buffer");
+		panic_show_mem("can't allocate dir_entry buffer");
 	INIT_LIST_HEAD(&de->list);
 	de->name = kstrdup(name, GFP_KERNEL);
 	de->mtime = mtime;
@@ -460,7 +471,7 @@ static char * __init unpack_to_rootfs(ch
 	name_buf = kmalloc(N_ALIGN(PATH_MAX), GFP_KERNEL);
 
 	if (!header_buf || !symlink_buf || !name_buf)
-		panic("can't allocate buffers");
+		panic_show_mem("can't allocate buffers");
 
 	state = Start;
 	this_header = 0;
@@ -607,7 +618,7 @@ static int __init populate_rootfs(void)
 	/* Load the built in initramfs */
 	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
 	if (err)
-		panic("%s", err); /* Failed to decompress INTERNAL initramfs */
+		panic_show_mem("%s", err); /* Failed to decompress INTERNAL initramfs */
 
 	if (!initrd_start || IS_ENABLED(CONFIG_INITRAMFS_FORCE))
 		goto done;
_
