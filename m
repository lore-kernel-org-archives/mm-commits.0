From: akpm@linux-foundation.org
Subject: [merged]
 cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:38:43 -0700
Message-ID: <53960d43.5lporJVrpfvE3KVI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:43 -0700


The patch titled
     Subject: cdrom: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3470,7 +3470,7 @@ static int cdrom_print_info(const char *
 	return 0;
 }
 
-static int cdrom_sysctl_info(ctl_table *ctl, int write,
+static int cdrom_sysctl_info(struct ctl_table *ctl, int write,
                            void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int pos;
@@ -3583,7 +3583,7 @@ static void cdrom_update_settings(void)
 	mutex_unlock(&cdrom_mutex);
 }
 
-static int cdrom_sysctl_handler(ctl_table *ctl, int write,
+static int cdrom_sysctl_handler(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
@@ -3609,7 +3609,7 @@ static int cdrom_sysctl_handler(ctl_tabl
 }
 
 /* Place files in /proc/sys/dev/cdrom */
-static ctl_table cdrom_table[] = {
+static struct ctl_table cdrom_table[] = {
 	{
 		.procname	= "info",
 		.data		= &cdrom_sysctl_settings.info, 
@@ -3655,7 +3655,7 @@ static ctl_table cdrom_table[] = {
 	{ }
 };
 
-static ctl_table cdrom_cdrom_table[] = {
+static struct ctl_table cdrom_cdrom_table[] = {
 	{
 		.procname	= "cdrom",
 		.maxlen		= 0,
@@ -3666,7 +3666,7 @@ static ctl_table cdrom_cdrom_table[] = {
 };
 
 /* Make sure that /proc/sys/dev is there */
-static ctl_table cdrom_root_table[] = {
+static struct ctl_table cdrom_root_table[] = {
 	{
 		.procname	= "dev",
 		.maxlen		= 0,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

