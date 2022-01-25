Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16F1C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S246336AbiAYDql (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242430AbiAYCh2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 21:37:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9855DC061780
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 16:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EEE9B815F2
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 00:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7732C340E4;
        Tue, 25 Jan 2022 00:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643069630;
        bh=Swfru9XLPEiKCIaM+ANSBTN88ap4rWh0FCMvVZL+7Vw=;
        h=Date:From:To:Subject:From;
        b=JuD61fVLsKhjN/BfC7JTzdiUPG4N6iW34QqBgJ2SyKw7tHi+jklWitIFbVxYGrww4
         SR8dDdoMvHUGoTperZZdwdGqgQJ3wwrF51NlIB6ELYBYgbpi4fWcJ1vGkKj2pNlUZ1
         pc1qnsKAwgFMKQKfLJESEph7tqeodHom2oWHr7sY=
Date:   Mon, 24 Jan 2022 16:13:49 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        haolee.swjtu@gmail.com, jamorris@linux.microsoft.com,
        keescook@chromium.org, mm-commits@vger.kernel.org
Subject:  +
 proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch added to -mm tree
Message-ID: <20220125001349.51QAyBNDb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: alloc PATH_MAX bytes for /proc/${pid}/fd/ symlinks
has been added to the -mm tree.  Its filename is
     proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hao Lee <haolee.swjtu@gmail.com>
Subject: proc: alloc PATH_MAX bytes for /proc/${pid}/fd/ symlinks

It's not a standard approach that use __get_free_page() to alloc path
buffer directly.  We'd better use kmalloc and PATH_MAX.

	PAGE_SIZE is different on different archs. An unlinked file
	with very long canonical pathname will readlink differently
	because "(deleted)" eats into a buffer.	--adobriyan

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
+	char *tmp = (char *)kmalloc(PATH_MAX, GFP_KERNEL);
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

proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks.patch

