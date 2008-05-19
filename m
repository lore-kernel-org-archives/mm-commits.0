From: akpm@linux-foundation.org
Subject: + md-notify-userspace-on-stop-events.patch added to -mm tree
Date: Sun, 18 May 2008 18:27:37 -0700
Message-ID: <200805190127.m4J1RblO009567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbYESB1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 May 2008 21:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, neilb@suse.de


The patch titled
     md: notify userspace on 'stop' events
has been added to the -mm tree.  Its filename is
     md-notify-userspace-on-stop-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: notify userspace on 'stop' events
From: Dan Williams <dan.j.williams@intel.com>

This additional notification to 'array_state' is needed to allow the
monitor application to learn about stop events via sysfs.  The
sysfs_notify("sync_action") call that comes at the end of do_md_stop()
(via md_new_event) is insufficient since the 'sync_action' attribute has
been removed by this point.

(Seems like a sysfs-notify-on-removal patch is a better fix.  Currently
removal updates the event count but does not wake up waiters)

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/md/md.c~md-notify-userspace-on-stop-events drivers/md/md.c
--- a/drivers/md/md.c~md-notify-userspace-on-stop-events
+++ a/drivers/md/md.c
@@ -3691,6 +3691,8 @@ static int do_md_stop(mddev_t * mddev, i
 
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
+			/* tell userspace to handle 'inactive' */
+			sysfs_notify(&mddev->kobj, NULL, "array_state");
 
 			set_capacity(disk, 0);
 			mddev->changed = 1;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
linux-next.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
md-md-raid5-rate-limit-error-printk.patch
md-notify-userspace-on-stop-events.patch

