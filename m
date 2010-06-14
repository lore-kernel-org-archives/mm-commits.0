From: akpm@linux-foundation.org
Subject: + floppy-remove-unnecessary-inlines.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:39:18 -0700
Message-ID: <201006141939.o5EJdIrd026905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab0FNTjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: remove unnecessary inlines
has been added to the -mm tree.  Its filename is
     floppy-remove-unnecessary-inlines.patch

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
Subject: floppy: remove unnecessary inlines
From: Stephen Hemminger <shemminger@vyatta.com>

These routines are all big enough that is better to let the compiler
decide to inline or not.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/block/floppy.c~floppy-remove-unnecessary-inlines drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-remove-unnecessary-inlines
+++ a/drivers/block/floppy.c
@@ -899,7 +899,7 @@ static int _lock_fdc(int drive, bool int
 	_lock_fdc(drive, interruptible, __LINE__)
 
 /* unlocks the driver */
-static inline void unlock_fdc(void)
+static void unlock_fdc(void)
 {
 	unsigned long flags;
 
@@ -1224,7 +1224,7 @@ static int need_more_output(void)
 /* Set perpendicular mode as required, based on data rate, if supported.
  * 82077 Now tested. 1Mbps data rate only possible with 82077-1.
  */
-static inline void perpendicular_mode(void)
+static void perpendicular_mode(void)
 {
 	unsigned char perp_mode;
 
@@ -3033,7 +3033,7 @@ static inline int fd_copyin(void __user 
 	return copy_from_user(address, param, size) ? -EFAULT : 0;
 }
 
-static inline const char *drive_name(int type, int drive)
+static const char *drive_name(int type, int drive)
 {
 	struct floppy_struct *floppy;
 
@@ -3103,7 +3103,7 @@ static struct cont_t raw_cmd_cont = {
 	.done		= raw_cmd_done
 };
 
-static inline int raw_cmd_copyout(int cmd, void __user *param,
+static int raw_cmd_copyout(int cmd, void __user *param,
 				  struct floppy_raw_cmd *ptr)
 {
 	int ret;
@@ -3148,7 +3148,7 @@ static void raw_cmd_free(struct floppy_r
 	}
 }
 
-static inline int raw_cmd_copyin(int cmd, void __user *param,
+static int raw_cmd_copyin(int cmd, void __user *param,
 				 struct floppy_raw_cmd **rcmd)
 {
 	struct floppy_raw_cmd *ptr;
@@ -3266,7 +3266,7 @@ static int invalidate_drive(struct block
 	return 0;
 }
 
-static inline int set_geometry(unsigned int cmd, struct floppy_struct *g,
+static int set_geometry(unsigned int cmd, struct floppy_struct *g,
 			       int drive, int type, struct block_device *bdev)
 {
 	int cnt;
@@ -3365,7 +3365,7 @@ static int ioctl_table[] = {
 	FDTWADDLE
 };
 
-static inline int normalize_ioctl(int *cmd, int *size)
+static int normalize_ioctl(int *cmd, int *size)
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

