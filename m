From: akpm@linux-foundation.org
Subject: [merged]
 sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:39:48 -0700
Message-ID: <53960d84.XzIEbKbm9BM6LVa2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaFITjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:48 -0700


The patch titled
     Subject: sysctl: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -202,7 +202,7 @@ static int proc_dostring_coredump(struct
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

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

