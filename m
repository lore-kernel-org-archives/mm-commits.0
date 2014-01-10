From: akpm@linux-foundation.org
Subject: + include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch
 added to -mm tree
Date: Fri, 10 Jan 2014 15:04:06 -0800
Message-ID: <52d07c66.w8TGkYjsnU64J0ai%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaAJXEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 18:04:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shawn.guo@linaro.org

Subject: + include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch added to -mm tree
To: shawn.guo@linaro.org
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 15:04:06 -0800


The patch titled
     Subject: include/linux/genalloc.h: spinlock_t needs spinlock_types.h
has been added to the -mm tree.  Its filename is
     include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-linux-genalloch-spinlock_t-needs-spinlock_typesh.patch
linux-next.patch

