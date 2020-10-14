Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0400C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40F6A22255
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708976;
	bh=rf3qdOwoQaZfeWw9Jl0sVWbOzBotPy5F4N1+Cz0s3yk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mSjuAe99MPAs89znNaK0NLjINl3FcNPDSf/zWblIvogXH1aKoS4jb9+21iyD11U8L
	 VwnzkucbW23uAuBC3f0sjg8MfoRO5xANfGLnHNR4EfdgUNNweSnyirNLqfyQhHIOeN
	 0sKD0eNMUesylCufdLOWlagijQG56eFi0MedtrjM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgJNU4P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgJNU4O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6DC2224E;
        Wed, 14 Oct 2020 20:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708973;
        bh=rf3qdOwoQaZfeWw9Jl0sVWbOzBotPy5F4N1+Cz0s3yk=;
        h=Date:From:To:Subject:From;
        b=f7qm6ojA53dPoqec/ojrCUVNOn6ymKUKqwTyJvFl5obuLWfBeprVZAb9SubsFbHGW
         sCzAaq5Sa6EpZ8yWcyI7eac3lDkDNFgViuKDpVBe9Wh2TdzFcFHItig/wlM/9ohLcn
         dCeWW47pFrMnN0Wr8nfcz8zCuwcYqnFswcHWOiFM=
Date:   Wed, 14 Oct 2020 13:56:13 -0700
From:   akpm@linux-foundation.org
To:     luojiaxing@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] fs_parse-mark-fs_param_bad_value-as-static.patch
 removed from -mm tree
Message-ID: <20201014205613.KONMg_vCM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs_parse: mark fs_param_bad_value() as static
has been removed from the -mm tree.  Its filename was
     fs_parse-mark-fs_param_bad_value-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luo Jiaxing <luojiaxing@huawei.com>
Subject: fs_parse: mark fs_param_bad_value() as static

We found the following warning when build kernel with W=1:

fs/fs_parser.c:192:5: warning: no previous prototype for `fs_param_bad_value' [-Wmissing-prototypes]
int fs_param_bad_value(struct p_log *log, struct fs_parameter *param)
     ^
CC      drivers/usb/gadget/udc/snps_udc_core.o

And no header file define a prototype for this function, so we should mark
it as static.

Link: https://lkml.kernel.org/r/1601293463-25763-1-git-send-email-luojiaxing@huawei.com
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs_parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fs_parser.c~fs_parse-mark-fs_param_bad_value-as-static
+++ a/fs/fs_parser.c
@@ -189,7 +189,7 @@ out:
 }
 EXPORT_SYMBOL(fs_lookup_param);
 
-int fs_param_bad_value(struct p_log *log, struct fs_parameter *param)
+static int fs_param_bad_value(struct p_log *log, struct fs_parameter *param)
 {
 	return inval_plog(log, "Bad value for '%s'", param->key);
 }
_

Patches currently in -mm which might be from luojiaxing@huawei.com are


