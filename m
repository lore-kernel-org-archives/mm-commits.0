Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E89C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344224AbiCWXGy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiCWXGy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:06:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8001C24F06
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 315A6B8214D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0B9C340E8;
        Wed, 23 Mar 2022 23:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076721;
        bh=+jo1fmUPf4yEgBUfvNYe1AyqvsEG4CNfjSzhwCPYegY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=WovkoyXSXyb8EJmNIK6djNY4JqS/Jh6XXOCHWSu5lq0rfDGuThI6xdJV0KlckC8Lx
         fhfNZlun/RNYdU2mYQrVB05DviR/1YSk9SWpUZYrwoYDg1aDZWk2qWHYoqLC1IbTPi
         RjD5KgWdbQHWY4thhuC6wBka2tU9yyPlQkOEIpnM=
Date:   Wed, 23 Mar 2022 16:05:20 -0700
To:     keescook@chromium.org, jamorris@linux.microsoft.com,
        christian.brauner@ubuntu.com, adobriyan@gmail.com,
        haolee.swjtu@gmail.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 01/41] proc: alloc PATH_MAX bytes for /proc/${pid}/fd/ symlinks
Message-Id: <20220323230520.DD0B9C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hao Lee <haolee.swjtu@gmail.com>
Subject: proc: alloc PATH_MAX bytes for /proc/${pid}/fd/ symlinks

It's not a standard approach that use __get_free_page() to alloc path
buffer directly.  We'd better use kmalloc and PATH_MAX.

	PAGE_SIZE is different on different archs. An unlinked file
	with very long canonical pathname will readlink differently
	because "(deleted)" eats into a buffer.	--adobriyan

[akpm@linux-foundation.org: remove now-unneeded cast]
Link: https://lkml.kernel.org/r/Ye1fCxyZZ0I5lgOL@localhost.localdomain
Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c~proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks
+++ a/fs/proc/base.c
@@ -1764,25 +1764,25 @@ out:
 
 static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 {
-	char *tmp = (char *)__get_free_page(GFP_KERNEL);
+	char *tmp = kmalloc(PATH_MAX, GFP_KERNEL);
 	char *pathname;
 	int len;
 
 	if (!tmp)
 		return -ENOMEM;
 
-	pathname = d_path(path, tmp, PAGE_SIZE);
+	pathname = d_path(path, tmp, PATH_MAX);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;
-	len = tmp + PAGE_SIZE - 1 - pathname;
+	len = tmp + PATH_MAX - 1 - pathname;
 
 	if (len > buflen)
 		len = buflen;
 	if (copy_to_user(buffer, pathname, len))
 		len = -EFAULT;
  out:
-	free_page((unsigned long)tmp);
+	kfree(tmp);
 	return len;
 }
 
_
