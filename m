From: akpm@linux-foundation.org
Subject: - integrity-ima-integrity_measure-support-remove-spinlock.patch removed from -mm tree
Date: Wed, 09 May 2007 03:01:08 -0700
Message-ID: <200705091001.l49A18vg020690@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922AbXEIKB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sailer@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity-ima-integrity_measure-support-remove-spinlock
has been removed from the -mm tree.  Its filename was
     integrity-ima-integrity_measure-support-remove-spinlock.patch

This patch was dropped because it was folded into integrity-ima-integrity_measure-support.patch

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

integrity-ima-integrity_measure-support.patch
integrity-ima-integrity_measure-support-remove-spinlock.patch
