Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C18C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF44661242
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhIOD6d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236279AbhIOD63 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A7F60F8F;
        Wed, 15 Sep 2021 03:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631678231;
        bh=9vpAtrPKKKPJjxpnWcN/SwrVkiKm5z32JaDY2ktO4tg=;
        h=Date:From:To:Subject:From;
        b=XRdMQWD3OQYGrE2h1Qmwh5AWW2XUkFFgMOAzJ2EDKpqHolVBoHQAe2UaFfvR8vnv/
         uHtRVzcN+h5MZeW643bWEKJSin1CeACKXjT8yFolooMZqfhSLfwWOh5+5QsY3T29A+
         Uk6zKmrPCmy0e4Gl/3tg6GDHGHp3HDqJbguLEwHE=
Date:   Tue, 14 Sep 2021 20:57:10 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  + coda-remove-err-which-no-one-care.patch added to -mm
 tree
Message-ID: <20210915035710.PadJXZxzA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: remove err which no one care
has been added to the -mm tree.  Its filename is
     coda-remove-err-which-no-one-care.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coda-remove-err-which-no-one-care.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coda-remove-err-which-no-one-care.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: coda: remove err which no one care

No one care 'err' in func coda_release, so better remove it.

Link: https://lkml.kernel.org/r/20210908140308.18491-4-jaharkes@cs.cmu.edu
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/coda/file.c~coda-remove-err-which-no-one-care
+++ a/fs/coda/file.c
@@ -238,11 +238,10 @@ int coda_release(struct inode *coda_inod
 	struct coda_file_info *cfi;
 	struct coda_inode_info *cii;
 	struct inode *host_inode;
-	int err;
 
 	cfi = coda_ftoc(coda_file);
 
-	err = venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
+	venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
 			  coda_flags, coda_file->f_cred->fsuid);
 
 	host_inode = file_inode(cfi->cfi_container);
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

coda-remove-err-which-no-one-care.patch

