Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E31C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD8BC21775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881636;
	bh=jUV+QVSG23NpjwE0H8mXjzL1kl7fbvisDrLNCo8kPCk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YeRcDY9e+nWJmW4BedFXgiK9H6pOyquvAkXbSFbKUJxHquyIxlHPytP0VeCeClSKJ
	 kGpHrfU4uuPe8yz9tcaXg63e+YHhAaNzcInD+ta6xvLoFlwJ05N2L7201I/XClm1Tf
	 pnuxV8kTMlzf2iOjpVXVohBpT8f8IM5+f7v1hU1E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409220AbgJPUx4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409219AbgJPUxy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B6321D40;
        Fri, 16 Oct 2020 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881634;
        bh=jUV+QVSG23NpjwE0H8mXjzL1kl7fbvisDrLNCo8kPCk=;
        h=Date:From:To:Subject:From;
        b=O3MH5aKp42MUNoP+jwK5mEP+nU5KD2FwmIRIq1hSgZlWjf8+QnFuZ2JpLgx94TFFS
         mOsHv6LrmBJoqDzICG9kqJ8UdKzjrOrRNWndaCAuAs23w7HF7c0Rwep/338l2blFsx
         nU5m/7dB4IdevXMuriEGqr49rXcVGwS56gaPHiCU=
Date:   Fri, 16 Oct 2020 13:53:53 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, kishon@ti.com, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, vkoul@kernel.org
Subject:  [merged] const_structscheckpatch-add-phy_ops.patch
 removed from -mm tree
Message-ID: <20201016205353.uLNRjnSCD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add phy_ops
has been removed from the -mm tree.  Its filename was
     const_structscheckpatch-add-phy_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: const_structs.checkpatch: add phy_ops

All usages of phy_ops in include/linux uses const phy_ops * and all
instances of phy_ops in the kernel that are not const already can be made
const (patches have been posted for those separately).

Link: https://lkml.kernel.org/r/20200824214132.9072-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-phy_ops
+++ a/scripts/const_structs.checkpatch
@@ -39,6 +39,7 @@ nlmsvc_binding
 nvkm_device_chip
 of_device_id
 pci_raw_ops
+phy_ops
 pipe_buf_operations
 platform_hibernation_ops
 platform_suspend_ops
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are


