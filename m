Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C5BC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 159662087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817929;
	bh=cMZF75mJZwUS8mqKnlCn8rWKr5HY2/QApzzfymc4500=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dW4V0jmHVXf/0vDypSC41aouAmZ4san18vsFFs/6giSFAKuK2d617Pw9txNCUMmNb
	 weKGVcjWcAFwG7n/jSqwYtGZZR7rhrW/4C6goSCumbMc3hXXRM4ju8YWSt9c1b/Sj9
	 /F6ToEvVS1lWhCYBa5vK+K6egttisqhvI7vOutmQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389612AbgJPDMI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDMH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CD3D20878;
        Fri, 16 Oct 2020 03:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817926;
        bh=cMZF75mJZwUS8mqKnlCn8rWKr5HY2/QApzzfymc4500=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AaBwdu+kQxV1N5bxdHB7s+3spz/UhkTs2ttrA9tfv1AZ4Nd4H/54yxJ8QiJGTNy5n
         gd9MLGWtdw5wHBnk10r3l4svMPKuef1WcMLjKZAXLKzSNjonFZvbdGW0sfHataZvdl
         MIh6iadk0IDb+lV2QR8854fuBGM6j7dyb17lJROs=
Date:   Thu, 15 Oct 2020 20:12:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     afaerber@suse.de, akpm@linux-foundation.org, joe@perches.com,
        linus.walleij@linaro.org, manivannan.sadhasivam@linaro.org,
        mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 126/156] const_structs.checkpatch: add pinctrl_ops
 and pinmux_ops
Message-ID: <20201016031205.SHHYnYbK7%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
