Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9E0C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A29F2075E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 02:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597803812;
	bh=hP2jHhHaVWreCUhI+4eF+IFndSo0HWL/VOrzMoDIT7I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jWfuiQzXVLQ/5/8ML+gFWg9pzbz4TwHUEfEZRwjd+d4oInehLsCDgBrqsot8UMDqe
	 LD0jsZluF4wZMy1Ort5GW7BVndXCIHvonbVxctcnxUzDB5sh8qSQc3zCYNowvOZ8sv
	 l5K95twZrkGynd+0hZWBOocbAY4FWf0BvKRiaMZs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHSCXc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgHSCXb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 22:23:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1E2A205CB;
        Wed, 19 Aug 2020 02:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597803810;
        bh=hP2jHhHaVWreCUhI+4eF+IFndSo0HWL/VOrzMoDIT7I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Wz7ndPTKIyBrGIn2M6quUzHgQRQEOH+vWWmOziELAkrM8TryTcbO6AG5OTsq1gn0b
         fo0ss1R3Sy1BXeinS37/Vz7LugaPvFhubde+1dQYNKdbHLcx1wlWZIez9PA2xR9GtW
         SzmLXpYIxxjWR/KctQugCp+XigpwyVex3jsa8kL4=
Date:   Tue, 18 Aug 2020 19:23:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bgolaszewski@baylibre.com, mm-commits@vger.kernel.org
Subject:  + mm-util-update-the-kerneldoc-for-kstrdup_const.patch
 added to -mm tree
Message-ID: <20200819022330.EjYqn_cBT%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util.c: update the kerneldoc for kstrdup_const()
has been added to the -mm tree.  Its filename is
     mm-util-update-the-kerneldoc-for-kstrdup_const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-util-update-the-kerneldoc-for-kstrdup_const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-util-update-the-kerneldoc-for-kstrdup_const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: mm/util.c: update the kerneldoc for kstrdup_const()

Memory allocated with kstrdup_const() must not be passed to regular
krealloc() as it is not aware of the possibility of the chunk residing in
.rodata.  Since there are no potential users of krealloc_const() at the
moment, let's just update the doc to make it explicit.

Link: http://lkml.kernel.org/r/20200817173927.23389-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-util-update-the-kerneldoc-for-kstrdup_const
+++ a/mm/util.c
@@ -69,7 +69,8 @@ EXPORT_SYMBOL(kstrdup);
  * @s: the string to duplicate
  * @gfp: the GFP mask used in the kmalloc() call when allocating memory
  *
- * Note: Strings allocated by kstrdup_const should be freed by kfree_const.
+ * Note: Strings allocated by kstrdup_const should be freed by kfree_const and
+ * must not be passed to krealloc().
  *
  * Return: source string if it is in .rodata section otherwise
  * fallback to kstrdup.
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are

mm-util-update-the-kerneldoc-for-kstrdup_const.patch

