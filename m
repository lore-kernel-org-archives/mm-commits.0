Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAE0EB64DD
	for <mm-commits@archiver.kernel.org>; Thu,  3 Aug 2023 17:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbjHCRzV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Aug 2023 13:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjHCRzU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2023 13:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA6E1704
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 10:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88CA961E62
        for <mm-commits@vger.kernel.org>; Thu,  3 Aug 2023 17:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD62C433C9;
        Thu,  3 Aug 2023 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691085319;
        bh=IIIVGFWn4UIJRY/4ZjGOpO61j04m3dJQ+VgHbSDy3uY=;
        h=Date:To:From:Subject:From;
        b=UmJBPMBcuMqBaiRFaV9NGbsQray5La8PqtwVn8i9PULuGabSvAGrdS5344fZfvFLS
         mN/ejmIfxyPkA3nVxgm1/Jb2IVnsT5ANmSNjP7/yHq1J24SqLy7sRrJQIJ28i4MxUk
         WmDY1SpINTzKBR7kI2fNgDXInmYRuOSRBPsydCYw=
Date:   Thu, 03 Aug 2023 10:55:18 -0700
To:     mm-commits@vger.kernel.org, Al.Smith@aeschi.ch.eu.org,
        wangzhu9@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + efs-clean-up-wunused-const-variable=-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20230803175518.DBD62C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: efs: clean up -Wunused-const-variable= warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     efs-clean-up-wunused-const-variable=-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/efs-clean-up-wunused-const-variable=-warning.patch

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

efs-clean-up-wunused-const-variable=-warning.patch

