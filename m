From: akpm@linux-foundation.org
Subject: [merged] include-uapi-linux-ppp-ioctlh-pull-in-ppp_defsh.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:41 -0800
Message-ID: <52e2b859.KAvtuO9SUS660ty7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, davem@davemloft.net, vapier@gentoo.org

Subject: [merged] include-uapi-linux-ppp-ioctlh-pull-in-ppp_defsh.patch removed from -mm tree
To: vapier@gentoo.org,davem@davemloft.net,paulus@samba.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:41 -0800


The patch titled
     Subject: include/uapi/linux/ppp-ioctl.h: pull in ppp_defs.h
has been removed from the -mm tree.  Its filename was
     include-uapi-linux-ppp-ioctlh-pull-in-ppp_defsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Frysinger <vapier@gentoo.org>
Subject: include/uapi/linux/ppp-ioctl.h: pull in ppp_defs.h

This header uses enum NPmode but doesn't include ppp_defs.h.  If you try
to use this header w/out including the defs header first, it leads to a
build failure.  So add the explicit include to fix it.

Don't know of any packages directly impacted, but noticed while building
some ppp code by hand.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/ppp-ioctl.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/uapi/linux/ppp-ioctl.h~include-uapi-linux-ppp-ioctlh-pull-in-ppp_defsh include/uapi/linux/ppp-ioctl.h
--- a/include/uapi/linux/ppp-ioctl.h~include-uapi-linux-ppp-ioctlh-pull-in-ppp_defsh
+++ a/include/uapi/linux/ppp-ioctl.h
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/ppp_defs.h>
 
 /*
  * Bit definitions for flags argument to PPPIOCGFLAGS/PPPIOCSFLAGS.
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
linux-next.patch

