From: akpm@linux-foundation.org
Subject: + tpm-fixed-tpm_release-timing.patch added to -mm tree
Date: Wed, 08 Oct 2008 15:45:21 -0700
Message-ID: <200810082245.m98MjLux014723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916AbYJHWqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 18:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, corbet@lwn.net, serue@us.ibm.com, zohar@linux.vnet.ibm.com


The patch titled
     tpm: Fixed tpm_release() timing
has been added to the -mm tree.  Its filename is
     tpm-fixed-tpm_release-timing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: Fixed tpm_release() timing
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

As pointed out by Jonathan Corbet, the timer must be deleted before
flushing the work queue in order to avoid a job being submitted after the
chip had been released.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm.c~tpm-fixed-tpm_release-timing drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-fixed-tpm_release-timing
+++ a/drivers/char/tpm/tpm.c
@@ -1011,9 +1011,9 @@ int tpm_release(struct inode *inode, str
 {
 	struct tpm_chip *chip = file->private_data;
 
+	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_scheduled_work();
 	file->private_data = NULL;
-	del_singleshot_timer_sync(&chip->user_read_timer);
 	atomic_set(&chip->data_pending, 0);
 	kfree(chip->data_buffer);
 	clear_bit(0, &chip->is_open);
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
tpm-update-char-dev-bkl-pushdown.patch
tpm-num_opens-to-is_open-variable-change.patch
tpm-rcu-locking.patch
tpm-addition-of-pnp_remove.patch
tpm-addition-of-pnp_remove-checkpatch-fixes.patch
tpm-fixed-tpm_release-timing.patch

