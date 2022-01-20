Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C25EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377923AbiATVav (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347803AbiATVau (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F723C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A8EB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F84C340E0;
        Thu, 20 Jan 2022 21:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714247;
        bh=I0f45GBNL/2cLVIDF6BjAM9LeyyXXYb6E3eFcoSu7hw=;
        h=Date:From:To:Subject:From;
        b=nZdzWoFD++r8W73mjh4ignSi4HZ+ageSNicB6ze484ZX3rCUbie1rgKkuHNzFs5c4
         eZ9P1ZGhUM0Tgvkm3RFpYtK7uIoiaAinnTDd9Bbj0ne9ZLn0KIhcheo7k0FAkuYa07
         isLLPOO2joOEiiX7KC10rcExkmZenwIOzdJ6E8v8=
Date:   Thu, 20 Jan 2022 13:30:45 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 kunit-replace-kernelh-with-the-necessary-inclusions.patch removed from -mm
 tree
Message-ID: <20220120213045.TfpY9GtGs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kunit: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     kunit-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kunit: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211213204441.56204-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
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


