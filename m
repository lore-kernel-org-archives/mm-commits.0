Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BC2C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E18860FC1
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhKICfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0880D60FC1;
        Tue,  9 Nov 2021 02:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425136;
        bh=Zkwih8v5KzkXTq1+uuZTkIcshvTTOHzP2JGmoZzBJYY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uxgxBVeURhPuS8w+iNj8Yslls/0WZbpxcM3OvQrC3drhjkNVesctpsO4iDWnK6m+z
         UQew/5lenTDhrXh0bJe8pA4nyOl/oAgb50EptAnEDMZ4Be42ad9IaNGebRQnQ/o2bG
         R965Pg2VxNiQMLbQGuCusS+60U6/NBVPdj5YxytY=
Date:   Mon, 08 Nov 2021 18:32:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        boqun.feng@gmail.com, brendanhiggins@google.com, jic23@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, longman@redhat.com, mchehab@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        regressions@leemhuis.info, sakari.ailus@linux.intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 16/87] include/kunit/test.h: replace kernel.h with
 the necessary inclusions
Message-ID: <20211109023215.saiG4xVX8%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/kunit/test.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211013170417.87909-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/kunit/test.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/include/kunit/test.h~kunit-replace-kernelh-with-the-necessary-inclusions
+++ a/include/kunit/test.h
@@ -11,11 +11,20 @@
 
 #include <kunit/assert.h>
 #include <kunit/try-catch.h>
-#include <linux/kernel.h>
+
+#include <linux/container_of.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kconfig.h>
+#include <linux/kref.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/types.h>
-#include <linux/kref.h>
+
+#include <asm/rwonce.h>
 
 struct kunit_resource;
 
_
