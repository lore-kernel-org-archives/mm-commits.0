From: akpm@linux-foundation.org
Subject: [patch 03/15] ima: permit duplicate measurement list entries
Date: Mon, 19 Dec 2016 16:22:38 -0800
Message-ID: <585879ce.RKIfAPfVO7DESW0Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753970AbcLTAVj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 19:21:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zohar@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, dmitry.kasatkin@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, mpe@ellerman.id.au, paulus@samba.org, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, vgoyal@redhat.com

From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima: permit duplicate measurement list entries

Measurements carried across kexec need to be added to the IMA measurement
list, but should not prevent measurements of the newly booted kernel from
being added to the measurement list.  This patch adds support for allowing
duplicate measurements.

The "boot_aggregate" measurement entry is the delimiter between soft
boots.

Link: http://lkml.kernel.org/r/1480554346-29071-4-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Acked-by: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
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
