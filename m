From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:11 -0800
Message-ID: <52e2b7ff.VNFL+7/7Q6NmHtjn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shawn.guo@linaro.org

Subject: [merged] include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch removed from -mm tree
To: shawn.guo@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:11 -0800


The patch titled
     Subject: include/linux/genalloc.h: spinlock_t needs spinlock_types.h
has been removed from the -mm tree.  Its filename was
     include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shawn Guo <shawn.guo@linaro.org>
Subject: include/linux/genalloc.h: spinlock_t needs spinlock_types.h

Compiling a C file which includes genalloc.h but without spinlock_types.h
being included before, we will see the compile error below.

 include/linux/genalloc.h:54:2: error: unknown type name `spinlock_t'

Include spinlock_types.h from genalloc.h to fix the problem.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/genalloc.h~include-linux-genalloch-spinlock_t-needs-spinlock_typesh include/linux/genalloc.h
--- a/include/linux/genalloc.h~include-linux-genalloch-spinlock_t-needs-spinlock_typesh
+++ a/include/linux/genalloc.h
@@ -30,6 +30,8 @@
 #ifndef __GENALLOC_H__
 #define __GENALLOC_H__
 
+#include <linux/spinlock_types.h>
+
 struct device;
 struct device_node;
 
_

Patches currently in -mm which might be from shawn.guo@linaro.org are

origin.patch
linux-next.patch

