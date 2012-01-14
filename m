From: akpm@linux-foundation.org
Subject: + audit-treat-s_id-as-an-untrusted-string.patch added to -mm tree
Date: Fri, 13 Jan 2012 16:15:20 -0800
Message-ID: <20120114001521.169D62000B6@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60784 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2ANAPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 19:15:23 -0500
Received: by eeke50 with SMTP id e50so28593eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 16:15:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, akpm@linux-foundation.org, jmorris@namei.org, viro@zeniv.linux.org.uk, zohar@us.ibm.com


The patch titled
     Subject: audit: treat s_id as an untrusted string
has been added to the -mm tree.  Its filename is
     audit-treat-s_id-as-an-untrusted-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: audit: treat s_id as an untrusted string

The use of s_id should go through the untrusted string path, just to be
extra careful.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima_audit.c |    8 +++++---
 security/lsm_audit.c               |   23 +++++++++++++----------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff -puN security/integrity/ima/ima_audit.c~audit-treat-s_id-as-an-untrusted-string security/integrity/ima/ima_audit.c
--- a/security/integrity/ima/ima_audit.c~audit-treat-s_id-as-an-untrusted-string
+++ a/security/integrity/ima/ima_audit.c
@@ -56,9 +56,11 @@ void integrity_audit_msg(int audit_msgno
 		audit_log_format(ab, " name=");
 		audit_log_untrustedstring(ab, fname);
 	}
-	if (inode)
-		audit_log_format(ab, " dev=%s ino=%lu",
-				 inode->i_sb->s_id, inode->i_ino);
+	if (inode) {
+		audit_log_format(ab, " dev=");
+		audit_log_untrustedstring(ab, inode->i_sb->s_id);
+		audit_log_format(ab, " ino=%lu", inode->i_ino);
+	}
 	audit_log_format(ab, " res=%d", !result ? 0 : 1);
 	audit_log_end(ab);
 }
diff -puN security/lsm_audit.c~audit-treat-s_id-as-an-untrusted-string security/lsm_audit.c
--- a/security/lsm_audit.c~audit-treat-s_id-as-an-untrusted-string
+++ a/security/lsm_audit.c
@@ -235,10 +235,11 @@ static void dump_common_audit_data(struc
 		audit_log_d_path(ab, "path=", &a->u.path);
 
 		inode = a->u.path.dentry->d_inode;
-		if (inode)
-			audit_log_format(ab, " dev=%s ino=%lu",
-					inode->i_sb->s_id,
-					inode->i_ino);
+		if (inode) {
+			audit_log_format(ab, " dev=");
+			audit_log_untrustedstring(ab, inode->i_sb->s_id);
+			audit_log_format(ab, " ino=%lu", inode->i_ino);
+		}
 		break;
 	}
 	case LSM_AUDIT_DATA_DENTRY: {
@@ -248,10 +249,11 @@ static void dump_common_audit_data(struc
 		audit_log_untrustedstring(ab, a->u.dentry->d_name.name);
 
 		inode = a->u.dentry->d_inode;
-		if (inode)
-			audit_log_format(ab, " dev=%s ino=%lu",
-					inode->i_sb->s_id,
-					inode->i_ino);
+		if (inode) {
+			audit_log_format(ab, " dev=");
+			audit_log_untrustedstring(ab, inode->i_sb->s_id);
+			audit_log_format(ab, " ino=%lu", inode->i_ino);
+		}
 		break;
 	}
 	case LSM_AUDIT_DATA_INODE: {
@@ -266,8 +268,9 @@ static void dump_common_audit_data(struc
 					 dentry->d_name.name);
 			dput(dentry);
 		}
-		audit_log_format(ab, " dev=%s ino=%lu", inode->i_sb->s_id,
-				 inode->i_ino);
+		audit_log_format(ab, " dev=");
+		audit_log_untrustedstring(ab, inode->i_sb->s_id);
+		audit_log_format(ab, " ino=%lu", inode->i_ino);
 		break;
 	}
 	case LSM_AUDIT_DATA_TASK:
_
Subject: Subject: audit: treat s_id as an untrusted string

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
audit-treat-s_id-as-an-untrusted-string.patch

