Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0C02564
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728770379; cv=none; b=GAKHGSHFVJm74be4MjbgKZjTmkmNDTSobK1/gOEbIFpF7Zns4Nmh4aCtx5HUTggPZMtER6dR48SHspK0HOxvJeEMKrdk8rfzqxIKxWJWNNMwHHqNLBfslTSH41+1TwuVmSLHAFJBqAd7ekrqBwCQqKzV82xtJ0y2iWIWFsTrFKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728770379; c=relaxed/simple;
	bh=+fTRvmXey0QchNuuuXMNvPuRkWXE/hjAWfkm3BFz2mM=;
	h=Date:To:From:Subject:Message-Id; b=kmsZZMPRXA21bD2Y203ZCSHoGitrMLxa3e0o7FppmuePgo+Lz189qf98Ek+M30Pyb9bNdeIJx1Bic6SGk2kPhnbB/TQhlzqaU5G7IgfTnlFqioAI5SY3JV+MTxOjVuQmJKnl7u+szxJbfTjcssUCPZYtdwLGQxyiNugUunrdLOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ThZD979f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ThZD979f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849D0C4CEC6;
	Sat, 12 Oct 2024 21:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728770378;
	bh=+fTRvmXey0QchNuuuXMNvPuRkWXE/hjAWfkm3BFz2mM=;
	h=Date:To:From:Subject:From;
	b=ThZD979fd7ZC5Iuvlpj84P2pkL7Ihg4TChmrc7aBoYi9d+N95kyHLQJKliftf3huf
	 QjTgJWq6dAvAPPbFdVx9kimrLBzN3FfVT2sn6xAaHNK5OAQ8jjx3657WmNXF5JO5wh
	 0CX+GCZjl+chnvgK78png5gKOAaMCog1Kwoaa2qg=
Date: Sat, 12 Oct 2024 14:59:37 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + reboot-move-reboot_notifier_list-to-kernel-rebootc.patch added to mm-nonmm-unstable branch
Message-Id: <20241012215938.849D0C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: reboot: move reboot_notifier_list to kernel/reboot.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     reboot-move-reboot_notifier_list-to-kernel-rebootc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/reboot-move-reboot_notifier_list-to-kernel-rebootc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

reboot-move-reboot_notifier_list-to-kernel-rebootc.patch

