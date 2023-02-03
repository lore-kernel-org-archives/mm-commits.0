Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCBFC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbjBCGqD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbjBCGpc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:45:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1C56EBA
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:43:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EF27B8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3CFC433D2;
        Fri,  3 Feb 2023 06:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406579;
        bh=OpAmGo7rLUHNBVRizKqvuqYoWuSykVg4LUXHyeXif7Y=;
        h=Date:To:From:Subject:From;
        b=Ok9UgfQDEq/spzzNByeJoxT1fwxaWYZj4Qn5M+K/vcc6L8ZZb4k8Zg2dS4HmqTkMX
         MDAWZrpi0vgzZDvLWe3tlH/3G2sdSi5tHDlGjBkcdGkch1Htj1qOdfaAzx0OqtAYnF
         HKxCOw+TmO/jsIAVTpJuUXtFevwfTRGLj9zCcy6g=
Date:   Thu, 02 Feb 2023 22:42:58 -0800
To:     mm-commits@vger.kernel.org, xupengfei@nfschina.com,
        keescook@chromium.org, brauner@kernel.org,
        akpm@linux-foudation.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hfsplus-remove-unnecessary-variable-initialization-fix.patch removed from -mm tree
Message-Id: <20230203064259.0B3CFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfsplus-remove-unnecessary-variable-initialization-fix
has been removed from the -mm tree.  Its filename was
     hfsplus-remove-unnecessary-variable-initialization-fix.patch

This patch was dropped because it was folded into hfsplus-remove-unnecessary-variable-initialization.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hfsplus-remove-unnecessary-variable-initialization-fix
Date: Wed Dec 21 01:32:43 PM PST 2022

give hfsplus_listxattr:key_len narrower scope

Cc: XU pengfei <xupengfei@nfschina.com>
Cc: Andrew Morton <akpm@linux-foudation.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hfsplus/xattr.c~hfsplus-remove-unnecessary-variable-initialization-fix
+++ a/fs/hfsplus/xattr.c
@@ -677,7 +677,6 @@ ssize_t hfsplus_listxattr(struct dentry
 	ssize_t res;
 	struct inode *inode = d_inode(dentry);
 	struct hfs_find_data fd;
-	u16 key_len;
 	struct hfsplus_attr_key attr_key;
 	char *strbuf;
 	int xattr_name_len;
@@ -719,7 +718,8 @@ ssize_t hfsplus_listxattr(struct dentry
 	}
 
 	for (;;) {
-		key_len = hfs_bnode_read_u16(fd.bnode, fd.keyoffset);
+		u16 key_len = hfs_bnode_read_u16(fd.bnode, fd.keyoffset);
+
 		if (key_len == 0 || key_len > fd.tree->max_key_len) {
 			pr_err("invalid xattr key length: %d\n", key_len);
 			res = -EIO;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
hfsplus-remove-unnecessary-variable-initialization.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

