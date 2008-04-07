From: akpm@linux-foundation.org
Subject: + acpi-bus-check-once-more-for-an-empty-list-after-locking-it.patch added to -mm tree
Date: Mon, 07 Apr 2008 12:13:31 -0700
Message-ID: <200804071913.m37JDVi6021026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbYDGTOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 15:14:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cebbert@redhat.com, lenb@kernel.org, stable@kernel.org


The patch titled
     acpi: bus: check once more for an empty list after locking it
has been added to the -mm tree.  Its filename is
     acpi-bus-check-once-more-for-an-empty-list-after-locking-it.patch

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
Subject: acpi: bus: check once more for an empty list after locking it
From: Chuck Ebbert <cebbert@redhat.com>

List could have become empty after the unlocked check that was made earlier,
so check again inside the lock.

Should fix https://bugzilla.redhat.com/show_bug.cgi?id=427765

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: <stable@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bus.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/bus.c~acpi-bus-check-once-more-for-an-empty-list-after-locking-it drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~acpi-bus-check-once-more-for-an-empty-list-after-locking-it
+++ a/drivers/acpi/bus.c
@@ -373,10 +373,11 @@ int acpi_bus_receive_event(struct acpi_b
 	}
 
 	spin_lock_irqsave(&acpi_bus_event_lock, flags);
-	entry =
-	    list_entry(acpi_bus_event_list.next, struct acpi_bus_event, node);
-	if (entry)
+	if (!list_empty(&acpi_bus_event_list)) {
+		entry = list_entry(acpi_bus_event_list.next,
+				   struct acpi_bus_event, node);
 		list_del(&entry->node);
+	}
 	spin_unlock_irqrestore(&acpi_bus_event_lock, flags);
 
 	if (!entry)
_

Patches currently in -mm which might be from cebbert@redhat.com are

acpi-bus-check-once-more-for-an-empty-list-after-locking-it.patch

