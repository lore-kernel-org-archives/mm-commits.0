Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA845C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDEC611BD
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 21:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhJMVXv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhJMVXv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 17:23:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B776117A;
        Wed, 13 Oct 2021 21:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634160107;
        bh=C1wMdRkoOLRhfSKNQyFXDNBqEXs0RpucjT5I+0OobSI=;
        h=Date:From:To:Subject:From;
        b=sEamJssvh3yHbbetTzuq5vAAqWUxwEj/8zD2U4s1Q1rYNUAUmziHQRCSBFTmPkEn1
         +QYewO8ccTj+vDZ5ryjFT/raGxDHIQNDNAXR0yLZNpLtm4Jb6Jn1YKucNXGRl/A3JT
         87Ol3JDhqw7V3Ah5RrwNFeGdSstolojw9AmIvbzk=
Date:   Wed, 13 Oct 2021 14:21:46 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, boqun.feng@gmail.com,
        brendanhiggins@google.com, jic23@kernel.org,
        laurent.pinchart@ideasonboard.com, linux@rasmusvillemoes.dk,
        longman@redhat.com, mchehab@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        regressions@leemhuis.info, sakari.ailus@linux.intel.com,
        tglx@linutronix.de, will@kernel.org
Subject:  +
 plist-replace-kernelh-with-the-necessary-inclusions.patch added to -mm tree
Message-ID: <20211013212146.XPw1wvxqT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/plist.h: replace kernel.h with the necessary inclusions
has been added to the -mm tree.  Its filename is
     plist-replace-kernelh-with-the-necessary-inclusions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/plist-replace-kernelh-with-the-necessary-inclusions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/plist-replace-kernelh-with-the-necessary-inclusions.patch

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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers.patch
kernelh-split-out-container_of-and-typeof_member-macros.patch
kunit-replace-kernelh-with-the-necessary-inclusions.patch
list-replace-kernelh-with-the-necessary-inclusions.patch
llist-replace-kernelh-with-the-necessary-inclusions.patch
plist-replace-kernelh-with-the-necessary-inclusions.patch
media-entity-replace-kernelh-with-the-necessary-inclusions.patch
seq_file-move-seq_escape-to-a-header.patch

