Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE1AC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88CA06124D
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhKICf3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICf3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5183A61208;
        Tue,  9 Nov 2021 02:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425164;
        bh=M7wIh2UgzBKDLLrnUTL6hm2UhxXRMuWMsO0N1dpxx00=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RKo6gn2vV0F6yS6Civx1Qtfq38Xs+gHuiVJw0UBcEMnE9KyMQ0DK5ZwJ8yM6sYQ/F
         VH321gCQgvbJSURXAXOpQxmTA8S4bzovjVaBgHyhymok8r15Yp/M8oqbHQKG5nD6l3
         97wpgQqQijaTFGEQunI5LOVxkefIsGJU+e5JfaS4=
Date:   Mon, 08 Nov 2021 18:32:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org
Subject:  [patch 25/87] kernel.h: split out instruction pointer
 accessors
Message-ID: <20211109023243.S5hAtR3lL%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kernel.h: split out instruction pointer accessors

bottom_half.h needs _THIS_IP_ to be standalone, so split that and _RET_IP_
out from kernel.h into the new instruction_pointer.h.  kernel.h directly
needs them, so include it there and replace the include of kernel.h with
this new file in bottom_half.h.

Link: https://lkml.kernel.org/r/20211028161248.45232-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bottom_half.h         |    2 +-
 include/linux/instruction_pointer.h |    8 ++++++++
 include/linux/kernel.h              |    4 +---
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/include/linux/bottom_half.h~kernelh-split-out-instruction-pointer-accessors
+++ a/include/linux/bottom_half.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_BH_H
 #define _LINUX_BH_H
 
-#include <linux/kernel.h>
+#include <linux/instruction_pointer.h>
 #include <linux/preempt.h>
 
 #if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_TRACE_IRQFLAGS)
--- /dev/null
+++ a/include/linux/instruction_pointer.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_INSTRUCTION_POINTER_H
+#define _LINUX_INSTRUCTION_POINTER_H
+
+#define _RET_IP_		(unsigned long)__builtin_return_address(0)
+#define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
+
+#endif /* _LINUX_INSTRUCTION_POINTER_H */
--- a/include/linux/kernel.h~kernelh-split-out-instruction-pointer-accessors
+++ a/include/linux/kernel.h
@@ -20,6 +20,7 @@
 #include <linux/printk.h>
 #include <linux/build_bug.h>
 #include <linux/static_call_types.h>
+#include <linux/instruction_pointer.h>
 #include <asm/byteorder.h>
 
 #include <uapi/linux/kernel.h>
@@ -53,9 +54,6 @@
 }					\
 )
 
-#define _RET_IP_		(unsigned long)__builtin_return_address(0)
-#define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
-
 /**
  * upper_32_bits - return bits 32-63 of a number
  * @n: the number we're accessing
_
