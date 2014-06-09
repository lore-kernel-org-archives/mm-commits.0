From: akpm@linux-foundation.org
Subject: [merged] fs-dlm-configc-convert-simple_str-to-kstr.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:41:06 -0700
Message-ID: <53960dd2.ktO44KIUzTLQIEEt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFITlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ccaulfie@redhat.com, fabf@skynet.be

Subject: [merged] fs-dlm-configc-convert-simple_str-to-kstr.patch removed from -mm tree
To: fabf@skynet.be,ccaulfie@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:06 -0700


The patch titled
     Subject: fs/dlm/config.c: convert simple_str to kstr
has been removed from the -mm tree.  Its filename was
     fs-dlm-configc-convert-simple_str-to-kstr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/dlm/config.c: convert simple_str to kstr

Replace obsolete functions

simple_strtoul/kstrtouint
simple_strtol/kstrtoint
(kstr __must_check requires the right function to be applied)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/config.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN fs/dlm/config.c~fs-dlm-configc-convert-simple_str-to-kstr fs/dlm/config.c
--- a/fs/dlm/config.c~fs-dlm-configc-convert-simple_str-to-kstr
+++ a/fs/dlm/config.c
@@ -157,11 +157,13 @@ static ssize_t cluster_set(struct dlm_cl
 			   const char *buf, size_t len)
 {
 	unsigned int x;
+	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-
-	x = simple_strtoul(buf, NULL, 0);
+	rc = kstrtouint(buf, 0, &x);
+	if (rc)
+		return rc;
 
 	if (check_zero && !x)
 		return -EINVAL;
@@ -730,7 +732,10 @@ static ssize_t comm_nodeid_read(struct d
 static ssize_t comm_nodeid_write(struct dlm_comm *cm, const char *buf,
 				 size_t len)
 {
-	cm->nodeid = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &cm->nodeid);
+
+	if (rc)
+		return rc;
 	return len;
 }
 
@@ -742,7 +747,10 @@ static ssize_t comm_local_read(struct dl
 static ssize_t comm_local_write(struct dlm_comm *cm, const char *buf,
 				size_t len)
 {
-	cm->local= simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &cm->local);
+
+	if (rc)
+		return rc;
 	if (cm->local && !local_comm)
 		local_comm = cm;
 	return len;
@@ -846,7 +854,10 @@ static ssize_t node_nodeid_write(struct
 				 size_t len)
 {
 	uint32_t seq = 0;
-	nd->nodeid = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &nd->nodeid);
+
+	if (rc)
+		return rc;
 	dlm_comm_seq(nd->nodeid, &seq);
 	nd->comm_seq = seq;
 	return len;
@@ -860,7 +871,10 @@ static ssize_t node_weight_read(struct d
 static ssize_t node_weight_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
-	nd->weight = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &nd->weight);
+
+	if (rc)
+		return rc;
 	return len;
 }
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

