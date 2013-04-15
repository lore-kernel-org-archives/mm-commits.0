From: akpm@linux-foundation.org
Subject: [merged] kernel-watchdogc-add-comments-to-explain-watchdog_disabled-variable.patch removed from -mm tree
Date: Mon, 15 Apr 2013 13:04:38 -0700
Message-ID: <20130415200438.DB28431C1BB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57472 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3DOUEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 16:04:40 -0400
Received: by mail-vc0-f202.google.com with SMTP id m16so504486vca.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 13:04:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anish198519851985@gmail.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: add comments to explain watchdog_disabled variable
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-add-comments-to-explain-watchdog_disabled-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: anish kumar <anish198519851985@gmail.com>
Subject: kernel/watchdog.c: add comments to explain watchdog_disabled variable

This watchdog_disabled flag is a bit cryptic.  However it's usefulness is
multifold.  Uses are:

1. Check if smpboot_register_percpu_thread function passed.
2. Makes sure that user enables and disables the watchdog in sequence
   i.e. enable watchdog->disable watchdog->enable watchdog
   Unlike enable watchdog->enable watchdog which is wrong.

[dzickus@redhat.com: small text cleanups]
Signed-off-by: anish kumar <anish198519851985@gmail.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/watchdog.c~kernel-watchdogc-add-comments-to-explain-watchdog_disabled-variable kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-add-comments-to-explain-watchdog_disabled-variable
+++ a/kernel/watchdog.c
@@ -521,6 +521,11 @@ int proc_dowatchdog(struct ctl_table *ta
 		return ret;
 
 	set_sample_period();
+	/*
+	 * Watchdog threads shouldn't be enabled if they are
+	 * disabled. The 'watchdog_disabled' variable check in
+	 * watchdog_*_all_cpus() function takes care of this.
+	 */
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
_

Patches currently in -mm which might be from anish198519851985@gmail.com are

linux-next.patch

