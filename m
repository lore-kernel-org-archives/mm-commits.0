Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9101EC433DB
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 00:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 659DA64D5D
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 00:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhBBAop (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 19:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhBBAok (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 19:44:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B409D64D5D;
        Tue,  2 Feb 2021 00:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612226639;
        bh=CtDTrh2PObgOiiT8A7+cvJLuT0g9HIKx5+9VvAF+yuA=;
        h=Date:From:To:Subject:From;
        b=N2pHA0f1DvElWhoQG9uInV75txHXeKSe9Oanu0WzmdH03kWXXbYySO8VgqF2DDAsz
         vGLXPDezkYunvBtm8TQzbCULzn92gXY5I5K0mBRhDuzZuhNZKtCTnHfiUqmBHaS9Xn
         5RxvFdZdj3G3wSyf6oLUQNMmbg6/8jGCKZU+5t+A=
Date:   Mon, 01 Feb 2021 16:43:59 -0800
From:   akpm@linux-foundation.org
To:     enbyamy@gmail.com, mm-commits@vger.kernel.org,
        rikard.falkeborn@gmail.com, ying.huang@intel.com
Subject:  +
 mm-swap_state-constify-static-struct-attribute_group.patch added to -mm
 tree
Message-ID: <20210202004359.-wTIhs4th%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_state: constify static struct attribute_group
has been added to the -mm tree.  Its filename is
     mm-swap_state-constify-static-struct-attribute_group.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap_state-constify-static-struct-attribute_group.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_state-constify-static-struct-attribute_group.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: mm/swap_state: constify static struct attribute_group

The only usage of swap_attr_group is to pass its address to
sysfs_create_group() which takes a pointer to const attribute_group.  Make
it const to allow the compiler to put it in read-only memory.

Link: https://lkml.kernel.org/r/20210201233254.91809-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reviewed-by: Amy Parker <enbyamy@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
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

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are

mm-swap_state-constify-static-struct-attribute_group.patch

