Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF8DC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B659161207
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbhKICfY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AE5460FDA;
        Tue,  9 Nov 2021 02:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425158;
        bh=iWSPbwKm3Ut+kCN6SZjua/+Z15cYj/5BAmazUExmKqE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sijet7JGdKOwHhFYLaTbEuNsEa/qKZvRmBIwxiJsbgH9ml2b1R/BcuP5GtmKF9cQn
         5c+RpUUE/3iACDMtj0yRA2PMHU8U8/uHO+cCEFUPQvxPtDjbinX2P4tE1uKWxhQYuS
         /GFuP8A/AtTGeWXrKALDBxGz8pGQ5CeE3I9gqksM=
Date:   Mon, 08 Nov 2021 18:32:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 23/87] include/linux/radix-tree.h: replace
 kernel.h with the necessary inclusions
Message-ID: <20211109023238.1j6j-Q4I1%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/radix-tree.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211027150528.80003-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/radix-tree.h~radix-tree-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/radix-tree.h
@@ -9,8 +9,10 @@
 #define _LINUX_RADIX_TREE_H
 
 #include <linux/bitops.h>
-#include <linux/kernel.h>
+#include <linux/gfp.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
+#include <linux/math.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/rcupdate.h>
_
