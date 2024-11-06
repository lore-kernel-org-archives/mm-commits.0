Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4B316FF45
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855622; cv=none; b=mWOGC5GHs2XoENfgmmWCJ263+5/YDjuXeRoWampjtaGdYrWwYU5ucVyzrpihranAqMm0/tr5DbRt8QnMilE3id+trhJ3Pel9I8JdDgWPm9c8qPCXGthBqXJX5cYkgTeGZayeZQpCdOEqghG9CloV40dSJMkX9clYEZLBLHtbyME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855622; c=relaxed/simple;
	bh=HNpf0qBP5Uzv2vRFKvpCh5G/BcVzRvYIjiBO/qwPmNU=;
	h=Date:To:From:Subject:Message-Id; b=QrRyKDT+FNW9u4Q+/c64nOzLDMG5myp549NxV88LhxHhS2gmVwsIX+lZlTJrnNKQJOEI3QqJjQ5r5Zt9Ahre61X/cELh1rAdxX4wOvMz0h1deEQl05MIdDGH0cGIUsjr+s9s/wVcP6wpbqKM+KqtbKcsDGn8IO9r9r/f7LOEt1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pMsGoPve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pMsGoPve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438DBC4CECF;
	Wed,  6 Nov 2024 01:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855622;
	bh=HNpf0qBP5Uzv2vRFKvpCh5G/BcVzRvYIjiBO/qwPmNU=;
	h=Date:To:From:Subject:From;
	b=pMsGoPveIe0/M8OGpZlYVRsP0ndkZQK2eYL2cj1KTFRNXTLjdGi6iqQ71LLwbRtfb
	 t635AYi0tL0KlsSH5H5qAV3FS3u0dirAsEPGWixjB3eOuI9CIqnGZUrU3B0yWJGQly
	 xMvqz9FewXdqFNkhGLjF0gcyGYPhAa7bYqXxb/vg=
Date: Tue, 05 Nov 2024 17:13:41 -0800
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] reboot-move-reboot_notifier_list-to-kernel-rebootc.patch removed from -mm tree
Message-Id: <20241106011342.438DBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: reboot: move reboot_notifier_list to kernel/reboot.c
has been removed from the -mm tree.  Its filename was
     reboot-move-reboot_notifier_list-to-kernel-rebootc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: reboot: move reboot_notifier_list to kernel/reboot.c
Date: Sat, 12 Oct 2024 19:52:53 +0200

All the functions related to the reboot notifier list are in
kernel/reboot.c.  Move the list itself, too.  As there are no direct users
anymore, make the declaration static.

Link: https://lkml.kernel.org/r/20241012-reboot_notifier_list-v1-1-6093bb9455ce@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/notifier.h |    2 --
 kernel/notifier.c        |    8 --------
 kernel/reboot.c          |    7 +++++++
 3 files changed, 7 insertions(+), 10 deletions(-)

--- a/include/linux/notifier.h~reboot-move-reboot_notifier_list-to-kernel-rebootc
+++ a/include/linux/notifier.h
@@ -237,7 +237,5 @@ static inline int notifier_to_errno(int
 #define KBD_KEYSYM		0x0004 /* Keyboard keysym */
 #define KBD_POST_KEYSYM		0x0005 /* Called after keyboard keysym interpretation */
 
-extern struct blocking_notifier_head reboot_notifier_list;
-
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
--- a/kernel/notifier.c~reboot-move-reboot_notifier_list-to-kernel-rebootc
+++ a/kernel/notifier.c
@@ -5,19 +5,11 @@
 #include <linux/notifier.h>
 #include <linux/rcupdate.h>
 #include <linux/vmalloc.h>
-#include <linux/reboot.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/notifier.h>
 
 /*
- *	Notifier list for kernel code which wants to be called
- *	at shutdown. This is used to stop any idling DMA operations
- *	and the like.
- */
-BLOCKING_NOTIFIER_HEAD(reboot_notifier_list);
-
-/*
  *	Notifier chain core routines.  The exported routines below
  *	are layered on top of these, with appropriate locking added.
  */
--- a/kernel/reboot.c~reboot-move-reboot_notifier_list-to-kernel-rebootc
+++ a/kernel/reboot.c
@@ -72,6 +72,13 @@ static bool poweroff_fallback_to_halt;
  */
 void __weak (*pm_power_off)(void);
 
+/*
+ *	Notifier list for kernel code which wants to be called
+ *	at shutdown. This is used to stop any idling DMA operations
+ *	and the like.
+ */
+static BLOCKING_NOTIFIER_HEAD(reboot_notifier_list);
+
 /**
  *	emergency_restart - reboot the system
  *
_

Patches currently in -mm which might be from linux@weissschuh.net are


