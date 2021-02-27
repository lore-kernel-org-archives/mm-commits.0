Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C135CC433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE1564F3D
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhB0CdT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230194AbhB0Ccj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CFFE64F48;
        Sat, 27 Feb 2021 02:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393121;
        bh=ULdGyV+P9YOVVgmfolIoD1+xnfWfOjLoYtQhOYfR9vQ=;
        h=Date:From:To:Subject:From;
        b=Qu9xvScgGAN34fN7Fur5qPNAZOGfN7SNP0FbDvco9Y4mKH9uDMX7ZqbSe7hvqpnYE
         6rW1Qi/MaUhXEwjG+rLFbw3Aq92kfEqbgINelCauHo6MxpyFyqI9al2aPz5GqjcoJJ
         OCG0Q5mfUOx5BIJlB35HmIaJTMxw3YBDdW8YHE9Y=
Date:   Fri, 26 Feb 2021 18:32:01 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjhuang@iluvatar.ai
Subject:  [merged]
 lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll.patch
 removed from -mm tree
Message-ID: <20210227023201.Nj1KbwNP-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc.c: change return type to unsigned long for bitmap_set_ll
has been removed from the -mm tree.  Its filename was
     lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Shijie <sjhuang@iluvatar.ai>
Subject: lib/genalloc.c: change return type to unsigned long for bitmap_set_ll

Just as bitmap_clear_ll(), change return type to unsigned long
for bitmap_set_ll to avoid the possible overflow in future.

Link: https://lkml.kernel.org/r/20210105031644.2771-1-sjhuang@iluvatar.ai
Signed-off-by: Huang Shijie <sjhuang@iluvatar.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/genalloc.c~lib-genalloc-change-return-type-to-unsigned-long-for-bitmap_set_ll
+++ a/lib/genalloc.c
@@ -81,7 +81,8 @@ static int clear_bits_ll(unsigned long *
  * users set the same bit, one user will return remain bits, otherwise
  * return 0.
  */
-static int bitmap_set_ll(unsigned long *map, unsigned long start, unsigned long nr)
+static unsigned long
+bitmap_set_ll(unsigned long *map, unsigned long start, unsigned long nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
 	const unsigned long size = start + nr;
_

Patches currently in -mm which might be from sjhuang@iluvatar.ai are


