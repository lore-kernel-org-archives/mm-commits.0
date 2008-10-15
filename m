From: akpm@linux-foundation.org
Subject: - tpm-fixed-tpm_release-timing.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:14:27 -0700
Message-ID: <200810152114.m9FLER4U005762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbYJOVPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:15:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srajiv@linux.vnet.ibm.com, corbet@lwn.net, serue@us.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tpm: Fixed tpm_release() timing
has been removed from the -mm tree.  Its filename was
     tpm-fixed-tpm_release-timing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
tpm-include-moderated-for-non-subscribers-notation-in-maintainers.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch

