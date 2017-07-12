From: akpm@linux-foundation.org
Subject: [patch 11/96] sysctl: fold sysctl_writes_strict checks
 into helper
Date: Wed, 12 Jul 2017 14:33:33 -0700
Message-ID: <20170712213333.mD7NG2TMy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753083AbdGLVdk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: sysctl: fold sysctl_writes_strict checks into helper

The mode sysctl_writes_strict positional checks keep being copy and pasted
as we add new proc handlers.  Just add a helper to avoid code duplication.

Link: http://lkml.kernel.org/r/20170519033554.18592-4-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   56 ++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff -puN kernel/sysctl.c~sysctl-fold-sysctl_writes_strict-checks-into-helper kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fold-sysctl_writes_strict-checks-into-helper
+++ a/kernel/sysctl.c
@@ -1971,6 +1971,32 @@ static void warn_sysctl_write(struct ctl
 }
 
 /**
+ * proc_first_pos_non_zero_ignore - check if firs position is allowed
+ * @ppos: file position
+ * @table: the sysctl table
+ *
+ * Returns true if the first position is non-zero and the sysctl_writes_strict
+ * mode indicates this is not allowed for numeric input types. String proc
+ * hadlers can ignore the return value.
+ */
+static bool proc_first_pos_non_zero_ignore(loff_t *ppos,
+					   struct ctl_table *table)
+{
+	if (!*ppos)
+		return false;
+
+	switch (sysctl_writes_strict) {
+	case SYSCTL_WRITES_STRICT:
+		return true;
+	case SYSCTL_WRITES_WARN:
+		warn_sysctl_write(table);
+		return false;
+	default:
+		return false;
+	}
+}
+
+/**
  * proc_dostring - read a string sysctl
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
@@ -1990,8 +2016,8 @@ static void warn_sysctl_write(struct ctl
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (write && *ppos && sysctl_writes_strict == SYSCTL_WRITES_WARN)
-		warn_sysctl_write(table);
+	if (write)
+		proc_first_pos_non_zero_ignore(ppos, table);
 
 	return _proc_do_string((char *)(table->data), table->maxlen, write,
 			       (char __user *)buffer, lenp, ppos);
@@ -2193,17 +2219,8 @@ static int __do_proc_dointvec(void *tbl_
 		conv = do_proc_dointvec_conv;
 
 	if (write) {
-		if (*ppos) {
-			switch (sysctl_writes_strict) {
-			case SYSCTL_WRITES_STRICT:
-				goto out;
-			case SYSCTL_WRITES_WARN:
-				warn_sysctl_write(table);
-				break;
-			default:
-				break;
-			}
-		}
+		if (proc_first_pos_non_zero_ignore(ppos, table))
+			goto out;
 
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
@@ -2468,17 +2485,8 @@ static int __do_proc_doulongvec_minmax(v
 	left = *lenp;
 
 	if (write) {
-		if (*ppos) {
-			switch (sysctl_writes_strict) {
-			case SYSCTL_WRITES_STRICT:
-				goto out;
-			case SYSCTL_WRITES_WARN:
-				warn_sysctl_write(table);
-				break;
-			default:
-				break;
-			}
-		}
+		if (proc_first_pos_non_zero_ignore(ppos, table))
+			goto out;
 
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
_
