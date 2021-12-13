Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293E3C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 21:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbhLMVUl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 16:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbhLMVUl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 16:20:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A45CC061574
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 13:20:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C68261200
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 21:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5A3C34600;
        Mon, 13 Dec 2021 21:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639430439;
        bh=xv9wnuU2u0uavhqfIdyWTu1WJAfKIrZvCWn71T5e0tQ=;
        h=Date:From:To:Subject:From;
        b=JImfpulOD6uxRxiLW06ngpd21TbuStTGlbIwDLz/9Qh1+/IpKmkOd33eT293Ya944
         De0Wm9K6SDOziThYBMUN1r/BBFaeU9neC9815yqXvlfC4eovo92ULoHg/zfyDvWFGG
         hJVGg2v2AsQuKe1yrNsSTiY+KfTvb4u7lmWfvhc4=
Date:   Mon, 13 Dec 2021 13:20:39 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        mm-commits@vger.kernel.org
Subject:  +
 kunit-replace-kernelh-with-the-necessary-inclusions.patch added to -mm tree
Message-ID: <20211213212039.hj64ksVU_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kunit: replace kernel.h with the necessary inclusions
has been added to the -mm tree.  Its filename is
     kunit-replace-kernelh-with-the-necessary-inclusions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kunit-replace-kernelh-with-the-necessary-inclusions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kunit-replace-kernelh-with-the-necessary-inclusions.patch

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
Subject: kunit: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211213204441.56204-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/kunit/assert.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/kunit/assert.h~kunit-replace-kernelh-with-the-necessary-inclusions
+++ a/include/kunit/assert.h
@@ -10,7 +10,7 @@
 #define _KUNIT_ASSERT_H
 
 #include <linux/err.h>
-#include <linux/kernel.h>
+#include <linux/printk.h>
 
 struct kunit;
 struct string_stream;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions.patch
kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch
list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch
kunit-replace-kernelh-with-the-necessary-inclusions.patch

