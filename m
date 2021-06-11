Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3FCC48BE0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1089D613D0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFKWMk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 18:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhFKWMk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 18:12:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F190613CD;
        Fri, 11 Jun 2021 22:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623449425;
        bh=EyMdH/wDC6Hg3lo/Jl5PWdJjnA921AHfuMbvD/IThUI=;
        h=Date:From:To:Subject:From;
        b=sMmOns6U9JkRtCwHgUT2zxC57A96gjBEfTdHrsMJl6JJHl2xdMhsLmN5ZnLNV+h0D
         cZHX+7g98yXxkdQ9zMEw4Ay+cjijM6ULXSobkKh1ToRui5sreDW2mic2GuNGoRioMS
         HFG7TmrDo/YGN0I29mtaS441CRezO3buSKusTafg=
Date:   Fri, 11 Jun 2021 15:10:25 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, jani.nikula@intel.com,
        mm-commits@vger.kernel.org
Subject:  + drm-include-only-needed-headers-in-ascii85h.patch added
 to -mm tree
Message-ID: <20210611221025.TfxE4xE8m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm: include only needed headers in ascii85.h
has been added to the -mm tree.  Its filename is
     drm-include-only-needed-headers-in-ascii85h.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drm-include-only-needed-headers-in-ascii85h.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drm-include-only-needed-headers-in-ascii85h.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drm-include-only-needed-headers-in-ascii85h.patch
kernelh-split-out-panic-and-oops-helpers.patch
kernelh-split-out-panic-and-oops-helpers-fix-2.patch
lib-string_helpers-switch-to-use-bit-macro.patch
lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch
lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch
lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch
lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable.patch
lib-string_helpers-allow-to-append-additional-characters-to-be-escaped.patch
lib-test-string_helpers-print-flags-in-hexadecimal-format.patch
lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
lib-test-string_helpers-add-test-cases-for-new-features.patch
maintainers-add-myself-as-designated-reviewer-for-generic-string-library.patch
seq_file-introduce-seq_escape_mem.patch
seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch
seq_file-convert-seq_escape-to-use-seq_escape_str.patch
nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
seq_file-drop-unused-_escape_mem_ascii.patch

