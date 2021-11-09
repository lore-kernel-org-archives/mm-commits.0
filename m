Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE96EC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B753C61208
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhKICfM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D8BE60FC1;
        Tue,  9 Nov 2021 02:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425146;
        bh=cMc2eDzJBNH/eGJ8r56aB3xDaxtoF8J/J3TN1cUS3p0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U4vgSEDBcyDqM5EXrByMBwsmh7hGo0rC+9rWBgu5AVaZTa2SNnqDW914/K09Yos1v
         FY2c8MY2fgJaI7ocfliJFyo2EKE01vcx87UOxrseb9wiw2cjnTzD+kEHjlTxlxZyKH
         nncGMh2853OoPgSHmLA+3U6fSbzveYgBWyjrVk3o=
Date:   Mon, 08 Nov 2021 18:32:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        boqun.feng@gmail.com, brendanhiggins@google.com, jic23@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, longman@redhat.com, mchehab@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        regressions@leemhuis.info, sakari.ailus@linux.intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 19/87] include/linux/plist.h: replace kernel.h
 with the necessary inclusions
Message-ID: <20211109023225.dkXMMYQ0t%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/plist.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211013170417.87909-7-andriy.shevchenko@linux.intel.com
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

 include/linux/plist.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/plist.h~plist-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/plist.h
@@ -73,8 +73,11 @@
 #ifndef _LINUX_PLIST_H_
 #define _LINUX_PLIST_H_
 
-#include <linux/kernel.h>
+#include <linux/container_of.h>
 #include <linux/list.h>
+#include <linux/types.h>
+
+#include <asm/bug.h>
 
 struct plist_head {
 	struct list_head node_list;
_
