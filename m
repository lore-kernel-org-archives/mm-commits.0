Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B95C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357081AbiCYBgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357483AbiCYBfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469862FFDD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E73F2B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C91C340EC;
        Fri, 25 Mar 2022 01:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172019;
        bh=5YQaZejHFJyVYCLDGMyMWi6kdrchgdSw+QVCHQXm9SI=;
        h=Date:To:From:Subject:From;
        b=qS9lm7PI8Blsaqp8GiuuToSrOxQb743tDDlohRtZUK0vU3py+ht+BL92TVqi+TFV5
         JUhdk7V2HDRqxTI2HmGJmrwt4bwJuYf0EEqa+eJrgx+dk2SCGlmHuP3JwDyRdu78qZ
         0M70H7t+82YumufvyIN9M8qRp6K7fxzXiiVS6Tw8=
Date:   Thu, 24 Mar 2022 18:33:38 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        jamorris@linux.microsoft.com, christian.brauner@ubuntu.com,
        adobriyan@gmail.com, haolee.swjtu@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch removed from -mm tree
Message-Id: <20220325013339.86C91C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: alloc PATH_MAX bytes for /proc/${pid}/fd/ symlinks
has been removed from the -mm tree.  Its filename was
     proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from haolee.swjtu@gmail.com are


