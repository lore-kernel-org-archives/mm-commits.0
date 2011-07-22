From: akpm@linux-foundation.org
Subject: [merged] mutex-make-mutex_destroy-an-inline-function.patch removed from -mm tree
Date: Fri, 22 Jul 2011 11:45:02 -0700
Message-ID: <201107221844.p6MIijo0004651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877Ab1GVSpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 14:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mutex: make mutex_destroy() an inline function
has been removed from the -mm tree.  Its filename was
     mutex-make-mutex_destroy-an-inline-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mutex: make mutex_destroy() an inline function
From: Jean Delvare <khali@linux-fr.org>

The non-debug variant of mutex_destroy() is a no-op, currently implemented
as a macro which does nothing.  This approach fails to check the type of
the parameter, so an error would only show when debugging gets enabled. 
Using an inline function instead, offers type checking for earlier bug
catching.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mutex.h~mutex-make-mutex_destroy-an-inline-function include/linux/mutex.h
--- a/include/linux/mutex.h~mutex-make-mutex_destroy-an-inline-function
+++ a/include/linux/mutex.h
@@ -92,7 +92,7 @@ do {							\
 							\
 	__mutex_init((mutex), #mutex, &__key);		\
 } while (0)
-# define mutex_destroy(mutex)				do { } while (0)
+static inline void mutex_destroy(struct mutex *lock) {}
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
thermal-hide-config_thermal_hwmon.patch
thermal-split-hwmon-lookup-to-a-separate-function.patch
thermal-make-thermal_hwmon-implementation-fully-internal.patch
drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch

