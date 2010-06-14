From: akpm@linux-foundation.org
Subject: + floppy-fix-signed-unsigned-warnings.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:39:26 -0700
Message-ID: <201006141939.o5EJdQeO026925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FNTja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: fix signed/unsigned warnings
has been added to the -mm tree.  Its filename is
     floppy-fix-signed-unsigned-warnings.patch

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
Subject: floppy: fix signed/unsigned warnings
From: Stephen Hemminger <shemminger@vyatta.com>

Ioctl cmd value is unsigned, so change normalize_ioctl

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/floppy.c~floppy-fix-signed-unsigned-warnings drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-fix-signed-unsigned-warnings
+++ a/drivers/block/floppy.c
@@ -3337,7 +3337,7 @@ static int set_geometry(unsigned int cmd
 }
 
 /* handle obsolete ioctl's */
-static int ioctl_table[] = {
+static unsigned int ioctl_table[] = {
 	FDCLRPRM,
 	FDSETPRM,
 	FDDEFPRM,
@@ -3365,7 +3365,7 @@ static int ioctl_table[] = {
 	FDTWADDLE
 };
 
-static int normalize_ioctl(int *cmd, int *size)
+static int normalize_ioctl(unsigned int *cmd, int *size)
 {
 	int i;
 
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
floppy-initialize-debug-jiffies-offset.patch
floppy-remove-unnecessary-inlines.patch
floppy-silence-warning-during-disk-test.patch
floppy-use-atomic-type-for-usage_count.patch
floppy-cmos-attribute-should-be-static.patch
floppy-fix-signed-unsigned-warnings.patch
floppy-use-wait_event_interruptible.patch
floppy-use-warning-macros.patch
floppy-make-controller-const.patch

