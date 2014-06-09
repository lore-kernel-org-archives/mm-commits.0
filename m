From: akpm@linux-foundation.org
Subject: [merged] fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:41:11 -0700
Message-ID: <53960dd7.mOADpBNWSQQj7tpE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFITlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ccaulfie@redhat.com, fabf@skynet.be

Subject: [merged] fs-dlm-lockspacec-convert-simple_str-to-kstr.patch removed from -mm tree
To: fabf@skynet.be,ccaulfie@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:11 -0700


The patch titled
     Subject: fs/dlm/lockspace.c: convert simple_str to kstr
has been removed from the -mm tree.  Its filename was
     fs-dlm-lockspacec-convert-simple_str-to-kstr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/dlm/lockspace.c: convert simple_str to kstr

Replace obsolete functions.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/lockspace.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN fs/dlm/lockspace.c~fs-dlm-lockspacec-convert-simple_str-to-kstr fs/dlm/lockspace.c
--- a/fs/dlm/lockspace.c~fs-dlm-lockspacec-convert-simple_str-to-kstr
+++ a/fs/dlm/lockspace.c
@@ -35,8 +35,11 @@ static struct task_struct *	scand_task;
 static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
 	ssize_t ret = len;
-	int n = simple_strtol(buf, NULL, 0);
+	int n;
+	int rc = kstrtoint(buf, 0, &n);
 
+	if (rc)
+		return rc;
 	ls = dlm_find_lockspace_local(ls->ls_local_handle);
 	if (!ls)
 		return -EINVAL;
@@ -57,7 +60,10 @@ static ssize_t dlm_control_store(struct
 
 static ssize_t dlm_event_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	ls->ls_uevent_result = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &ls->ls_uevent_result);
+
+	if (rc)
+		return rc;
 	set_bit(LSFL_UEVENT_WAIT, &ls->ls_flags);
 	wake_up(&ls->ls_uevent_wait);
 	return len;
@@ -70,7 +76,10 @@ static ssize_t dlm_id_show(struct dlm_ls
 
 static ssize_t dlm_id_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	ls->ls_global_id = simple_strtoul(buf, NULL, 0);
+	int rc = kstrtouint(buf, 0, &ls->ls_global_id);
+
+	if (rc)
+		return rc;
 	return len;
 }
 
@@ -81,7 +90,11 @@ static ssize_t dlm_nodir_show(struct dlm
 
 static ssize_t dlm_nodir_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	int val = simple_strtoul(buf, NULL, 0);
+	int val;
+	int rc = kstrtoint(buf, 0, &val);
+
+	if (rc)
+		return rc;
 	if (val == 1)
 		set_bit(LSFL_NODIR, &ls->ls_flags);
 	return len;
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

