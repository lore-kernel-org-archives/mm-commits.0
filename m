From: akpm@linux-foundation.org
Subject: [patch 001/124] cris: use generic current.h
Date: Fri, 24 Feb 2017 14:55:36 -0800
Message-ID: <58b0b9e8.XKh4HDdxTqPZMCS4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXWzh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:55:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, jesper.nilsson@axis.com, starvik@axis.com

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: cris: use generic current.h

Given that the arch does not add its own implementations, simply use the
asm-generic/current.h (generic-y) header instead of duplicating code.

Link: http://lkml.kernel.org/r/1485992878-4780-3-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/Kbuild    |    1 +
 arch/cris/include/asm/current.h |   15 ---------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff -puN arch/cris/include/asm/Kbuild~cris-use-generic-currenth arch/cris/include/asm/Kbuild
--- a/arch/cris/include/asm/Kbuild~cris-use-generic-currenth
+++ a/arch/cris/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += barrier.h
 generic-y += bitsperlong.h
 generic-y += clkdev.h
 generic-y += cmpxchg.h
+generic-y += current.h
 generic-y += device.h
 generic-y += div64.h
 generic-y += errno.h
diff -puN arch/cris/include/asm/current.h~cris-use-generic-currenth /dev/null
--- a/arch/cris/include/asm/current.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _CRIS_CURRENT_H
-#define _CRIS_CURRENT_H
-
-#include <linux/thread_info.h>
-
-struct task_struct;
-
-static inline struct task_struct * get_current(void)
-{
-        return current_thread_info()->task;
-}
- 
-#define current get_current()
