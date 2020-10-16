Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9A4C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3CC2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817922;
	bh=jyUocxiXBBSZNdxBVCQrGeNcaP25hehE2DHu8Mzja8o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JRUrgsevqgWpVndn0ngpNdjaCshqeyyJN07fscOZqeylOJ4JAejrbM3noK3Oku0B0
	 W+BV4By+dhJHhXd6bk3PHHcB9fpM1hxCbqfqd+dtFcpN9ZZWZAcWPavX571EJpwXA3
	 Q4yzv7lR9NHGSOqHFgU3atIKgtmaUz82MdxytipY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389428AbgJPDMB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDMB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5AEB20789;
        Fri, 16 Oct 2020 03:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817920;
        bh=jyUocxiXBBSZNdxBVCQrGeNcaP25hehE2DHu8Mzja8o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mLWHiQQ2/s9rHZcRjCMUIag13lVgj1lXgv9tQq7Zc8jD7NM56tLTdfkymCW895vnT
         YMREi5SgyNdIKMd2Yl6SeaIemgrDb0aG1M7Mbs4cV5j7iy2iY8XCy/9Du8FLUU5o4h
         NjRnL8pvIg8k895F9AwbmOXrYVT4oGfpEDVxsnuE=
Date:   Thu, 15 Oct 2020 20:11:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, kishon@ti.com,
        mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com,
        torvalds@linux-foundation.org, vkoul@kernel.org
Subject:  [patch 124/156] const_structs.checkpatch: add phy_ops
Message-ID: <20201016031159.6XQp_GEef%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
