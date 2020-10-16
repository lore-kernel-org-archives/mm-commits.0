Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518FAC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0A69208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816270;
	bh=aWBwJROzFUL+s4OwAT8RQ+dsCodAePYLkZ/UcaiNnZI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=e1gkSvOP6S/geRjP9fxV7NNmBdAapVUcQa7y+E+kHyeq4Fzbg/ITAkRr7829SvmTL
	 8iTKjBNGU7W0aDz4Jev42SgUWKh3iZ8QAezLKCJWCLd7XGbXJgBHkc/7Ez9YIFp863
	 VB7QwMHedHEwitczd6G/zNN47b7Vz/es8gziEHBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393831AbgJPCo3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389682AbgJPCo3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:44:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B51ED20897;
        Fri, 16 Oct 2020 02:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816269;
        bh=aWBwJROzFUL+s4OwAT8RQ+dsCodAePYLkZ/UcaiNnZI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZUJ1KcXP0ypEtk2s1Do4gGQbjYs8HJJxKpzgh72FxNXXn9DY/tJoFyLALqsfMYkoW
         g8/fSd9F+Qj/xc2N7Q0Nhn1Ri5t7vj/NUi/VGIL1Q40eWSnxmkUgOaDnbIgjh3dChN
         jR9v3EXYANYQH5vI1k+zkwx7jxBtTa3jKOur7M4A=
Date:   Thu, 15 Oct 2020 19:44:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bgolaszewski@baylibre.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 057/156] mm/util.c: update the kerneldoc for
 kstrdup_const()
Message-ID: <20201016024428._drthOkQa%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: mm/util.c: update the kerneldoc for kstrdup_const()

Memory allocated with kstrdup_const() must not be passed to regular
krealloc() as it is not aware of the possibility of the chunk residing in
.rodata.  Since there are no potential users of krealloc_const() at the
moment, let's just update the doc to make it explicit.

Link: http://lkml.kernel.org/r/20200817173927.23389-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
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
