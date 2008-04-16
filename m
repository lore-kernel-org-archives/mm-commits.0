From: akpm@linux-foundation.org
Subject: - acpi-bus-check-once-more-for-an-empty-list-after-locking-it.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:22 -0700
Message-ID: <200804162255.m3GMtMBQ011110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbYDPW4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cebbert@redhat.com, lenb@kernel.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: bus: check once more for an empty list after locking it
has been removed from the -mm tree.  Its filename was
     acpi-bus-check-once-more-for-an-empty-list-after-locking-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

