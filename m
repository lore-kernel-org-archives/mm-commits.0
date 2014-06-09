From: akpm@linux-foundation.org
Subject: [merged]
 nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:39:18 -0700
Message-ID: <53960d66.G7dbA9sbxRTK++Yh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:18 -0700


The patch titled
     Subject: nfs: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: nfs: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4sysctl.c |    6 +++---
 fs/nfs/sysctl.c     |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/nfs/nfs4sysctl.c~nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/nfs/nfs4sysctl.c
--- a/fs/nfs/nfs4sysctl.c~nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/nfs/nfs4sysctl.c
@@ -16,7 +16,7 @@ static const int nfs_set_port_min = 0;
 static const int nfs_set_port_max = 65535;
 static struct ctl_table_header *nfs4_callback_sysctl_table;
 
-static ctl_table nfs4_cb_sysctls[] = {
+static struct ctl_table nfs4_cb_sysctls[] = {
 	{
 		.procname = "nfs_callback_tcpport",
 		.data = &nfs_callback_set_tcpport,
@@ -36,7 +36,7 @@ static ctl_table nfs4_cb_sysctls[] = {
 	{ }
 };
 
-static ctl_table nfs4_cb_sysctl_dir[] = {
+static struct ctl_table nfs4_cb_sysctl_dir[] = {
 	{
 		.procname = "nfs",
 		.mode = 0555,
@@ -45,7 +45,7 @@ static ctl_table nfs4_cb_sysctl_dir[] =
 	{ }
 };
 
-static ctl_table nfs4_cb_sysctl_root[] = {
+static struct ctl_table nfs4_cb_sysctl_root[] = {
 	{
 		.procname = "fs",
 		.mode = 0555,
diff -puN fs/nfs/sysctl.c~nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/nfs/sysctl.c
--- a/fs/nfs/sysctl.c~nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/nfs/sysctl.c
@@ -13,7 +13,7 @@
 
 static struct ctl_table_header *nfs_callback_sysctl_table;
 
-static ctl_table nfs_cb_sysctls[] = {
+static struct ctl_table nfs_cb_sysctls[] = {
 	{
 		.procname	= "nfs_mountpoint_timeout",
 		.data		= &nfs_mountpoint_expiry_timeout,
@@ -31,7 +31,7 @@ static ctl_table nfs_cb_sysctls[] = {
 	{ }
 };
 
-static ctl_table nfs_cb_sysctl_dir[] = {
+static struct ctl_table nfs_cb_sysctl_dir[] = {
 	{
 		.procname = "nfs",
 		.mode = 0555,
@@ -40,7 +40,7 @@ static ctl_table nfs_cb_sysctl_dir[] = {
 	{ }
 };
 
-static ctl_table nfs_cb_sysctl_root[] = {
+static struct ctl_table nfs_cb_sysctl_root[] = {
 	{
 		.procname = "fs",
 		.mode = 0555,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

