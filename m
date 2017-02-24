From: akpm@linux-foundation.org
Subject: [patch 094/124] alpha: use generic current.h
Date: Fri, 24 Feb 2017 15:00:14 -0800
Message-ID: <58b0bafe.5rGN3PJ9MHFomNkc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38940 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751692AbdBXXAQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: alpha: use generic current.h

Given that the arch does not add its own implementations, simply use the
asm-generic/current.h (generic-y) header instead of duplicating code.

Link: http://lkml.kernel.org/r/1485992878-4780-2-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/Kbuild    |    1 +
 arch/alpha/include/asm/current.h |    9 ---------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff -puN arch/alpha/include/asm/Kbuild~alpha-use-generic-currenth arch/alpha/include/asm/Kbuild
--- a/arch/alpha/include/asm/Kbuild~alpha-use-generic-currenth
+++ a/arch/alpha/include/asm/Kbuild
@@ -9,3 +9,4 @@ generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += sections.h
 generic-y += trace_clock.h
+generic-y += current.h
diff -puN arch/alpha/include/asm/current.h~alpha-use-generic-currenth /dev/null
--- a/arch/alpha/include/asm/current.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _ALPHA_CURRENT_H
-#define _ALPHA_CURRENT_H
-
-#include <linux/thread_info.h>
-
-#define get_current()	(current_thread_info()->task)
-#define current		get_current()
