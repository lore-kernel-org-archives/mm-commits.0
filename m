Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C906C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbiEJEZR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbiEJEX1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA241D0404
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2B5D61766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1439CC385C7;
        Tue, 10 May 2022 04:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156282;
        bh=qWzHn+iWoGPev26xKleyOF0wH0tOLOXBQQGaPrRbAi0=;
        h=Date:To:From:Subject:From;
        b=y8V/dEwxMCUTT91RpecUha3FFQVQ/8iF1fLIGx9+2ofUG0z2y9CSarIs5hVRBUuAK
         YyA02j95d6xbAj7duU8N+RrZ+7olC+3zDtrP6Gh8lP2hypT7GQDpT23uZx9CjIoV3z
         Ydg6+z9tCJB+b7iU4jOpeR3fhK/dIh1f62d/tE/U=
Date:   Mon, 09 May 2022 21:18:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com,
        christian.brauner@ubuntu.com, ddiss@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] initramfs-make-dir_entryname-a-flexible-array-member.patch removed from -mm tree
Message-Id: <20220510041802.1439CC385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: initramfs: make dir_entry.name a flexible array member
has been removed from the -mm tree.  Its filename was
     initramfs-make-dir_entryname-a-flexible-array-member.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


