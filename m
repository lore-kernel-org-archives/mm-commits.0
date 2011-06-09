From: akpm@linux-foundation.org
Subject: - kmsg_dumph-needs-errnoh.patch removed from -mm tree
Date: Thu, 09 Jun 2011 14:42:22 -0700
Message-ID: <201106092142.p59LgN8b001690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756397Ab1FIVnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 17:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, David.Woodhouse@intel.com, kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au, simon.kagstrom@netinsight.net, mm-commits@vger.kernel.org


The patch titled
     kmsg_dump.h: needs errno.h
has been removed from the -mm tree.  Its filename was
     kmsg_dumph-needs-errnoh.patch

This patch was dropped because it's a dupe

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmsg_dump.h: needs errno.h
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix <linux/kmsg_dump.h> when CONFIG_PRINTK is not enabled:

include/linux/kmsg_dump.h:56: error: 'EINVAL' undeclared (first use in this function)
include/linux/kmsg_dump.h:61: error: 'EINVAL' undeclared (first use in this function)

Looks like previous commit:
commit 595dd3d8bf953254d8d2f30f99c54fe09c470040
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Tue Dec 1 10:52:02 2009 -0800

    kmsg_dump: fix build for CONFIG_PRINTK=n

uses EINVAL without having the needed header file(s),
but I'm sure that I build tested that patch also.  oh well.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsg_dump.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/kmsg_dump.h~kmsg_dumph-needs-errnoh include/linux/kmsg_dump.h
--- a/include/linux/kmsg_dump.h~kmsg_dumph-needs-errnoh
+++ a/include/linux/kmsg_dump.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_KMSG_DUMP_H
 #define _LINUX_KMSG_DUMP_H
 
+#include <linux/errno.h>
 #include <linux/list.h>
 
 enum kmsg_dump_reason {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-memoryc-fix-kernel-doc-notation.patch
lib-bitmapc-fix-kernel-doc-notation.patch
kmsg_dumph-fix-build-when-config_printk-is-disabled.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

