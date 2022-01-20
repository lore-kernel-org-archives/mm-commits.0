Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F17EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358169AbiATCIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCIT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 047ACB81C96
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865F1C004E1;
        Thu, 20 Jan 2022 02:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644496;
        bh=AA2akp7VY/A5iM30FL1WrqAncyGJ13k2KORgfT4bhOg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zHKMl9oce1rwDnBEikL8DFzyF1gdUhMsGFRSyq/7JxrpNyo0kMQAZGpI27/AkwrIb
         AiakqORe6h4Tgx1BI79a5VETugzyW7jtv8glif4/UMV5/fLMH7Z+mMlOCvIYX7aVUU
         0KW7hfZNn7jmN4ei0VEp7bQXYQmIPDh84W//vlcM=
Date:   Wed, 19 Jan 2022 18:08:16 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 11/55] kernel.h: include a note to discourage
 people from including it in headers
Message-ID: <20220120020816.2JA9JCn3x%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: include a note to discourage people from including it in headers

Include a note at the top to discourage people from including it in
headers.

Link: https://lkml.kernel.org/r/20211209150803.4473-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/kernel.h~kernelh-include-a-note-to-discourage-people-from-including-it-in-headers
+++ a/include/linux/kernel.h
@@ -1,4 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * NOTE:
+ *
+ * This header has combined a lot of unrelated to each other stuff.
+ * The process of splitting its content is in progress while keeping
+ * backward compatibility. That's why it's highly recommended NOT to
+ * include this header inside another header file, especially under
+ * generic or architectural include/ directory.
+ */
 #ifndef _LINUX_KERNEL_H
 #define _LINUX_KERNEL_H
 
_
