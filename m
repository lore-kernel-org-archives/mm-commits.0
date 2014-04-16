From: akpm@linux-foundation.org
Subject: + nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
 added to -mm tree
Date: Wed, 16 Apr 2014 15:08:55 -0700
Message-ID: <534eff77.8IsBpUDdfLDQLdZS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbaDPWI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:08:55 -0700


The patch titled
     Subject: nfs: convert use of typedef ctl_table to struct ctl_table
has been added to the -mm tree.  Its filename is
     nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

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

