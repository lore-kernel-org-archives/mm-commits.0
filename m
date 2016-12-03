From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ima-permit-duplicate-measurement-list-entries.patch removed from -mm tree
Date: Fri, 02 Dec 2016 17:13:43 -0800
Message-ID: <58421c47.Zz8cjfs0sFzveAe9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34006 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932360AbcLCBNX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 20:13:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dmitry.kasatkin@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: permit duplicate measurement list entries
has been removed from the -mm tree.  Its filename was
     ima-permit-duplicate-measurement-list-entries.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima: permit duplicate measurement list entries

Measurements carried across kexec need to be added to the IMA
measurement list, but should not prevent measurements of the newly
booted kernel from being added to the measurement list. This patch
adds support for allowing duplicate measurements.

The "boot_aggregate" measurement entry is the delimiter between soft
boots.

Link: http://lkml.kernel.org/r/1478789780-17719-4-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Acked-by: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_queue.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN security/integrity/ima/ima_queue.c~ima-permit-duplicate-measurement-list-entries security/integrity/ima/ima_queue.c
--- a/security/integrity/ima/ima_queue.c~ima-permit-duplicate-measurement-list-entries
+++ a/security/integrity/ima/ima_queue.c
@@ -65,11 +65,13 @@ static struct ima_queue_entry *ima_looku
 }
 
 /* ima_add_template_entry helper function:
- * - Add template entry to measurement list and hash table.
+ * - Add template entry to the measurement list and hash table, for
+ *   all entries except those carried across kexec.
  *
  * (Called with ima_extend_list_mutex held.)
  */
-static int ima_add_digest_entry(struct ima_template_entry *entry)
+static int ima_add_digest_entry(struct ima_template_entry *entry,
+				bool update_htable)
 {
 	struct ima_queue_entry *qe;
 	unsigned int key;
@@ -85,8 +87,10 @@ static int ima_add_digest_entry(struct i
 	list_add_tail_rcu(&qe->later, &ima_measurements);
 
 	atomic_long_inc(&ima_htable.len);
-	key = ima_hash_key(entry->digest);
-	hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
+	if (update_htable) {
+		key = ima_hash_key(entry->digest);
+		hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
+	}
 	return 0;
 }
 
@@ -126,7 +130,7 @@ int ima_add_template_entry(struct ima_te
 		}
 	}
 
-	result = ima_add_digest_entry(entry);
+	result = ima_add_digest_entry(entry, 1);
 	if (result < 0) {
 		audit_cause = "ENOMEM";
 		audit_info = 0;
@@ -155,7 +159,7 @@ int ima_restore_measurement_entry(struct
 	int result = 0;
 
 	mutex_lock(&ima_extend_list_mutex);
-	result = ima_add_digest_entry(entry);
+	result = ima_add_digest_entry(entry, 0);
 	mutex_unlock(&ima_extend_list_mutex);
 	return result;
 }
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch
ima-on-soft-reboot-save-the-measurement-list.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch

