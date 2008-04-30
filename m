From: akpm@linux-foundation.org
Subject: - ipmi-dont-print-event-queue-full-on-every-event.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:37 -0700
Message-ID: <200804300544.m3U5ibxe029428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758808AbYD3Ftq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: don't print event queue full on every event
has been removed from the -mm tree.  Its filename was
     ipmi-dont-print-event-queue-full-on-every-event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: don't print event queue full on every event
From: Corey Minyard <cminyard@mvista.com>

Don't print out that the event queue is full on every event, only
print something out when it becomes full or becomes not full.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-dont-print-event-queue-full-on-every-event drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-dont-print-event-queue-full-on-every-event
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -253,7 +253,8 @@ struct ipmi_smi
 	spinlock_t       events_lock; /* For dealing with event stuff. */
 	struct list_head waiting_events;
 	unsigned int     waiting_events_count; /* How many events in queue? */
-	int              delivering_events;
+	char             delivering_events;
+	char             event_msg_printed;
 
 	/* The event receiver for my BMC, only really used at panic
 	   shutdown as a place to store this. */
@@ -1083,6 +1084,11 @@ int ipmi_set_gets_events(ipmi_user_t use
 		list_for_each_entry_safe(msg, msg2, &intf->waiting_events, link)
 			list_move_tail(&msg->link, &msgs);
 		intf->waiting_events_count = 0;
+		if (intf->event_msg_printed) {
+			printk(KERN_WARNING PFX "Event queue no longer"
+			       " full\n");
+			intf->event_msg_printed = 0;
+		}
 
 		intf->delivering_events = 1;
 		spin_unlock_irqrestore(&intf->events_lock, flags);
@@ -3261,11 +3267,12 @@ static int handle_read_event_rsp(ipmi_sm
 		copy_event_into_recv_msg(recv_msg, msg);
 		list_add_tail(&(recv_msg->link), &(intf->waiting_events));
 		intf->waiting_events_count++;
-	} else {
+	} else if (!intf->event_msg_printed) {
 		/* There's too many things in the queue, discard this
 		   message. */
-		printk(KERN_WARNING PFX "Event queue full, discarding an"
-		       " incoming event\n");
+		printk(KERN_WARNING PFX "Event queue full, discarding"
+		       " incoming events\n");
+		intf->event_msg_printed = 1;
 	}
 
  out:
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

