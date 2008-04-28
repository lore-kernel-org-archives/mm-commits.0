From: akpm@linux-foundation.org
Subject: - smack-make-smk_cipso_doi-and-smk_unlbl_ambient.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:21 -0700
Message-ID: <200804282154.m3SLsL3n017996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965098AbYD1VyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: casey@schaufler-ca.com, mm-commits@vger.kernel.org


The patch titled
     smack: make smk_cipso_doi() and smk_unlbl_ambient()
has been removed from the -mm tree.  Its filename was
     smack-make-smk_cipso_doi-and-smk_unlbl_ambient.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smack: make smk_cipso_doi() and smk_unlbl_ambient()
From: Casey Schaufler <casey@schaufler-ca.com>

The functions smk_cipso_doi and smk_unlbl_ambient are not used outside
smackfs.c and should hence be static.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smackfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/smack/smackfs.c~smack-make-smk_cipso_doi-and-smk_unlbl_ambient security/smack/smackfs.c
--- a/security/smack/smackfs.c~smack-make-smk_cipso_doi-and-smk_unlbl_ambient
+++ a/security/smack/smackfs.c
@@ -317,7 +317,7 @@ static const struct file_operations smk_
 /**
  * smk_cipso_doi - initialize the CIPSO domain
  */
-void smk_cipso_doi(void)
+static void smk_cipso_doi(void)
 {
 	int rc;
 	struct cipso_v4_doi *doip;
@@ -350,7 +350,7 @@ void smk_cipso_doi(void)
 /**
  * smk_unlbl_ambient - initialize the unlabeled domain
  */
-void smk_unlbl_ambient(char *oldambient)
+static void smk_unlbl_ambient(char *oldambient)
 {
 	int rc;
 	struct netlbl_audit audit_info;
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

origin.patch
nfs-lsm-make-nfsv4-set-lsm-mount-options.patch
signals-cleanup-security_task_kill-usage-implementation.patch

