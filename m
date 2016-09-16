From: akpm@linux-foundation.org
Subject: + ima-permit-duplicate-measurement-list-entries.patch added to
 -mm tree
Date: Fri, 16 Sep 2016 16:22:26 -0700
Message-ID: <57dc7eb2.Xisz0b0a6EOD6/M2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59127 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754570AbcIPXW1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 19:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: permit duplicate measurement list entries
has been added to the -mm tree.  Its filename is
     ima-permit-duplicate-measurement-list-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-permit-duplicate-measurement-list-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-permit-duplicate-measurement-list-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima: permit duplicate measurement list entries

Measurements carried across kexec need to be added to the IMA measurement
list, but should not prevent measurements of the newly booted kernel from
being added to the measurement list.  This patch adds support for allowing
duplicate measurements.

The "boot_aggregate" measurement entry is the delimiter between soft
boots.

Link: http://lkml.kernel.org/r/1473938771-2782-3-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Richter <erichte@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_queue.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN security/integrity/ima/ima_queue.c~ima-permit-duplicate-measurement-list-entries security/integrity/ima/ima_queue.c
--- a/security/integrity/ima/ima_queue.c~ima-permit-duplicate-measurement-list-entries
+++ a/security/integrity/ima/ima_queue.c
@@ -65,11 +65,12 @@ static struct ima_queue_entry *ima_looku
 }
 
 /* ima_add_template_entry helper function:
- * - Add template entry to measurement list and hash table.
+ * - Add template entry to the measurement list and hash table, for
+ *   all entries except those carried across kexec.
  *
  * (Called with ima_extend_list_mutex held.)
  */
-static int ima_add_digest_entry(struct ima_template_entry *entry)
+static int ima_add_digest_entry(struct ima_template_entry *entry, int flags)
 {
 	struct ima_queue_entry *qe;
 	unsigned int key;
@@ -85,8 +86,10 @@ static int ima_add_digest_entry(struct i
 	list_add_tail_rcu(&qe->later, &ima_measurements);
 
 	atomic_long_inc(&ima_htable.len);
-	key = ima_hash_key(entry->digest);
-	hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
+	if (flags) {
+		key = ima_hash_key(entry->digest);
+		hlist_add_head_rcu(&qe->hnext, &ima_htable.queue[key]);
+	}
 	return 0;
 }
 
@@ -126,7 +129,7 @@ int ima_add_template_entry(struct ima_te
 		}
 	}
 
-	result = ima_add_digest_entry(entry);
+	result = ima_add_digest_entry(entry, 1);
 	if (result < 0) {
 		audit_cause = "ENOMEM";
 		audit_info = 0;
@@ -155,7 +158,7 @@ int ima_restore_measurement_entry(struct
 	int result = 0;
 
 	mutex_lock(&ima_extend_list_mutex);
-	result = ima_add_digest_entry(entry);
+	result = ima_add_digest_entry(entry, 0);
 	mutex_unlock(&ima_extend_list_mutex);
 	return result;
 }
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-restore-the-measurement-list.patch
ima-permit-duplicate-measurement-list-entries.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
ima-serialize-the-binary_runtime_measurements.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch

