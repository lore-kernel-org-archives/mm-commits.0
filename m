From: akpm@linux-foundation.org
Subject: + nbd-lower-the-loglevel-of-an-error-message.patch added to -mm tree
Date: Wed, 17 Aug 2011 13:23:17 -0700
Message-ID: <201108172023.p7HKNHvF026023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1HQUXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 16:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, Paul.Clements@steeleye.com, axboe@kernel.dk


The patch titled
     nbd: lower the loglevel of an error message
has been added to the -mm tree.  Its filename is
     nbd-lower-the-loglevel-of-an-error-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: lower the loglevel of an error message
From: WANG Cong <amwang@redhat.com>

This is only an error, no need to use KERN_CRIT log level.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/nbd.c~nbd-lower-the-loglevel-of-an-error-message drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-lower-the-loglevel-of-an-error-message
+++ a/drivers/block/nbd.c
@@ -745,7 +745,7 @@ static int __init nbd_init(void)
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
 	if (max_part < 0) {
-		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
+		printk(KERN_ERR "nbd: max_part must be >= 0\n");
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
drm-add-missing-header-file-linuc-typesh.patch
nbd-use-task_pid_nr-to-get-current-pid.patch
nbd-replace-sysfs_create_file-with-device_create_file.patch
nbd-replace-printk-kern_err-with-dev_err.patch
nbd-lower-the-loglevel-of-an-error-message.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info.patch
nbd-some-trivial-improvements.patch

