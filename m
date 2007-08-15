From: akpm@linux-foundation.org
Subject: + uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch added to -mm tree
Date: Wed, 15 Aug 2007 13:58:22 -0700
Message-ID: <200708152058.l7FKwMA4014658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654AbXHOU6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net


The patch titled
     uvesafb: always use mutexes when accessing uvfb_tasks
has been added to the -mm tree.  Its filename is
     uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uvesafb: always use mutexes when accessing uvfb_tasks
From: Michal Januszewski <spock@gentoo.org>

Accesses to the uvfb_tasks array should be always be protected by a mutex to
avoid race conditions.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/video/uvesafb.c~uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks
+++ a/drivers/video/uvesafb.c
@@ -208,6 +208,10 @@ static int uvesafb_exec(struct uvesafb_k
 		err = !wait_for_completion_timeout(task->done,
 				msecs_to_jiffies(UVESAFB_TIMEOUT));
 
+	mutex_lock(&uvfb_lock);
+	uvfb_tasks[seq] = NULL;
+	mutex_unlock(&uvfb_lock);
+
 	seq++;
 	if (seq >= UVESAFB_TASKS_MAX)
 		seq = 0;
_

Patches currently in -mm which might be from spock@gentoo.org are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
