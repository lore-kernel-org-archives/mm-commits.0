From: akpm@linux-foundation.org
Subject: + uapi-mqueueh-add-missing-linux-typesh-include.patch added to
 -mm tree
Date: Thu, 19 Jan 2017 11:56:06 -0800
Message-ID: <588119d6.tDE8g5QADFtUsb3l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54520 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932065AbdASUDc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 15:03:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@chromium.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: uapi: mqueue.h: add missing linux/types.h include
has been added to the -mm tree.  Its filename is
     uapi-mqueueh-add-missing-linux-typesh-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uapi-mqueueh-add-missing-linux-typesh-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uapi-mqueueh-add-missing-linux-typesh-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

uapi-mqueueh-add-missing-linux-typesh-include.patch

