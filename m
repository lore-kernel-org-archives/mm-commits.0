Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75400C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiATCJa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50976 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358187AbiATCJW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15EADB81911
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAADC004E1;
        Thu, 20 Jan 2022 02:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644559;
        bh=wHMb/d7iTRtU+lCRJdgBEglZrd4aNcC3lloqoZU4GPE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vUft9x0dP3FsAtIrUmV0jqxpHOcajxPiOmGCMa0Ga1adPrM1QgzxfaD/UyJMV9QMi
         HvCMJ4z9U2eC6BEP28AEhq18fAa3JwPYrTUOLT0n9eGxPqmwv25yxtMt5IWMUxt2j3
         +KO8yvCiirS2TWbTaEwEVZV65S1ERILLbXxCpov0=
Date:   Wed, 19 Jan 2022 18:09:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        brendanhiggins@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 30/55] kunit: replace kernel.h with the necessary
 inclusions
Message-ID: <20220120020919.z3poNgHqR%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
