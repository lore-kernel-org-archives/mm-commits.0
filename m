Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2A4C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54FD160F9B
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbhKICfG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6895060FDA;
        Tue,  9 Nov 2021 02:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425140;
        bh=xaS/4gMGxH4k3UZcH44NT1UO7d3q6wRyjFuRHD4QayQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rm33K6+fKSBSUZon6O8h8Ii9IGQG8pWpCmppNXvEpC11EHIE+0hwvdHQIGzRuU2Xg
         MisFv44c4mzXSRvPmBIqeGjnYyruil+Ltel30/RpGoyb1J44ENwEF/0Q2qYm2fJa5P
         jBPr7VZefi+fvEdBOr3xifUfSB8OyU05HMaZs1Ag=
Date:   Mon, 08 Nov 2021 18:32:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        boqun.feng@gmail.com, brendanhiggins@google.com, jic23@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, longman@redhat.com, mchehab@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        regressions@leemhuis.info, sakari.ailus@linux.intel.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 17/87] include/linux/list.h: replace kernel.h with
 the necessary inclusions
Message-ID: <20211109023219.-B_aE4ZzH%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/list.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211013170417.87909-5-andriy.shevchenko@linux.intel.com
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

 include/linux/list.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/list.h~list-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/list.h
@@ -2,11 +2,13 @@
 #ifndef _LINUX_LIST_H
 #define _LINUX_LIST_H
 
+#include <linux/container_of.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/const.h>
-#include <linux/kernel.h>
+
+#include <asm/barrier.h>
 
 /*
  * Circular doubly linked list implementation.
_
