Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A52C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269CF61CA7
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhGFTYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhGFTYg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B72C61CA6;
        Tue,  6 Jul 2021 19:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599316;
        bh=p2MVwEzQaHaMTYepP8gF3dkerqNKC4qq9LYM0VjLJjw=;
        h=Date:From:To:Subject:From;
        b=oiWLwT+jPR0omkzrB0CtNQNV09HxqJCotYE2X43CwW208ZoKrfAmUaozhpG8o4AdV
         bN+D13jGp/UrE93QRZ5eCw4bEK3zgJCwQYqgnnXUVp8MpuJC0hLYN9D7JxUEE3MKoC
         XPEQR7E35F1TGucvhKRobeHTu3DKymqArrQzqtjs=
Date:   Tue, 06 Jul 2021 12:21:56 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, jani.nikula@intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 drm-include-only-needed-headers-in-ascii85h.patch removed from -mm tree
Message-ID: <20210706192156.lK0iju_x4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm: include only needed headers in ascii85.h
has been removed from the -mm tree.  Its filename was
     drm-include-only-needed-headers-in-ascii85h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


