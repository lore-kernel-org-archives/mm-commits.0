Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0C0C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F51720897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817661;
	bh=aWBwJROzFUL+s4OwAT8RQ+dsCodAePYLkZ/UcaiNnZI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=AsbFqnoqNNzJCUQijODkH4ZOpLmBPKzWlO/KCyK/nMZz/n2GK/wGpGCr4e7VvnR9k
	 6bMUSEm+eHLiONQdrd62cFskn/EupBo/jhm0LYTU/FFioExQ8vOUpojaQXQPNZOvuh
	 PxSNIaRUfAXS/zyrdFzkwHX3scZMTR3GFeMa9EhA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732489AbgJPDHl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDHl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:07:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 510FD20789;
        Fri, 16 Oct 2020 03:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817660;
        bh=aWBwJROzFUL+s4OwAT8RQ+dsCodAePYLkZ/UcaiNnZI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1AEjigm7yd4c0veURolWjfw2KzRX/yPD92hvlSB9qgNWX27XZjzq0qI1V8JEM2nvp
         GiF0Rt0qMTdCHidJqFQ8rfNuQ/OBKNa0gKcQD8tL/jiysI2xpw6zawsmfEyVclZ/yL
         rIqhfZFXERMF/u0gxBXXftLebU3GqHQqT34MUJYs=
Date:   Thu, 15 Oct 2020 20:07:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bgolaszewski@baylibre.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 057/156] mm/util.c: update the kerneldoc for
 kstrdup_const()
Message-ID: <20201016030739.mlLqAUAAY%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
