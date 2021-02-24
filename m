Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7DFC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9965064E20
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhBXUFS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235479AbhBXUDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C8A64F0E;
        Wed, 24 Feb 2021 20:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196985;
        bh=5ensjn87mwrhvVw9AWrG1AEYC9m7pNc5DwXvSR53iok=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g7+uOkmIc4/PHUOjStnTjfbRllasW4w48W8KA7sKszdq5UmIrmwY3KqGcqw/TKxne
         KcrafOSDyQmVLaMuF5yavSTZ4FBP2MHtmM/bSkZfFhIYdyaaubGwN33DmCap7uxw4H
         Dm76YcHDkzMPV5miwUoVxPaM4IrMhnEl30cMIzA4=
Date:   Wed, 24 Feb 2021 12:03:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, enbyamy@gmail.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, torvalds@linux-foundation.org,
        ying.huang@intel.com
Subject:  [patch 053/173] mm/swap_state: constify static struct
 attribute_group
Message-ID: <20210224200305.LTTJ0SaIm%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: mm/swap_state: constify static struct attribute_group

The only usage of swap_attr_group is to pass its address to
sysfs_create_group() which takes a pointer to const attribute_group.  Make
it const to allow the compiler to put it in read-only memory.

Link: https://lkml.kernel.org/r/20210201233254.91809-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reviewed-by: Amy Parker <enbyamy@gmail.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap_state-constify-static-struct-attribute_group
+++ a/mm/swap_state.c
@@ -927,7 +927,7 @@ static struct attribute *swap_attrs[] =
 	NULL,
 };
 
-static struct attribute_group swap_attr_group = {
+static const struct attribute_group swap_attr_group = {
 	.attrs = swap_attrs,
 };
 
_
