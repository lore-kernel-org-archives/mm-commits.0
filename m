From: akpm@linux-foundation.org
Subject: [merged]
 lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:39:13 -0700
Message-ID: <53960d61.OQgXRuHHDZ6rnBRz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaFITjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:13 -0700


The patch titled
     Subject: lockd: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: lockd: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/lockd/svc.c~lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/lockd/svc.c
--- a/fs/lockd/svc.c~lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/lockd/svc.c
@@ -436,7 +436,7 @@ EXPORT_SYMBOL_GPL(lockd_down);
  * Sysctl parameters (same as module parameters, different interface).
  */
 
-static ctl_table nlm_sysctls[] = {
+static struct ctl_table nlm_sysctls[] = {
 	{
 		.procname	= "nlm_grace_period",
 		.data		= &nlm_grace_period,
@@ -490,7 +490,7 @@ static ctl_table nlm_sysctls[] = {
 	{ }
 };
 
-static ctl_table nlm_sysctl_dir[] = {
+static struct ctl_table nlm_sysctl_dir[] = {
 	{
 		.procname	= "nfs",
 		.mode		= 0555,
@@ -499,7 +499,7 @@ static ctl_table nlm_sysctl_dir[] = {
 	{ }
 };
 
-static ctl_table nlm_sysctl_root[] = {
+static struct ctl_table nlm_sysctl_root[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

