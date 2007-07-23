From: akpm@linux-foundation.org
Subject: - documentationreference-notifierstxt-in-freezing-of-taskstxt.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:24 -0700
Message-ID: <200707230934.l6N9YOOd016396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759476AbXGWJpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oliver@neukum.org, nigel@nigel.suspend2.net, oneukum@suse.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Documentation:reference notifiers.txt in freezing-of-tasks.txt
has been removed from the -mm tree.  Its filename was
     documentationreference-notifierstxt-in-freezing-of-taskstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation:reference notifiers.txt in freezing-of-tasks.txt
From: Oliver Neukum <oliver@neukum.org>

freezing-of-tasks.txt mentions firmware issues without mentioning the use
of the new notifier API to overcome them.  Here's an update.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/freezing-of-tasks.txt |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN Documentation/power/freezing-of-tasks.txt~documentationreference-notifierstxt-in-freezing-of-taskstxt Documentation/power/freezing-of-tasks.txt
--- a/Documentation/power/freezing-of-tasks.txt~documentationreference-notifierstxt-in-freezing-of-taskstxt
+++ a/Documentation/power/freezing-of-tasks.txt
@@ -155,6 +155,8 @@ Suppose, however, that the firmware file
 only through another device that hasn't been resumed yet.  In that case,
 request_firmware() will fail regardless of whether or not the freezing of tasks
 is used.  Consequently, the problem is not really related to the freezing of
-tasks, since it generally exists anyway.  [The solution to this particular
-problem is to keep the firmware in memory after it's loaded for the first time
-and upload if from memory to the device whenever necessary.]
+tasks, since it generally exists anyway.
+
+A driver must have all firmwares it may need in RAM before suspend() is called.
+If keeping them is not practical, for example due to their size, they must be
+requested early enough using the suspend notifier API described in notifiers.txt.
_

Patches currently in -mm which might be from oliver@neukum.org are

nikon-d50-is-an-unusual-device.patch
