From: akpm@linux-foundation.org
Subject: [merged] uapi-mqueueh-add-missing-linux-typesh-include.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:28:33 -0800
Message-ID: <58b48bf1.Eb7iIsdvmYwyHOTS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbdB0U2e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@chromium.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: uapi: mqueue.h: add missing linux/types.h include
has been removed from the -mm tree.  Its filename was
     uapi-mqueueh-add-missing-linux-typesh-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vapier@chromium.org are


