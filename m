From: akpm@linux-foundation.org
Subject: + remove-cpu-hotplug-defines-for-__init-__initdata.patch added to -mm tree
Date: Mon, 14 May 2007 17:48:06 -0700
Message-ID: <200705150048.l4F0m6mr030403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945AbXEOAsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 20:48:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, rmk@arm.linux.org.uk


The patch titled
     Remove cpu hotplug defines for __INIT & __INITDATA
has been added to the -mm tree.  Its filename is
     remove-cpu-hotplug-defines-for-__init-__initdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove cpu hotplug defines for __INIT & __INITDATA
From: Prarit Bhargava <prarit@redhat.com>

After examining what was checked in and the code base I discovered that most
of 86c0baf123e474b6eb404798926ecf62b426bf3a wasn't necessary anymore....

So here's a patch that reverts the last part of that changeset:

Revert part of 86c0baf123e474b6eb404798926ecf62b426bf3a.

The kernel has moved forward to a state where the original change is not
necessary.  After porting forward, this final version of the patch was
applied and broke non-x86 architectures.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    7 +------
 1 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/init.h~remove-cpu-hotplug-defines-for-__init-__initdata include/linux/init.h
--- a/include/linux/init.h~remove-cpu-hotplug-defines-for-__init-__initdata
+++ a/include/linux/init.h
@@ -52,14 +52,9 @@
 #endif
 
 /* For assembly routines */
-#ifdef CONFIG_HOTPLUG_CPU
-#define __INIT		.section	".text","ax"
-#define __INITDATA	.section	".data","aw"
-#else
 #define __INIT		.section	".init.text","ax"
-#define __INITDATA	.section	".init.data","aw"
-#endif
 #define __FINIT		.previous
+#define __INITDATA	.section	".init.data","aw"
 
 #ifndef __ASSEMBLY__
 /*
_

Patches currently in -mm which might be from prarit@redhat.com are

remove-cpu-hotplug-defines-for-__init-__initdata.patch
