Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AC0C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01CB8233FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgLPRJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbgLPRJg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:36 -0500
Date:   Wed, 16 Dec 2020 09:08:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138516;
        bh=GKXAinpLT87xPnubo3lYCwOCgp+sGHznbzxk0wSFSpU=;
        h=From:To:Subject:From;
        b=vak4zhfs9xoWpiYYzcz+VFcy1FPgA4gqWSXNk2kNCU5NMLZWCPR0lA7UzeF4qCXaG
         VsrNQnSLH4Nto6CX2Yv3mhGS/MI7fAsyKa4cGUqcegaNu7yAAIC8jiDMgDWkNriVdi
         Tb6mLmm6gDYjm62x5KCp1LsKSj8LNBWhrx8+Pdlk=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sh_def@163.com
Subject:  [merged] acctc-use-elif-instead-of-end-and-elif.patch
 removed from -mm tree
Message-ID: <20201216170836.KJtjAJ4PY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/acct.c: use #elif instead of #end and #elif
has been removed from the -mm tree.  Its filename was
     acctc-use-elif-instead-of-end-and-elif.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: kernel/acct.c: use #elif instead of #end and #elif

Cleanup: use #elif instead of #end and #elif.

Link: https://lkml.kernel.org/r/20201015150736.GA91603@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/acct.c~acctc-use-elif-instead-of-end-and-elif
+++ a/kernel/acct.c
@@ -381,9 +381,7 @@ static comp2_t encode_comp2_t(u64 value)
 		return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
 	}
 }
-#endif
-
-#if ACCT_VERSION == 3
+#elif ACCT_VERSION == 3
 /*
  * encode an u64 into a 32 bit IEEE float
  */
@@ -500,8 +498,7 @@ static void do_acct_process(struct bsd_a
 	/* backward-compatible 16 bit fields */
 	ac.ac_uid16 = ac.ac_uid;
 	ac.ac_gid16 = ac.ac_gid;
-#endif
-#if ACCT_VERSION == 3
+#elif ACCT_VERSION == 3
 	{
 		struct pid_namespace *ns = acct->ns;
 
_

Patches currently in -mm which might be from sh_def@163.com are

mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

