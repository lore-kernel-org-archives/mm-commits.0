Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D161DC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA85261476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbhGAB51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB51 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E87061469;
        Thu,  1 Jul 2021 01:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104496;
        bh=1r4RZLNo8SkhQuLOS8DJMsoMAgtwTPXj8MVi3tBh+n8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IHXpJN4DUG6rbER2O4H8tNuWGWqDtifNcQF6Uv8ogQmYw45IXIN19av2Zl5z5KIJd
         nf2ZEQ90II6OZyiztwKPsiEwlGl6eBy8rnHAjLWb/r/FUPBgre1BW5ilTy7lXP3M21
         MxBm5K48LUer+FT+lx3i8wIGlF8yaOX5h4i9AAbk=
Date:   Wed, 30 Jun 2021 18:54:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        jani.nikula@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 145/192] drm: include only needed headers in
 ascii85.h
Message-ID: <20210701015456.fEwxQa2nY%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drm: include only needed headers in ascii85.h

The ascii85.h is user of exactly two headers, i.e.  math.h and types.h. 
There is no need to carry on entire kernel.h.

Link: https://lkml.kernel.org/r/20210611185915.44181-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ascii85.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/ascii85.h~drm-include-only-needed-headers-in-ascii85h
+++ a/include/linux/ascii85.h
@@ -8,7 +8,8 @@
 #ifndef _ASCII85_H_
 #define _ASCII85_H_
 
-#include <linux/kernel.h>
+#include <linux/math.h>
+#include <linux/types.h>
 
 #define ASCII85_BUFSZ 6
 
_
