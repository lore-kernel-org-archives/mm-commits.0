Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED09CC43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE566206E7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599195097;
	bh=qk+/bCfFwcFfqAu4dZZtpVR138ppp0iqDB4xb+weH8Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wS3DBxMglCaSy+9GxFH93QCO1PVShAjZzIyQRbQuFsZ9awgvoSkFZoQN4Rp7PwTC0
	 smhhWLpizhUlwnGIJVhmMkIv1e6dOZ67j6j1i+y0DV+iFAn3vADSDqabqJas+3CSHS
	 zkCwNwo3YWfPcPeA1OYzoDL2UYYnryFXKLZp0Cig=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgIDEvh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgIDEvg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 00:51:36 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 898D7206E7;
        Fri,  4 Sep 2020 04:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599195095;
        bh=qk+/bCfFwcFfqAu4dZZtpVR138ppp0iqDB4xb+weH8Q=;
        h=Date:From:To:Subject:From;
        b=GZQChtvJzUj0Cxzu/qraBXqRtLEt8E5o9awNarTGX0gzthFZUCxypUEA9GCd0BPRZ
         4v2ZnphNSrEBQko0kzfnGs9FH7RlUknFtSDmnAavOU2F4pPXpUOp8xoyuRUOf0LRWz
         eWe7UDfKDBeYvGgmsbFtqWfH2sB31LTxaodXP8es=
Date:   Thu, 03 Sep 2020 21:51:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        linus.walleij@linaro.org, joe@perches.com, afaerber@suse.de,
        rikard.falkeborn@gmail.com
Subject:  +
 const_structscheckpatch-add-pinctrl_ops-and-pinmux_ops.patch added to -mm
 tree
Message-ID: <20200904045135.IY0ip%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: const_structs.checkpatch: add pinctrl_ops and pinmux_ops
has been added to the -mm tree.  Its filename is
     const_structscheckpatch-add-pinctrl_ops-and-pinmux_ops.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/const_structscheckpatch-add-p=
inctrl_ops-and-pinmux_ops.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/const_structscheckpatch-add-p=
inctrl_ops-and-pinmux_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: const_structs.checkpatch: add pinctrl_ops and pinmux_ops

All usages of include/linux of these are const pointers, and all instances
in the kernel except one, that are not const can be made const (patches
have been posted for those separately).

Link: https://lkml.kernel.org/r/20200830224352.37114-1-rikard.falkeborn@gma=
il.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andreas F=C3=A4rber <afaerber@suse.de
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

const_structscheckpatch-add-phy_ops.patch
const_structscheckpatch-add-pinctrl_ops-and-pinmux_ops.patch

