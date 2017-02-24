From: akpm@linux-foundation.org
Subject: [patch 098/124] uapi: mqueue.h: add missing linux/types.h include
Date: Fri, 24 Feb 2017 15:00:26 -0800
Message-ID: <58b0bb0a.pO/uMwkJ/Z1Iks/R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38976 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdBXXA1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vapier@chromium.org, vapier@gentoo.org

From: Mike Frysinger <vapier@chromium.org>
Subject: uapi: mqueue.h: add missing linux/types.h include

Commit 63159f5dcccb385 ("uapi: Use __kernel_long_t in struct mq_attr")
changed the types from long to __kernel_long_t, but didn't add a
linux/types.h include.  Code that tries to include this header directly
breaks:

/usr/include/linux/mqueue.h:26:2: error: unknown type name '__kernel_long_t'
  __kernel_long_t mq_flags; /* message queue flags   */

This also upsets configure tests for this header:
checking linux/mqueue.h usability... no
checking linux/mqueue.h presence... yes
configure: WARNING: linux/mqueue.h: present but cannot be compiled
configure: WARNING: linux/mqueue.h:     check for missing prerequisite headers?
configure: WARNING: linux/mqueue.h: see the Autoconf documentation
configure: WARNING: linux/mqueue.h:     section "Present But Cannot Be Compiled"
configure: WARNING: linux/mqueue.h: proceeding with the compiler's result
checking for linux/mqueue.h... no

Link: http://lkml.kernel.org/r/20170119194644.4403-1-vapier@gentoo.org
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mqueue.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/uapi/linux/mqueue.h~uapi-mqueueh-add-missing-linux-typesh-include include/uapi/linux/mqueue.h
--- a/include/uapi/linux/mqueue.h~uapi-mqueueh-add-missing-linux-typesh-include
+++ a/include/uapi/linux/mqueue.h
@@ -18,6 +18,8 @@
 #ifndef _LINUX_MQUEUE_H
 #define _LINUX_MQUEUE_H
 
+#include <linux/types.h>
+
 #define MQ_PRIO_MAX 	32768
 /* per-uid limit of kernel memory used by mqueue, in bytes */
 #define MQ_BYTES_MAX	819200
_
