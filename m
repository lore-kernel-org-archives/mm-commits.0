Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709E6C04A94
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjHLWGT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjHLWGA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:06:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BCF1732
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDFB1620D5
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424AEC433C8;
        Sat, 12 Aug 2023 22:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877962;
        bh=NyCg9xa4KRFqUOpb18gBpj8/zwO1gOzWGfHLOcenfMU=;
        h=Date:To:From:Subject:From;
        b=vRIhiLCVKXpl9wC8LuQrXDMG92DoOZ6m4ptaT3BsQdI1nWmiEj6pcALkjc6iTfPCp
         70qigIE/oqwLoLaHQVSETkyR0LvDdh54NJtydzQ/dE4gRXD6odD8Lpl1/6mBukTfu8
         jk5KDJYyGQXKC/9WYF4Z8fX084zS6htKUHE5DCTc=
Date:   Sat, 12 Aug 2023 15:06:01 -0700
To:     mm-commits@vger.kernel.org, Al.Smith@aeschi.ch.eu.org,
        wangzhu9@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] efs-clean-up-wunused-const-variable=-warning.patch removed from -mm tree
Message-Id: <20230812220602.424AEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: efs: clean up -Wunused-const-variable= warning
has been removed from the -mm tree.  Its filename was
     efs-clean-up-wunused-const-variable=-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhu Wang <wangzhu9@huawei.com>
Subject: efs: clean up -Wunused-const-variable= warning
Date: Thu, 3 Aug 2023 09:51:03 +0800

When building with W=1, the following warning occurs.

In file included from fs/efs/super.c:18:0:
fs/efs/efs.h:22:19: warning: `cprt' defined but not used [-Wunused-const-variable=]
 static const char cprt[] = "EFS: "EFS_VERSION" - (c) 1999 Al Smith
<Al.Smith@aeschi.ch.eu.org>";
                   ^~~~
The 'cprt' is not used in any files, we move the copyright statement
into the comment.

Link: https://lkml.kernel.org/r/20230803015103.192985-1-wangzhu9@huawei.com
Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
Cc: Al Smith <Al.Smith@aeschi.ch.eu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/efs.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/efs/efs.h~efs-clean-up-wunused-const-variable=-warning
+++ a/fs/efs/efs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright (c) 1999 Al Smith
+ * Copyright (c) 1999 Al Smith, <Al.Smith@aeschi.ch.eu.org>
  *
  * Portions derived from work (c) 1995,1996 Christian Vogelgsang.
  * Portions derived from IRIX header files (c) 1988 Silicon Graphics
@@ -19,9 +19,6 @@
 
 #define EFS_VERSION "1.0a"
 
-static const char cprt[] = "EFS: "EFS_VERSION" - (c) 1999 Al Smith <Al.Smith@aeschi.ch.eu.org>";
-
-
 /* 1 block is 512 bytes */
 #define	EFS_BLOCKSIZE_BITS	9
 #define	EFS_BLOCKSIZE		(1 << EFS_BLOCKSIZE_BITS)
_

Patches currently in -mm which might be from wangzhu9@huawei.com are


