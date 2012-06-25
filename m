From: akpm@linux-foundation.org
Subject: + fs-add-link-restriction-audit-reporting.patch added to -mm tree
Date: Mon, 25 Jun 2012 14:26:59 -0700
Message-ID: <20120625212659.D08FAA0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47176 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2FYV1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jun 2012 17:27:03 -0400
Received: by wgbdt11 with SMTP id dt11so268497wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Jun 2012 14:27:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, eparis@redhat.com, mingo@elte.hu, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: add link restriction audit reporting
has been added to the -mm tree.  Its filename is
     fs-add-link-restriction-audit-reporting.patch

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
@@ -1450,6 +1450,27 @@ void audit_log_key(struct audit_buffer *
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
Subject: Subject: fs: add link restriction audit reporting

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch
fs-add-link-restrictions.patch
fs-add-link-restriction-audit-reporting.patch
fs-introduce-pipe-only-dump-mode-suid_dumpable=3.patch
fs-introduce-pipe-only-dump-mode-suid_dumpable=3-fix.patch

