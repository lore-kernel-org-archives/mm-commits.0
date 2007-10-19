From: akpm@linux-foundation.org
Subject: - ipmi-fix-hotmod-remove-lock.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:22 -0700
Message-ID: <200710190346.l9J3kMew013325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764046AbXJSDzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: fix hotmod remove lock
has been removed from the -mm tree.  Its filename was
     ipmi-fix-hotmod-remove-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: fix hotmod remove lock
From: Corey Minyard <cminyard@mvista.com>

The removal of proc entries was done holding a lock, which is no longer
allowed.  There is no need for the lock, only a mutex is required, so switch
over to a mutex.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-hotmod-remove-lock drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-hotmod-remove-lock
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -221,10 +221,8 @@ struct ipmi_smi
 	void                     *send_info;
 
 #ifdef CONFIG_PROC_FS
-	/* A list of proc entries for this interface.  This does not
-	   need a lock, only one thread creates it and only one thread
-	   destroys it. */
-	spinlock_t             proc_entry_lock;
+	/* A list of proc entries for this interface. */
+	struct mutex           proc_entry_lock;
 	struct ipmi_proc_entry *proc_entries;
 #endif
 
@@ -1891,11 +1889,11 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t s
 		file->write_proc = write_proc;
 		file->owner = owner;
 
-		spin_lock(&smi->proc_entry_lock);
+		mutex_lock(&smi->proc_entry_lock);
 		/* Stick it on the list. */
 		entry->next = smi->proc_entries;
 		smi->proc_entries = entry;
-		spin_unlock(&smi->proc_entry_lock);
+		mutex_unlock(&smi->proc_entry_lock);
 	}
 #endif /* CONFIG_PROC_FS */
 
@@ -1939,7 +1937,7 @@ static void remove_proc_entries(ipmi_smi
 #ifdef CONFIG_PROC_FS
 	struct ipmi_proc_entry *entry;
 
-	spin_lock(&smi->proc_entry_lock);
+	mutex_lock(&smi->proc_entry_lock);
 	while (smi->proc_entries) {
 		entry = smi->proc_entries;
 		smi->proc_entries = entry->next;
@@ -1948,7 +1946,7 @@ static void remove_proc_entries(ipmi_smi
 		kfree(entry->name);
 		kfree(entry);
 	}
-	spin_unlock(&smi->proc_entry_lock);
+	mutex_unlock(&smi->proc_entry_lock);
 	remove_proc_entry(smi->proc_dir_name, proc_ipmi_root);
 #endif /* CONFIG_PROC_FS */
 }
@@ -2679,7 +2677,7 @@ int ipmi_register_smi(struct ipmi_smi_ha
 	}
 	intf->curr_seq = 0;
 #ifdef CONFIG_PROC_FS
-	spin_lock_init(&intf->proc_entry_lock);
+	mutex_init(&intf->proc_entry_lock);
 #endif
 	spin_lock_init(&intf->waiting_msgs_lock);
 	INIT_LIST_HEAD(&intf->waiting_msgs);
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch
