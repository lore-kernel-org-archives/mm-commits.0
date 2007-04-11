From: akpm@linux-foundation.org
Subject: + integrity-ima-integrity_measure-support-remove-spinlock.patch added to -mm tree
Date: Wed, 11 Apr 2007 12:53:26 -0700
Message-ID: <200704111953.l3BJrQCU012891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030316AbXDKTx3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 15:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sailer@us.ibm.com


The patch titled
     integrity-ima-integrity_measure-support-remove-spinlock
has been added to the -mm tree.  Its filename is
     integrity-ima-integrity_measure-support-remove-spinlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: integrity-ima-integrity_measure-support-remove-spinlock
From: Reiner Sailer <sailer@us.ibm.com>

We have identified a potential source (spinlock around mutex_init).

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/evm/ima/ima_queue.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN security/evm/ima/ima_queue.c~integrity-ima-integrity_measure-support-remove-spinlock security/evm/ima/ima_queue.c
--- a/security/evm/ima/ima_queue.c~integrity-ima-integrity_measure-support-remove-spinlock
+++ a/security/evm/ima/ima_queue.c
@@ -38,7 +38,6 @@ void create_htable(void)
 {
 	int i;
 
-	spin_lock(&ima_queue_lock);
 	INIT_LIST_HEAD(&ima_measurements);
 	atomic_set(&ima_htable.len, 0);
 	atomic_set(&ima_htable.violations, 0);
@@ -50,7 +49,6 @@ void create_htable(void)
 	}
 
 	mutex_init(&ima_extend_list_mutex);
-	spin_unlock(&ima_queue_lock);
 }
 
 struct queue_entry *ima_lookup_digest_entry(u8 * digest_value)
_

Patches currently in -mm which might be from sailer@us.ibm.com are

integrity-ima-integrity_measure-support-remove-spinlock.patch
