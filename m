From: akpm@linux-foundation.org
Subject: +
 ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
 added to -mm tree
Date: Wed, 23 Jul 2014 14:03:47 -0700
Message-ID: <53d02333.+ohvJT+RpaZ1sfOt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:52260 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbaGWVDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 17:03:48 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so234656igi.5
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 14:03:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: avoid access invalid address when read o2dlm debug messages.
has been added to the -mm tree.  Its filename is
     ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: avoid access invalid address when read o2dlm debug messages.

The following case will lead to a lockres bieing freed while it is still
in use.

cat /sys/kernel/debug/o2dlm/locking_state	dlm_thread
lockres_seq_start
    -> lock dlm->track_lock
    -> get resA
                                                resA->refs decrease to 0,
                                                call dlm_lockres_release,
                                                and wait for "cat" unlock.
Although resA->refs is already set to 0,
increase resA->refs, and then unlock
                                                lock dlm->track_lock
                                                    -> list_del_init()
                                                    -> unlock
                                                    -> free resA

In such a race case, invalid address access may occurs.  So we should
delete list res->tracking before resA->refs decrease to 0.

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   10 ----------
 fs/ocfs2/dlm/dlmthread.c |   10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -498,16 +498,6 @@ static void dlm_lockres_release(struct k
 	mlog(0, "destroying lockres %.*s\n", res->lockname.len,
 	     res->lockname.name);
 
-	spin_lock(&dlm->track_lock);
-	if (!list_empty(&res->tracking))
-		list_del_init(&res->tracking);
-	else {
-		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
-		     res->lockname.len, res->lockname.name);
-		dlm_print_one_lock_resource(res);
-	}
-	spin_unlock(&dlm->track_lock);
-
 	atomic_dec(&dlm->res_cur_count);
 
 	if (!hlist_unhashed(&res->hash_node) ||
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -211,6 +211,16 @@ static void dlm_purge_lockres(struct dlm
 
 	__dlm_unhash_lockres(dlm, res);
 
+	spin_lock(&dlm->track_lock);
+	if (!list_empty(&res->tracking))
+		list_del_init(&res->tracking);
+	else {
+		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
+				res->lockname.len, res->lockname.name);
+		dlm_print_one_lock_resource(res);
+	}
+	spin_unlock(&dlm->track_lock);
+
 	/* lockres is not in the hash now.  drop the flag and wake up
 	 * any processes waiting in dlm_get_lock_resource. */
 	if (!master) {
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

