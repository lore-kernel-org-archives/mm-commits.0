Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB869C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE9164E2B
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhBZAwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:52:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhBZAwU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:52:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5300464DA3;
        Fri, 26 Feb 2021 00:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300700;
        bh=prLfTLhZnjbfgyyaIzE3hOKn0TE0eKvNuEqNuXHMRAI=;
        h=Date:From:To:Subject:From;
        b=V117tRyml830zbmrpNTK8sqEscSTokC34MkVdOVFW/4xvUC1jKfSZ3qbWO39nxX/L
         9UDtU7gTX22XBl+flSaP68RicZcpIpy0IcAuEwc5zkzecHYoKBQ1YhjjGEIxEJwnJg
         EsyzzfSRZc9+Kjqxg/ht7xbsaCvFFQHrV8nVS9lU=
Date:   Thu, 25 Feb 2021 16:51:39 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, brho@google.com,
        f.fainelli@gmail.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 initramfs-panic-with-memory-information-fix.patch removed from -mm tree
Message-ID: <20210226005139.ShmBWF3Ol%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs-panic-with-memory-information-fix
has been removed from the -mm tree.  Its filename was
     initramfs-panic-with-memory-information-fix.patch

This patch was dropped because it was folded into initramfs-panic-with-memory-information.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initramfs-panic-with-memory-information-fix

replace macro with C function

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Barret Rhoden <brho@google.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/init/initramfs.c~initramfs-panic-with-memory-information-fix
+++ a/init/initramfs.c
@@ -46,9 +46,14 @@ static void __init error(char *x)
 		message = x;
 }
 
-#define panic_show_mem(...) {	\
-	show_mem(0, NULL);	\
-	panic(__VA_ARGS__);	\
+static void panic_show_mem(const char *fmt, ...)
+{
+	va_list args;
+
+	show_mem(0, NULL);
+	va_start(args, fmt);
+	panic(fmt, args);
+	va_end(args);
 }
 
 /* link hash */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

initramfs-panic-with-memory-information.patch
mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

