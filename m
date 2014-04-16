From: akpm@linux-foundation.org
Subject: +
 sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to
 -mm tree
Date: Wed, 16 Apr 2014 15:09:01 -0700
Message-ID: <534eff7d.20O84/JEPRmfW0W7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbaDPWJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:09:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:09:01 -0700


The patch titled
     Subject: sysctl: convert use of typedef ctl_table to struct ctl_table
has been added to the -mm tree.  Its filename is
     sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

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
Subject: sysctl: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c         |    2 +-
 kernel/utsname_sysctl.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/sysctl.c~sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/kernel/sysctl.c
@@ -195,7 +195,7 @@ static int proc_dostring_coredump(struct
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE;
 
-static int sysrq_sysctl_handler(ctl_table *table, int write,
+static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
diff -puN kernel/utsname_sysctl.c~sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/kernel/utsname_sysctl.c
@@ -17,7 +17,7 @@
 
 #ifdef CONFIG_PROC_SYSCTL
 
-static void *get_uts(ctl_table *table, int write)
+static void *get_uts(struct ctl_table *table, int write)
 {
 	char *which = table->data;
 	struct uts_namespace *uts_ns;
@@ -32,7 +32,7 @@ static void *get_uts(ctl_table *table, i
 	return which;
 }
 
-static void put_uts(ctl_table *table, int write, void *which)
+static void put_uts(struct ctl_table *table, int write, void *which)
 {
 	if (!write)
 		up_read(&uts_sem);
@@ -44,7 +44,7 @@ static void put_uts(ctl_table *table, in
  *	Special case of dostring for the UTS structure. This has locks
  *	to observe. Should this be in kernel/sys.c ????
  */
-static int proc_do_uts_string(ctl_table *table, int write,
+static int proc_do_uts_string(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table uts_table;
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

