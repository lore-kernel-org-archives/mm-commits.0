Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA93C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0989661361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhKKCy0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhKKCy0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 889EB60F26;
        Thu, 11 Nov 2021 02:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599098;
        bh=/IQocBlkxLuhAhIye7oSqbvMWm02oyMwbT4CEEDMpxY=;
        h=Date:From:To:Subject:From;
        b=ZunFMg8nDS9V++R4KNuah5v6awgUkzNb0JmkAo/AzGd9tPQBNdXiyaRFbNo1N2/+y
         ZbGFSk/nAqsnYxV7H+dEA1I8IrjRKV2bgHqAEOMqsTqFdHzqvpq4DaJpNaeFxX4u3t
         SkxUxHnGuii4GD0RvyWbOKQcobeME0A+TbV8E8gI=
Date:   Wed, 10 Nov 2021 18:51:37 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, boqun.feng@gmail.com,
        brendanhiggins@google.com, jic23@kernel.org,
        laurent.pinchart@ideasonboard.com, linux@rasmusvillemoes.dk,
        longman@redhat.com, mchehab@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        regressions@leemhuis.info, sakari.ailus@linux.intel.com,
        tglx@linutronix.de, will@kernel.org
Subject:  [merged]
 media-entity-replace-kernelh-with-the-necessary-inclusions.patch removed
 from -mm tree
Message-ID: <20211111025137.xELvYYs83%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/media/media-entity.h: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     media-entity-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/media/media-entity.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211013170417.87909-8-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/media/media-entity.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/media/media-entity.h~media-entity-replace-kernelh-with-the-necessary-inclusions
+++ a/include/media/media-entity.h
@@ -13,10 +13,11 @@
 
 #include <linux/bitmap.h>
 #include <linux/bug.h>
+#include <linux/container_of.h>
 #include <linux/fwnode.h>
-#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/media.h>
+#include <linux/types.h>
 
 /* Enums used internally at the media controller to represent graphs */
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


