From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unneeded-null-check.patch added to -mm tree
Date: Mon, 01 Dec 2014 16:39:17 -0800
Message-ID: <547d0a35.9xBF1aoWUj97xL7H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbaLBAjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 19:39:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded NULL check
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unneeded-null-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unneeded-null-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unneeded-null-check.patch

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
Subject: ocfs2: remove unneeded NULL check

In 1faf289454b9 ("ocfs2_dlm: disallow a domain join if node maps
mismatch") we introduced a new earlier NULL check so this one is not
needed.  Also static checkers complain because we dereference it first and
then check for NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-unneeded-null-check fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-unneeded-null-check
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -877,7 +877,7 @@ static int dlm_query_join_handler(struct
 	 * to be put in someone's domain map.
 	 * Also, explicitly disallow joining at certain troublesome
 	 * times (ie. during recovery). */
-	if (dlm && dlm->dlm_state != DLM_CTXT_LEAVING) {
+	if (dlm->dlm_state != DLM_CTXT_LEAVING) {
 		int bit = query->node_idx;
 		spin_lock(&dlm->spinlock);
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-fix-an-off-by-one-bug_on-statement.patch
ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch
ocfs2-remove-unneeded-null-check.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
checkpatch-add-strict-pointer-comparison-to-null-test.patch
checkpatch-add-ability-to-fix-coalesce-string-fragments-on-multiple-lines.patch
rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

