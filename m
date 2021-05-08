Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF53C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70E7F6143B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWyl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhEHWyk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 887A161402;
        Sat,  8 May 2021 22:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514417;
        bh=OAkYqNjOXfg/P2vfoxyntCIXQ/vj9a6gGWol1wpjd/Y=;
        h=Date:From:To:Subject:From;
        b=dnZTtov83YCFqrcseIg46TcD7fI+OlPG2xjdFIiDur5D4DZ/xRCnU2WdTZ8hpE8DT
         B5rKbM59blUAopzFV5v6COyvF231S9zlJbOVvGEABtM/nC+mlbQD2L2WE8CxSfj6ZP
         nHkuPRSK6wIRvZFM/amuQf+SNmm9T85dsRvUwIes=
Date:   Sat, 08 May 2021 15:53:37 -0700
From:   akpm@linux-foundation.org
To:     baijiaju1990@gmail.com, bhe@redhat.com, mm-commits@vger.kernel.org,
        oslab@tsinghua.edu.cn
Subject:  [merged]
 =?US-ASCII?Q?kernel-kexec=5Ffile-fix-error-return-code-of-kexec=5Fcalcu?=
 =?US-ASCII?Q?late=5Fstore=5Fdigests.patch?= removed from -mm tree
Message-ID: <20210508225337.aV_21Hoch%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: kexec_file: fix error return code of kexec_calculate_store_digests()
has been removed from the -mm tree.  Its filename was
     kernel-kexec_file-fix-error-return-code-of-kexec_calculate_store_digests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

When vzalloc() returns NULL to sha_regions, no error return code of
kexec_calculate_store_digests() is assigned.  To fix this bug, ret is
assigned with -ENOMEM in this case.

Link: https://lkml.kernel.org/r/20210309083904.24321-1-baijiaju1990@gmail.com
Fixes: a43cac0d9dc2 ("kexec: split kexec_file syscall code to kexec_file.c")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/kexec_file.c~kernel-kexec_file-fix-error-return-code-of-kexec_calculate_store_digests
+++ a/kernel/kexec_file.c
@@ -740,8 +740,10 @@ static int kexec_calculate_store_digests
 
 	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
 	sha_regions = vzalloc(sha_region_sz);
-	if (!sha_regions)
+	if (!sha_regions) {
+		ret = -ENOMEM;
 		goto out_free_desc;
+	}
 
 	desc->tfm   = tfm;
 
_

Patches currently in -mm which might be from baijiaju1990@gmail.com are


