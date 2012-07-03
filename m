From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-add-link-restriction-audit-reporting.patch removed from -mm tree
Date: Tue, 03 Jul 2012 14:08:56 -0700
Message-ID: <20120703210856.C5F56A0244@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:38106 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab2GCVI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2012 17:08:58 -0400
Received: by ghbz15 with SMTP id z15so760329ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jul 2012 14:08:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, eparis@redhat.com, mingo@elte.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: add link restriction audit reporting
has been removed from the -mm tree.  Its filename was
     fs-add-link-restriction-audit-reporting.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs: add link restriction audit reporting

Add audit messages for unexpected link restriction violations so that
system owners will have some sort of potentially actionable information
about misbehaving processes.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |    3 +++
 include/linux/audit.h |    4 ++++
 kernel/audit.c        |   21 +++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff -puN fs/namei.c~fs-add-link-restriction-audit-reporting fs/namei.c
--- a/fs/namei.c~fs-add-link-restriction-audit-reporting
+++ a/fs/namei.c
@@ -657,6 +657,8 @@ static inline int may_follow_link(struct
 	}
 	spin_unlock(&dentry->d_lock);
 
+	if (error)
+		audit_log_link_denied("follow_link", link);
 	return error;
 }
 
@@ -725,6 +727,7 @@ static int may_linkat(struct path *link)
 	    capable(CAP_FOWNER))
 		return 0;
 
+	audit_log_link_denied("linkat", link);
 	return -EPERM;
 }
 #else
diff -puN include/linux/audit.h~fs-add-link-restriction-audit-reporting include/linux/audit.h
--- a/include/linux/audit.h~fs-add-link-restriction-audit-reporting
+++ a/include/linux/audit.h
@@ -130,6 +130,7 @@
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
 #define AUDIT_ANOM_ABEND            1701 /* Process ended abnormally */
+#define AUDIT_ANOM_LINK		    1702 /* Suspicious use of file links */
 #define AUDIT_INTEGRITY_DATA	    1800 /* Data integrity verification */
 #define AUDIT_INTEGRITY_METADATA    1801 /* Metadata integrity verification */
 #define AUDIT_INTEGRITY_STATUS	    1802 /* Integrity enable status */
@@ -687,6 +688,8 @@ extern void		    audit_log_d_path(struct
 					     const struct path *path);
 extern void		    audit_log_key(struct audit_buffer *ab,
 					  char *key);
+extern void		    audit_log_link_denied(const char *operation,
+						  struct path *link);
 extern void		    audit_log_lost(const char *message);
 #ifdef CONFIG_SECURITY
 extern void 		    audit_log_secctx(struct audit_buffer *ab, u32 secid);
@@ -716,6 +719,7 @@ extern int audit_enabled;
 #define audit_log_untrustedstring(a,s) do { ; } while (0)
 #define audit_log_d_path(b, p, d) do { ; } while (0)
 #define audit_log_key(b, k) do { ; } while (0)
+#define audit_log_link_denied(o, l) do { ; } while (0)
 #define audit_log_secctx(b,s) do { ; } while (0)
 #define audit_enabled 0
 #endif
diff -puN kernel/audit.c~fs-add-link-restriction-audit-reporting kernel/audit.c
--- a/kernel/audit.c~fs-add-link-restriction-audit-reporting
+++ a/kernel/audit.c
@@ -1453,6 +1453,27 @@ void audit_log_key(struct audit_buffer *
 }
 
 /**
+ * audit_log_link_denied - report a link restriction denial
+ * @operation: specific link opreation
+ * @link: the path that triggered the restriction
+ */
+void audit_log_link_denied(const char *operation, struct path *link)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL,
+			     AUDIT_ANOM_LINK);
+	audit_log_format(ab, "op=%s action=denied", operation);
+	audit_log_format(ab, " pid=%d comm=", current->pid);
+	audit_log_untrustedstring(ab, current->comm);
+	audit_log_d_path(ab, " path=", link);
+	audit_log_format(ab, " dev=");
+	audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_id);
+	audit_log_format(ab, " ino=%lu", link->dentry->d_inode->i_ino);
+	audit_log_end(ab);
+}
+
+/**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
  *
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch
prctl-remove-redunant-assignment-of-error-to-zero.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch

