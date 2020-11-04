Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E43C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22E9D206C0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604454379;
	bh=f9Ssot6z1OsDExDgyugf3WLci9WOrJa59mTbPhdcdNA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zTEMznDWTPHmq2yN0e5dyPkxJpIdrFXobbLcdRAcZ1r3fUIELNHCNk45IksR5WTnV
	 o/T/bLn94PVfWcY6eeKj8T5ACOtBSi26qcHZiky0drTyA7AsngCoP94YH2FgZEjqAJ
	 Taq8DYgK5neQO3KjYA7A6FbK2QmwZofYB0plbzFs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgKDBqS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 20:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbgKDBqS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 20:46:18 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23706223C7;
        Wed,  4 Nov 2020 01:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604454376;
        bh=f9Ssot6z1OsDExDgyugf3WLci9WOrJa59mTbPhdcdNA=;
        h=Date:From:To:Subject:From;
        b=JtXrIj8ayenvryoKNjLjtEp9fFYRQMF5/I4lN30qrFZbvzEhF3yHb+I5ROXW9fmj3
         D+XSAQxW+iOzG6FMDjKcGyoRdtsp/QaDbTVDT6qsC0Gz+i2499wxq5P3kSWJzRH6wz
         VNWczaaRuaff9qU16aUAdwXR0GZhrUlScJD0m9Dg=
Date:   Tue, 03 Nov 2020 17:46:15 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        jhubbard@nvidia.com, song.bao.hua@hisilicon.com
Subject:  +
 mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch added to
 -mm tree
Message-ID: <20201104014615.Ezl0H%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_test.c: mark gup_test_init as __init function
has been added to the -mm tree.  Its filename is
     mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/gup_test.c: mark gup_test_init as __init function

gup_test_init() is only called during initialization, mark it as __init to
save some memory.

Link: https://lkml.kernel.org/r/20201103081016.16532-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup_test.c~mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function
+++ a/mm/gup_test.c
@@ -236,7 +236,7 @@ static const struct file_operations gup_
 	.unlocked_ioctl = gup_test_ioctl,
 };
 
-static int gup_test_init(void)
+static int __init gup_test_init(void)
 {
 	debugfs_create_file_unsafe("gup_test", 0600, NULL, NULL,
 				   &gup_test_fops);
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-gup_benchmark-mark-gup_benchmark_init-as-__init-function.patch

