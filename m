Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D652CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B9A120897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814893;
	bh=gW26i/KK+5Iktl75CoSY7gumuPmTJ/Z2jYURp6dgpDo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ci+RXtfQsUCJSPowC6EzI6DPHUevqO5M9quYYGqdpfvPwdLurUYAb40FCVfwiZl1T
	 zBTgdA2eQTT86bs8Cv7xB+NBQ6IyEzLWo0SIWCIoBt63Gi3Yma7uUZAr9EWfem/qVF
	 2Wd6X9JmqaNN25pjUwSO70vQrVNY90Uh/e79vntE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393702AbgJPCVd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393700AbgJPCVc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:21:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55CDB20878;
        Fri, 16 Oct 2020 02:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814892;
        bh=gW26i/KK+5Iktl75CoSY7gumuPmTJ/Z2jYURp6dgpDo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cX9fivmCbGa7muXSQj9P1O4Y6crJ+9IMAdUViSxQOIK2+luY+DH0NZ9gU4Pau65J2
         CJZ62iAtupar3D1AzCocUnxfoITisvOqsQV/0KfuKmFSId51K+5mmX3BA9M3EpphJN
         IwJfuWwMd8KYdAyPi40jBeRaWy7eeOxdMH5DMboE=
Date:   Thu, 15 Oct 2020 19:21:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ckennelly@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?fs-binfmt=5Felf-use-pt=5Fload-p=5Falign-values-for-suitabl?=
 =?US-ASCII?Q?e-start-address-v4.patch?= removed from -mm tree
Message-ID: <20201016022131.yaafStvpH%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4.patch

This patch was dropped because it was folded into fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch

------------------------------------------------------
From: Chris Kennelly <ckennelly@google.com>
Subject: fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4

augment comment

Link: https://lkml.kernel.org/r/20200821233848.3904680-2-ckennelly@google.com
Signed-off-by: Chris Kennelly <ckennelly@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-v4
+++ a/fs/binfmt_elf.c
@@ -431,7 +431,7 @@ static unsigned long maximum_alignment(s
 		if (cmds[i].p_type == PT_LOAD) {
 			unsigned long p_align = cmds[i].p_align;
 
-			/* skip non-power of two alignments */
+			/* skip non-power of two alignments as invalid */
 			if (!is_power_of_2(p_align))
 				continue;
 			alignment = max(alignment, p_align);
_

Patches currently in -mm which might be from ckennelly@google.com are

fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch
add-self-test-for-verifying-load-alignment.patch

