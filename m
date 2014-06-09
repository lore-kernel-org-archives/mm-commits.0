From: akpm@linux-foundation.org
Subject: [merged]
 ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:38:33 -0700
Message-ID: <53960d39.mNTX+6F5+Oy3NSPV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:33 -0700


The patch titled
     Subject: ia64: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ia64: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/crash.c   |    4 ++--
 arch/ia64/kernel/perfmon.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/ia64/kernel/crash.c~ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/arch/ia64/kernel/crash.c
@@ -237,7 +237,7 @@ kdump_init_notifier(struct notifier_bloc
 }
 
 #ifdef CONFIG_SYSCTL
-static ctl_table kdump_ctl_table[] = {
+static struct ctl_table kdump_ctl_table[] = {
 	{
 		.procname = "kdump_on_init",
 		.data = &kdump_on_init,
@@ -255,7 +255,7 @@ static ctl_table kdump_ctl_table[] = {
 	{ }
 };
 
-static ctl_table sys_table[] = {
+static struct ctl_table sys_table[] = {
 	{
 	  .procname = "kernel",
 	  .mode = 0555,
diff -puN arch/ia64/kernel/perfmon.c~ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/arch/ia64/kernel/perfmon.c
@@ -521,7 +521,7 @@ static pmu_config_t		*pmu_conf;
 pfm_sysctl_t pfm_sysctl;
 EXPORT_SYMBOL(pfm_sysctl);
 
-static ctl_table pfm_ctl_table[]={
+static struct ctl_table pfm_ctl_table[] = {
 	{
 		.procname	= "debug",
 		.data		= &pfm_sysctl.debug,
@@ -552,7 +552,7 @@ static ctl_table pfm_ctl_table[]={
 	},
 	{}
 };
-static ctl_table pfm_sysctl_dir[] = {
+static struct ctl_table pfm_sysctl_dir[] = {
 	{
 		.procname	= "perfmon",
 		.mode		= 0555,
@@ -560,7 +560,7 @@ static ctl_table pfm_sysctl_dir[] = {
 	},
  	{}
 };
-static ctl_table pfm_sysctl_root[] = {
+static struct ctl_table pfm_sysctl_root[] = {
 	{
 		.procname	= "kernel",
 		.mode		= 0555,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

