From: akpm@linux-foundation.org
Subject: + ocfs2-fix-an-off-by-one-bug_on-statement.patch added to -mm
 tree
Date: Wed, 22 Oct 2014 12:12:34 -0700
Message-ID: <544801a2.uVa3+B06l0prn2j0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbaJVTMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix an off-by-one BUG_ON() statement
has been added to the -mm tree.  Its filename is
     ocfs2-fix-an-off-by-one-bug_on-statement.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-an-off-by-one-bug_on-statement.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-an-off-by-one-bug_on-statement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: fix an off-by-one BUG_ON() statement

The ->si_slots[] array is allocated in ocfs2_init_slot_info() it has
"->max_slots" number of elements so this test should be >= instead of >.

Static checker work.  Compile tested only.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/slot_map.c~ocfs2-fix-an-off-by-one-bug_on-statement fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-fix-an-off-by-one-bug_on-statement
+++ a/fs/ocfs2/slot_map.c
@@ -306,7 +306,7 @@ int ocfs2_slot_to_node_num_locked(struct
 	assert_spin_locked(&osb->osb_lock);
 
 	BUG_ON(slot_num < 0);
-	BUG_ON(slot_num > osb->max_slots);
+	BUG_ON(slot_num >= osb->max_slots);
 
 	if (!si->si_slots[slot_num].sl_valid)
 		return -ENOENT;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
ocfs2-fix-an-off-by-one-bug_on-statement.patch
linux-next.patch

