From: akpm@linux-foundation.org
Subject: + kmsg_dumph-fix-build-when-config_printk-is-disabled.patch added to -mm tree
Date: Wed, 01 Jun 2011 16:45:58 -0700
Message-ID: <201106012345.p51Njwvu016868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758965Ab1FAXqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 19:46:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kmsg_dump.h: fix build when CONFIG_PRINTK is disabled
has been added to the -mm tree.  Its filename is
     kmsg_dumph-fix-build-when-config_printk-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmsg_dump.h: fix build when CONFIG_PRINTK is disabled
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix <linux/kmsg_dump.h> when CONFIG_PRINTK is not enabled:

include/linux/kmsg_dump.h:56: error: 'EINVAL' undeclared (first use in this function)
include/linux/kmsg_dump.h:61: error: 'EINVAL' undeclared (first use in this function)

Looks like previous commit:
commit 595dd3d8bf953254d8d2f30f99c54fe09c470040
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Tue Dec 1 10:52:02 2009 -0800

    kmsg_dump: fix build for CONFIG_PRINTK=n

uses EINVAL without having the needed header file(s), but I'm sure that I
build tested that patch also.  oh well.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsg_dump.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/kmsg_dump.h~kmsg_dumph-fix-build-when-config_printk-is-disabled include/linux/kmsg_dump.h
--- a/include/linux/kmsg_dump.h~kmsg_dumph-fix-build-when-config_printk-is-disabled
+++ a/include/linux/kmsg_dump.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_KMSG_DUMP_H
 #define _LINUX_KMSG_DUMP_H
 
+#include <linux/errno.h>
 #include <linux/list.h>
 
 enum kmsg_dump_reason {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
mm-memoryc-fix-kernel-doc-notation.patch
lib-bitmapc-fix-kernel-doc-notation.patch
kmsg_dumph-fix-build-when-config_printk-is-disabled.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

