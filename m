From: akpm@linux-foundation.org
Subject: + mutex-make-mutex_destroy-an-inline-function.patch added to -mm tree
Date: Mon, 18 Jul 2011 14:10:30 -0700
Message-ID: <201107182110.p6ILAUeh028083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073Ab1GRVKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 17:10:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, mingo@elte.hu


The patch titled
     mutex: make mutex_destroy() an inline function
has been added to the -mm tree.  Its filename is
     mutex-make-mutex_destroy-an-inline-function.patch

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
mutex-make-mutex_destroy-an-inline-function.patch

