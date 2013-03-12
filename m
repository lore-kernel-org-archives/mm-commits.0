From: akpm@linux-foundation.org
Subject: + kernel-watchdogc-add-comments-to-explain-watchdog_disabled-variable.patch added to -mm tree
Date: Tue, 12 Mar 2013 12:56:08 -0700
Message-ID: <20130312195608.6FDC631C230@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:54273 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab3CLT4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 15:56:09 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so27932qea.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 12:56:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anish198519851985@gmail.com, dzickus@redhat.com


The patch titled
     Subject: kernel/watchdog.c: add comments to explain watchdog_disabled variable
has been added to the -mm tree.  Its filename is
     kernel-watchdogc-add-comments-to-explain-watchdog_disabled-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-watchdogc-add-comments-to-explain-watchdog_disabled-variable.patch

