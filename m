From: akpm@linux-foundation.org
Subject: [merged] audit-catch-possible-null-audit-buffers.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:39:07 -0800
Message-ID: <20130114203908.45C87200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:36832 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3ANUjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:39:11 -0500
Received: by mail-ee0-f74.google.com with SMTP id l10so201199eei.5
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:39:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, aarcange@redhat.com, ebiederm@xmission.com, eparis@redhat.com, jlayton@redhat.com, jln@google.com, sgrubb@redhat.com, viro@zeniv.linux.org.uk, wad@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: audit: catch possible NULL audit buffers
has been removed from the -mm tree.  Its filename was
     audit-catch-possible-null-audit-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: audit: catch possible NULL audit buffers

It's possible for audit_log_start() to return NULL.  Handle it in the
various callers.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Julien Tinnes <jln@google.com>
Cc: Will Drewry <wad@google.com>
Cc: Steve Grubb <sgrubb@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c       |    4 ++++
 kernel/audit_tree.c  |   26 +++++++++++++++++---------
 kernel/audit_watch.c |    2 ++
 kernel/auditsc.c     |    6 ++++--
 4 files changed, 27 insertions(+), 11 deletions(-)

diff -puN kernel/audit.c~audit-catch-possible-null-audit-buffers kernel/audit.c
--- a/kernel/audit.c~audit-catch-possible-null-audit-buffers
+++ a/kernel/audit.c
@@ -272,6 +272,8 @@ static int audit_log_config_change(char 
 	int rc = 0;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	if (unlikely(!ab))
+		return rc;
 	audit_log_format(ab, "%s=%d old=%d auid=%u ses=%u", function_name, new,
 			 old, from_kuid(&init_user_ns, loginuid), sessionid);
 	if (sid) {
@@ -619,6 +621,8 @@ static int audit_log_common_recv_msg(str
 	}
 
 	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
+	if (unlikely(!*ab))
+		return rc;
 	audit_log_format(*ab, "pid=%d uid=%u auid=%u ses=%u",
 			 task_tgid_vnr(current),
 			 from_kuid(&init_user_ns, current_uid()),
diff -puN kernel/audit_tree.c~audit-catch-possible-null-audit-buffers kernel/audit_tree.c
--- a/kernel/audit_tree.c~audit-catch-possible-null-audit-buffers
+++ a/kernel/audit_tree.c
@@ -449,11 +449,26 @@ static int tag_chunk(struct inode *inode
 	return 0;
 }
 
+static void audit_log_remove_rule(struct audit_krule *rule)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	if (unlikely(!ab))
+		return;
+	audit_log_format(ab, "op=");
+	audit_log_string(ab, "remove rule");
+	audit_log_format(ab, " dir=");
+	audit_log_untrustedstring(ab, rule->tree->pathname);
+	audit_log_key(ab, rule->filterkey);
+	audit_log_format(ab, " list=%d res=1", rule->listnr);
+	audit_log_end(ab);
+}
+
 static void kill_rules(struct audit_tree *tree)
 {
 	struct audit_krule *rule, *next;
 	struct audit_entry *entry;
-	struct audit_buffer *ab;
 
 	list_for_each_entry_safe(rule, next, &tree->rules, rlist) {
 		entry = container_of(rule, struct audit_entry, rule);
@@ -461,14 +476,7 @@ static void kill_rules(struct audit_tree
 		list_del_init(&rule->rlist);
 		if (rule->tree) {
 			/* not a half-baked one */
-			ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
-			audit_log_format(ab, "op=");
-			audit_log_string(ab, "remove rule");
-			audit_log_format(ab, " dir=");
-			audit_log_untrustedstring(ab, rule->tree->pathname);
-			audit_log_key(ab, rule->filterkey);
-			audit_log_format(ab, " list=%d res=1", rule->listnr);
-			audit_log_end(ab);
+			audit_log_remove_rule(rule);
 			rule->tree = NULL;
 			list_del_rcu(&entry->list);
 			list_del(&entry->rule.list);
diff -puN kernel/audit_watch.c~audit-catch-possible-null-audit-buffers kernel/audit_watch.c
--- a/kernel/audit_watch.c~audit-catch-possible-null-audit-buffers
+++ a/kernel/audit_watch.c
@@ -240,6 +240,8 @@ static void audit_watch_log_rule_change(
 	if (audit_enabled) {
 		struct audit_buffer *ab;
 		ab = audit_log_start(NULL, GFP_NOFS, AUDIT_CONFIG_CHANGE);
+		if (unlikely(!ab))
+			return;
 		audit_log_format(ab, "auid=%u ses=%u op=",
 				 from_kuid(&init_user_ns, audit_get_loginuid(current)),
 				 audit_get_sessionid(current));
diff -puN kernel/auditsc.c~audit-catch-possible-null-audit-buffers kernel/auditsc.c
--- a/kernel/auditsc.c~audit-catch-possible-null-audit-buffers
+++ a/kernel/auditsc.c
@@ -1464,14 +1464,14 @@ static void show_special(struct audit_co
 			audit_log_end(ab);
 			ab = audit_log_start(context, GFP_KERNEL,
 					     AUDIT_IPC_SET_PERM);
+			if (unlikely(!ab))
+				return;
 			audit_log_format(ab,
 				"qbytes=%lx ouid=%u ogid=%u mode=%#ho",
 				context->ipc.qbytes,
 				context->ipc.perm_uid,
 				context->ipc.perm_gid,
 				context->ipc.perm_mode);
-			if (!ab)
-				return;
 		}
 		break; }
 	case AUDIT_MQ_OPEN: {
@@ -2720,6 +2720,8 @@ void audit_core_dumps(long signr)
 		return;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
+	if (unlikely(!ab))
+		return;
 	audit_log_abend(ab, "memory violation", signr);
 	audit_log_end(ab);
 }
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

