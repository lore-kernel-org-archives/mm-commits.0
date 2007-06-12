From: akpm@linux-foundation.org
Subject: + remove-unused-lock_cpu_hotplug_interruptible-definition.patch added to -mm tree
Date: Tue, 12 Jun 2007 14:26:02 -0700
Message-ID: <200706122126.l5CLQ2hC021504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbXFLV0L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 17:26:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ntl@pobox.com


The patch titled
     remove unused lock_cpu_hotplug_interruptible definition
has been added to the -mm tree.  Its filename is
     remove-unused-lock_cpu_hotplug_interruptible-definition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove unused lock_cpu_hotplug_interruptible definition
From: Nathan Lynch <ntl@pobox.com>

aa95387774039096c11803c04011f1aa42d85758 removed the implementation of
lock_cpu_hotplug_interruptible and all users of it.  This stub definition
for !CONFIG_HOTPLUG_CPU was left over -- kill it now.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    1 -
 1 files changed, 1 deletion(-)

diff -puN include/linux/cpu.h~remove-unused-lock_cpu_hotplug_interruptible-definition include/linux/cpu.h
--- a/include/linux/cpu.h~remove-unused-lock_cpu_hotplug_interruptible-definition
+++ a/include/linux/cpu.h
@@ -120,7 +120,6 @@ static inline void cpuhotplug_mutex_unlo
 
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
-#define lock_cpu_hotplug_interruptible() 0
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 #define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
 #define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
_

Patches currently in -mm which might be from ntl@pobox.com are

remove-unused-lock_cpu_hotplug_interruptible-definition.patch
