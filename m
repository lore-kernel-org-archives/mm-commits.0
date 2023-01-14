Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FFAC3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 21:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjANVtt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 16:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbjANVts (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 16:49:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29489EDF
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 13:49:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77991B80B02
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 21:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5783C433EF;
        Sat, 14 Jan 2023 21:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673732985;
        bh=begOQ6uv9EmYa+AatlW6s8p/XMPvvVoMK3LZppz2zy4=;
        h=Date:To:From:Subject:From;
        b=z12IJrn0XRDkUvnkQ4JBr6VRgUXO8X8kk4F1ZUo86+W8o/MnG4YeJsVnvYQIDBXph
         OH0uGgyL/qgLWW8B2F3LhIEzbIt4OugE38Uy6xlr0IGRasFrpaOLEG+qZOyT/WukNR
         XGXIeDkeI7Pqel33GfymCXNxO0BNHzAIJ3IwL90U=
Date:   Sat, 14 Jan 2023 13:49:44 -0800
To:     mm-commits@vger.kernel.org, xupengfei@nfschina.com,
        wuchi.zero@gmail.com, mwilck@suse.com, ebiederm@xmission.com,
        ddiss@suse.de, brauner@kernel.org, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + initramfs-use-kstrtobool-instead-of-strtobool.patch added to mm-nonmm-unstable branch
Message-Id: <20230114214944.E5783C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: use kstrtobool() instead of strtobool()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     initramfs-use-kstrtobool-instead-of-strtobool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/initramfs-use-kstrtobool-instead-of-strtobool.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: initramfs: use kstrtobool() instead of strtobool()
Date: Sat, 14 Jan 2023 18:21:38 +0100

strtobool() is the same as kstrtobool().  However, the latter is more used
within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Link: https://lkml.kernel.org/r/2597e80cb7059ec6ad63a01b77d7c944dcc99195.1673716768.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Disseldorp <ddiss@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: wuchi <wuchi.zero@gmail.com>
Cc: XU pengfei <xupengfei@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/init/initramfs.c~initramfs-use-kstrtobool-instead-of-strtobool
+++ a/init/initramfs.c
@@ -11,6 +11,7 @@
 #include <linux/syscalls.h>
 #include <linux/utime.h>
 #include <linux/file.h>
+#include <linux/kstrtox.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/namei.h>
@@ -571,8 +572,7 @@ __setup("keepinitrd", keepinitrd_setup);
 static bool __initdata initramfs_async = true;
 static int __init initramfs_async_setup(char *str)
 {
-	strtobool(str, &initramfs_async);
-	return 1;
+	return kstrtobool(str, &initramfs_async) == 0;
 }
 __setup("initramfs_async=", initramfs_async_setup);
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

initramfs-use-kstrtobool-instead-of-strtobool.patch

