Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D30C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA4160F26
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbhKKCyW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhKKCyU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C945A6103C;
        Thu, 11 Nov 2021 02:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599092;
        bh=/RNEXw1MJcVJ+WXtp0f9b2jHKI4zVJlFe1y/CHTe6Dc=;
        h=Date:From:To:Subject:From;
        b=JPo1ecLYPG/QPXN+iTmhQgYiGmSRISBdDbAdJgA1JZ6FrWdNFFE8tdO4YEUlF7rrr
         lNWQ07jLB+T4oBBzx59Uue95DqostdCZtEyxlC8NbCnnUaDuzCGqL2fRjbCoZAUCGj
         3Y6XJHO6LA5D+/JHr5RuIsdxlFzpHCm5GDkZcHuk=
Date:   Wed, 10 Nov 2021 18:51:31 -0800
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
 llist-replace-kernelh-with-the-necessary-inclusions.patch removed from -mm
 tree
Message-ID: <20211111025131.X5xwFcDH7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/llist.h: replace kernel.h with the necessary inclusions
has been removed from the -mm tree.  Its filename was
     llist-replace-kernelh-with-the-necessary-inclusions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/llist.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211013170417.87909-6-andriy.shevchenko@linux.intel.com
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

 include/linux/llist.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/llist.h~llist-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/llist.h
@@ -49,7 +49,9 @@
  */
 
 #include <linux/atomic.h>
-#include <linux/kernel.h>
+#include <linux/container_of.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
 
 struct llist_head {
 	struct llist_node *first;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


