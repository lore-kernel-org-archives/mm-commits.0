Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861C0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355118AbiDZUrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 16:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355027AbiDZUrT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 16:47:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A93C1A15FD
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F55A6155F
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82819C385A0;
        Tue, 26 Apr 2022 20:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651005849;
        bh=qQj6o5n/yj5FxQQ8qlMW7OQKkEF4gOOc8JUujRConhY=;
        h=Date:To:From:Subject:From;
        b=AGbVP8iTSwf9y07mO57O6ZN06TU8mRCKCxlnWBIFcu2a9lx/d3u6Rj2kJnzqPpne2
         A0RC92oE96uSMtDrZZBkcOFhYtZUiyeklZtmfwbhRgNGPQIDBfnIQy9on+GWVv7tst
         hVh3a+1Aw+Luvs4zGB9Rak+Boyd+uUyD5U0MDzUo=
Date:   Tue, 26 Apr 2022 13:44:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + initramfs-make-dir_entryname-a-flexible-array-member.patch added to -mm tree
Message-Id: <20220426204409.82819C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: make dir_entry.name a flexible array member
has been added to the -mm tree.  Its filename is
     initramfs-make-dir_entryname-a-flexible-array-member.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/initramfs-make-dir_entryname-a-flexible-array-member.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/initramfs-make-dir_entryname-a-flexible-array-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Disseldorp <ddiss@suse.de>
Subject: initramfs: make dir_entry.name a flexible array member

dir_entry.name is currently allocated via a separate kstrdup().  Change it
to a flexible array member and allocate it along with struct dir_entry.

Link: https://lkml.kernel.org/r/20220404093429.27570-3-ddiss@suse.de
Signed-off-by: David Disseldorp <ddiss@suse.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/init/initramfs.c~initramfs-make-dir_entryname-a-flexible-array-member
+++ a/init/initramfs.c
@@ -130,17 +130,20 @@ static long __init do_utime(char *filena
 static __initdata LIST_HEAD(dir_list);
 struct dir_entry {
 	struct list_head list;
-	char *name;
 	time64_t mtime;
+	char name[];
 };
 
 static void __init dir_add(const char *name, time64_t mtime)
 {
-	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
+	size_t nlen = strlen(name) + 1;
+	struct dir_entry *de;
+
+	de = kmalloc(sizeof(struct dir_entry) + nlen, GFP_KERNEL);
 	if (!de)
 		panic_show_mem("can't allocate dir_entry buffer");
 	INIT_LIST_HEAD(&de->list);
-	de->name = kstrdup(name, GFP_KERNEL);
+	strscpy(de->name, name, nlen);
 	de->mtime = mtime;
 	list_add(&de->list, &dir_list);
 }
@@ -151,7 +154,6 @@ static void __init dir_utime(void)
 	list_for_each_entry_safe(de, tmp, &dir_list, list) {
 		list_del(&de->list);
 		do_utime(de->name, de->mtime);
-		kfree(de->name);
 		kfree(de);
 	}
 }
_

Patches currently in -mm which might be from ddiss@suse.de are

initramfs-refactor-do_header-cpio-magic-checks.patch
initramfs-make-dir_entryname-a-flexible-array-member.patch
initramfs-add-initramfs_preserve_mtime-kconfig-option.patch
gen_init_cpio-fix-short-read-file-handling.patch
gen_init_cpio-support-file-checksum-archiving.patch
initramfs-support-cpio-extraction-with-file-checksums.patch

