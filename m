Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD76C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Dec 2022 17:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiLWRv4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Dec 2022 12:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLWRvy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Dec 2022 12:51:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680CD11464
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 09:51:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 288C8B820F4
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 17:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B410BC433D2;
        Fri, 23 Dec 2022 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671817909;
        bh=mhR/Pl4tOqlg6c1BSQnECUs3SgyuLjEicbnzwroD36M=;
        h=Date:To:From:Subject:From;
        b=a+OFFooqpQoPQiJAnFFyuqJDvFfJs26aVu7GAYuLTvT3VneJ2apP/0HRkVzxvm3ce
         CFGBMpC83JWn3qIO84JNUKw2ZjOyyvapKACtcz0Yat8lgJ6D8BfGZ+7cLEMvGzmS+0
         MLVoKjGlEusW3N/zosVjX0Gbg1sJhMXyRNSR3+Tw=
Date:   Fri, 23 Dec 2022 09:51:48 -0800
To:     mm-commits@vger.kernel.org, xupengfei@nfschina.com,
        keescook@chromium.org, brauner@kernel.org,
        akpm@linux-foudation.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfsplus-remove-unnecessary-variable-initialization-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221223175149.B410BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus-remove-unnecessary-variable-initialization-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfsplus-remove-unnecessary-variable-initialization-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfsplus-remove-unnecessary-variable-initialization-fix.patch

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

 fs/hfsplus/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch

