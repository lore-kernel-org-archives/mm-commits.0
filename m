From: akpm@linux-foundation.org
Subject: [merged] fanotify-fix-event-filtering-with-fan_ondir-set.patch
 removed from -mm tree
Date: Mon, 16 Mar 2015 11:02:48 -0700
Message-ID: <55071ac8.pOX4FqImX8ZCmysz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbbCPSCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki.poulose@arm.com, LinoSanfilippo@gmx.de, eparis@redhat.com, jack@suse.cz, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: fix event filtering with FAN_ONDIR set
has been removed from the -mm tree.  Its filename was
     fanotify-fix-event-filtering-with-fan_ondir-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: fanotify: fix event filtering with FAN_ONDIR set

With FAN_ONDIR set, the user can end up getting events, which it hasn't
marked.  This was revealed with fanotify04 testcase failure on
Linux-4.0-rc1, and is a regression from 3.19, revealed with 66ba93c0d7fe6
("fanotify: don't set FAN_ONDIR implicitly on a marks ignored mask").

 # /opt/ltp/testcases/bin/fanotify04
 [ ... ]
fanotify04    7  TPASS  :  event generated properly for type 100000
fanotify04    8  TFAIL  :  fanotify04.c:147: got unexpected event 30
fanotify04    9  TPASS  :  No event as expected

The testcase sets the adds the following marks : FAN_OPEN | FAN_ONDIR for
a fanotify on a dir.  Then does an open(), followed by close() of the
directory and expects to see an event FAN_OPEN(0x20).  However, the
fanotify returns (FAN_OPEN|FAN_CLOSE_NOWRITE(0x10)).  This happens due to
the flaw in the check for event_mask in fanotify_should_send_event() which
does:

	if (event_mask & marks_mask & ~marks_ignored_mask)
		return true;

where, event_mask == (FAN_ONDIR | FAN_CLOSE_NOWRITE),
       marks_mask == (FAN_ONDIR | FAN_OPEN),
       marks_ignored_mask == 0

Fix this by masking the outgoing events to the user, as we already take
care of FAN_ONDIR and FAN_EVENT_ON_CHILD.

Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Tested-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/notify/fanotify/fanotify.c~fanotify-fix-event-filtering-with-fan_ondir-set fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fanotify-fix-event-filtering-with-fan_ondir-set
+++ a/fs/notify/fanotify/fanotify.c
@@ -143,7 +143,8 @@ static bool fanotify_should_send_event(s
 	    !(marks_mask & FS_ISDIR & ~marks_ignored_mask))
 		return false;
 
-	if (event_mask & marks_mask & ~marks_ignored_mask)
+	if (event_mask & FAN_ALL_OUTGOING_EVENTS & marks_mask &
+				 ~marks_ignored_mask)
 		return true;
 
 	return false;
_

Patches currently in -mm which might be from suzuki.poulose@arm.com are

linux-next.patch

