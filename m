Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E481EC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjBCGvn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjBCGv2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE395DBD4
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F6CEB8298A
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16310C433D2;
        Fri,  3 Feb 2023 06:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407070;
        bh=ypYuPbN8fyOs/fYCp9vZ5Wyg8/0AH59RLVgdCXYQZJo=;
        h=Date:To:From:Subject:From;
        b=jVpH8Mw/Bydi3rFFQVJI5fwxSoUuQp0aztgVG/vtNE7yiocYtoUsM+aw7FGcF27+K
         3hKrytduhcXIgvG4our2+BTU9cQSwepEAZcIeBuBcX5vJRYFT0gQhjm2iTlXUensIO
         WowvvgW5uOyuAa5o/Ks8Nc9JVn7I6Z+M62nqOEvo=
Date:   Thu, 02 Feb 2023 22:51:09 -0800
To:     mm-commits@vger.kernel.org, xupengfei@nfschina.com,
        wuchi.zero@gmail.com, mwilck@suse.com, ebiederm@xmission.com,
        ddiss@suse.de, brauner@kernel.org, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] initramfs-use-kstrtobool-instead-of-strtobool.patch removed from -mm tree
Message-Id: <20230203065110.16310C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: initramfs: use kstrtobool() instead of strtobool()
has been removed from the -mm tree.  Its filename was
     initramfs-use-kstrtobool-instead-of-strtobool.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


