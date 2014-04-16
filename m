From: akpm@linux-foundation.org
Subject: +
 cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to
 -mm tree
Date: Wed, 16 Apr 2014 15:08:48 -0700
Message-ID: <534eff70.L+VnFc0Iftexem2c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbaDPWIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:08:48 -0700


The patch titled
     Subject: cdrom: convert use of typedef ctl_table to struct ctl_table
has been added to the -mm tree.  Its filename is
     cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: cdrom: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/cdrom/cdrom.c~cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/drivers/cdrom/cdrom.c
@@ -3465,7 +3465,7 @@ static int cdrom_print_info(const char *
 	return 0;
 }
 
-static int cdrom_sysctl_info(ctl_table *ctl, int write,
+static int cdrom_sysctl_info(struct ctl_table *ctl, int write,
                            void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int pos;
@@ -3578,7 +3578,7 @@ static void cdrom_update_settings(void)
 	mutex_unlock(&cdrom_mutex);
 }
 
-static int cdrom_sysctl_handler(ctl_table *ctl, int write,
+static int cdrom_sysctl_handler(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
@@ -3604,7 +3604,7 @@ static int cdrom_sysctl_handler(ctl_tabl
 }
 
 /* Place files in /proc/sys/dev/cdrom */
-static ctl_table cdrom_table[] = {
+static struct ctl_table cdrom_table[] = {
 	{
 		.procname	= "info",
 		.data		= &cdrom_sysctl_settings.info, 
@@ -3650,7 +3650,7 @@ static ctl_table cdrom_table[] = {
 	{ }
 };
 
-static ctl_table cdrom_cdrom_table[] = {
+static struct ctl_table cdrom_cdrom_table[] = {
 	{
 		.procname	= "cdrom",
 		.maxlen		= 0,
@@ -3661,7 +3661,7 @@ static ctl_table cdrom_cdrom_table[] = {
 };
 
 /* Make sure that /proc/sys/dev is there */
-static ctl_table cdrom_root_table[] = {
+static struct ctl_table cdrom_root_table[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
_

Patches currently in -mm which might be from joe@perches.com are

arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
security-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
init-mainc-dont-use-pr_debug.patch
linux-next.patch

