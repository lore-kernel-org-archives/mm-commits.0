Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B01C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BFAE20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816532;
	bh=jyUocxiXBBSZNdxBVCQrGeNcaP25hehE2DHu8Mzja8o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PSv47fwuzlGXetMFpAlcAAZMwJpzPH9hGSXwH4qE1jYo0w6Gq5lajMynXpnV50I68
	 DbMpkpetZo7gFukkjfL1z5C73ZCDkfFJmrX/V1pmww+yDJoIdg3LjQ+CUDvkR+MUor
	 kKWXR6sDXQamKaJj9wZw8TvhrhTiLcyzR9wR53NY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404376AbgJPCsv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404364AbgJPCsv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 824C62087D;
        Fri, 16 Oct 2020 02:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816531;
        bh=jyUocxiXBBSZNdxBVCQrGeNcaP25hehE2DHu8Mzja8o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g5oIk+yrKZVU+Wug63kUDKjSM79SJTHFfQTIIft4sZ9txFOnh7IC/Q3dRAfmyJtYf
         IJllQ20dAJemvo1cgu4p9M+mkZ8H7HkWopvIDsokof+z0P2Brxfy94mrB5LTY1D/zF
         e3IwHSNWvBK7rGHDrVvMPnO9RE8YQH2XFcqVoNfc=
Date:   Thu, 15 Oct 2020 19:48:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, kishon@ti.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, torvalds@linux-foundation.org,
        vkoul@kernel.org
Subject:  [patch 124/156] const_structs.checkpatch: add phy_ops
Message-ID: <20201016024849.48Vhholia%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
