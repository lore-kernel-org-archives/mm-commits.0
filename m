Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFD0C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A08B218AC
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881641;
	bh=L2Dy9ZvbGEEX/ksDEvsRvfiexNCg91rQOmCBUc9Vsbg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yZIPxLnbrdtn9C4Q/esoQLZiTTpk9z0XpTdj3EbGuPElAUxb1xC35ouIVAIBCL2IH
	 h1t8gChTwZd3MhwB3GsQ5PRYpDBtVaWjlGSxBs2VIAE/aQzh9vAi2PfKXwpyPv9ITs
	 2m1W9vKCP3dLTMRMdsvHGgT+EVd4KcjOm/gbKPRE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409222AbgJPUyA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409219AbgJPUyA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3FC9216C4;
        Fri, 16 Oct 2020 20:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881640;
        bh=L2Dy9ZvbGEEX/ksDEvsRvfiexNCg91rQOmCBUc9Vsbg=;
        h=Date:From:To:Subject:From;
        b=P4SVwRTylNkqbNzSD8GIaA3Pw20ka4VWPgPbZoyb4sGRGuOUXSYk04GUsuk1lF8sp
         QJGC45ymOej0De7NlUJoZAp7wX8gSj3U8s6hzu1UkSQaw8BWwaQjOBJbppakNiBSho
         NKQXOLNeWn8ZDEte3DzSyYrp42QvEiGwoRctXfho=
Date:   Fri, 16 Oct 2020 13:53:59 -0700
From:   akpm@linux-foundation.org
To:     afaerber@suse.de, joe@perches.com, linus.walleij@linaro.org,
        manivannan.sadhasivam@linaro.org, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com
Subject:  [merged]
 const_structscheckpatch-add-pinctrl_ops-and-pinmux_ops.patch removed from
 -mm tree
Message-ID: <20201016205359.gtf3ivkog%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add pinctrl_ops and pinmux_ops
has been removed from the -mm tree.  Its filename was
     const_structscheckpatch-add-pinctrl_ops-and-pinmux_ops.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: const_structs.checkpatch: add pinctrl_ops and pinmux_ops

All usages of include/linux of these are const pointers, and all instances
in the kernel except one, that are not const can be made const (patches
have been posted for those separately).

Link: https://lkml.kernel.org/r/20200830224352.37114-1-rikard.falkeborn@gma=
il.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andreas F=C3=A4rber <afaerber@suse.de>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/const_structs.checkpatch |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/const_structs.checkpatch~const_structscheckpatch-add-pinctrl_=
ops-and-pinmux_ops
+++ a/scripts/const_structs.checkpatch
@@ -40,6 +40,8 @@ nvkm_device_chip
 of_device_id
 pci_raw_ops
 phy_ops
+pinctrl_ops
+pinmux_ops
 pipe_buf_operations
 platform_hibernation_ops
 platform_suspend_ops
_

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are


