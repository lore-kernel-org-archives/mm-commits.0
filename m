Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8724FC4321A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1B964F43
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhBYTXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234660AbhBYTUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB86C64F5D;
        Thu, 25 Feb 2021 19:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280424;
        bh=Du+T/dIMO9kqXNiBN1G/PGkK1wlUg0eqOjIaurLLzpQ=;
        h=Date:From:To:Subject:From;
        b=Io433WrwPK6gw2kOSF0k1aaayvjb+ODbbxzrnJ6c0sbNHaDDjdUPEJi6c7dbZ26xD
         ts7/b/f0yWdK0ekRsxG8fEArinDtK8Us+4YNQZUj0ZwQROoolF+jcXg3vEcTIyW7NQ
         yhb37qzaBliLqFfU6G3EV7gcBCsXM3LmSz7aH4WY=
Date:   Thu, 25 Feb 2021 11:13:43 -0800
From:   akpm@linux-foundation.org
To:     enbyamy@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com,
        ying.huang@intel.com
Subject:  [merged]
 mm-swap_state-constify-static-struct-attribute_group.patch removed from -mm
 tree
Message-ID: <20210225191343.mAAZWUJYQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_state: constify static struct attribute_group
has been removed from the -mm tree.  Its filename was
     mm-swap_state-constify-static-struct-attribute_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rikard.falkeborn@gmail.com are


