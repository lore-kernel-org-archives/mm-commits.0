Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E024C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28A8161C9D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhGFTZz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhGFTZz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6725661CAA;
        Tue,  6 Jul 2021 19:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599395;
        bh=TbAJ4rfhKTXAZeO/DViJX3ATTrynFbdL0Oi55NrtQKE=;
        h=Date:From:To:Subject:From;
        b=Cac6vJTpYse0so6k3QjFYY7LaDKMcnwFgAb2Aq8zY8xz4fA8/3D73sR2o1OkAOOkV
         LUKKv+rROVuQuY0S3btK5D4VIFITaGZXfi3rnVe0V0ZelMkxO/pjyQGohU7mdUP090
         ACZZG72J80vwn6+atDgAfs0QHdhcA/7yDtxltkW4=
Date:   Tue, 06 Jul 2021 12:23:15 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] exec-remove-checks-in-__register_bimfmt.patch
 removed from -mm tree
Message-ID: <20210706192315.HsMEMiwyE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: remove checks in __register_bimfmt()
has been removed from the -mm tree.  Its filename was
     exec-remove-checks-in-__register_bimfmt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: exec: remove checks in __register_bimfmt()

Delete NULL check, all callers pass valid pointer.

Delete ->load_binary check -- failure to provide hook in a custom module
will be very noticeable at the very first execve call.

Link: https://lkml.kernel.org/r/YK1Gy1qXaLAR+tPl@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/exec.c~exec-remove-checks-in-__register_bimfmt
+++ a/fs/exec.c
@@ -84,9 +84,6 @@ static DEFINE_RWLOCK(binfmt_lock);
 
 void __register_binfmt(struct linux_binfmt * fmt, int insert)
 {
-	BUG_ON(!fmt);
-	if (WARN_ON(!fmt->load_binary))
-		return;
 	write_lock(&binfmt_lock);
 	insert ? list_add(&fmt->lh, &formats) :
 		 list_add_tail(&fmt->lh, &formats);
_

Patches currently in -mm which might be from adobriyan@gmail.com are


