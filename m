Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C63EC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DCFD21941
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594690702;
	bh=FCaiaG1ENU7B/pldGf9E9jMiYMhYXZhPUFCfBFf0nnU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IuGXptoT1PWWuBhe4la3cqBenwB2/B8raANFGTdPj1L9RWdtiUBe8DzCmtdCM2gcD
	 wqAnKL97ZXDz/0565Qywq3mD8DpdgnhyaGKM2bQVDAfh/w+8Z4r4O1ySdBrLqY5S4X
	 14YrnLyz4cl3dUw7aCoAi2Mn2ZMcH1cF8oCU+l6M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgGNBiV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGNBiV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:38:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96EAD2192A;
        Tue, 14 Jul 2020 01:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594690701;
        bh=FCaiaG1ENU7B/pldGf9E9jMiYMhYXZhPUFCfBFf0nnU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kz3AJGebT1seLraAvB5wr3DvHKTnN1P6H7s9Gabekp8QnWzYfbujiEqCVbkcl6zNY
         vDl+KGxW/eTJ7xcBbOF2SV6FC1PYjEVBDTGAKoUj94thjsVa2fPjTqCotpr/706Bn4
         xRB0j999GGii/7yjTv//B1AI4gywfpXLN++zQovw=
Date:   Mon, 13 Jul 2020 18:38:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bleung@chromium.org, broonie@kernel.org,
        enric.balletbo@collabora.com, groeck@chromium.org, joe@perches.com,
        lgirdwood@gmail.com, mm-commits@vger.kernel.org,
        pihsun@chromium.org, rikard.falkeborn@gmail.com
Subject:  + const_structscheckpatch-add-regulator_ops.patch added
 to -mm tree
Message-ID: <20200714013820.NqJpHfLZi%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add regulator_ops
has been added to the -mm tree.  Its filename is
     const_structscheckpatch-add-regulator_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/const_structscheckpatch-add-regulator_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/const_structscheckpatch-add-regulator_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: const_structs.checkpatch: add regulator_ops

Add regulator_ops to expected to be const list.

Link: http://lkml.kernel.org/r/dab1ba1aa03a8236933cfb7a28937efb0b808f13.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pi-Hsun Shih <pihsun@chromium.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-regulator_ops
+++ a/scripts/const_structs.checkpatch
@@ -44,6 +44,7 @@ platform_hibernation_ops
 platform_suspend_ops
 proto_ops
 regmap_access_table
+regulator_ops
 rpc_pipe_ops
 rtc_class_ops
 sd_desc
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
const_structscheckpatch-add-regulator_ops.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
checkpatch-add-fix-option-for-assign_in_if.patch

