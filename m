From: akpm@linux-foundation.org
Subject: - selinux-use-new-audit-hooks-remove-redundant-exports.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:27 -0800
Message-ID: <200803062223.m26MNRuC020892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998AbYCFW0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:26:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, casey@schaufler-ca.com, chrisw@sous-sol.org, dwmw2@infradead.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, viro@zeniv.linux


The patch titled
     SELinux: use new audit hooks, remove redundant exports
has been removed from the -mm tree.  Its filename was
     selinux-use-new-audit-hooks-remove-redundant-exports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SELinux: use new audit hooks, remove redundant exports
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Setup the new Audit LSM hooks for SELinux.  Remove the now redundant exported
SELinux Audit interface.

Audit: Export 'audit_krule' and 'audit_field' to the public
since their internals are needed by the implementation of the
new LSM hook 'audit_rule_known'.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Acked-by: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/audit.h            |   29 +++++++++++
 include/linux/selinux.h          |   72 -----------------------------
 kernel/audit.h                   |   25 ----------
 security/selinux/hooks.c         |    8 +++
 security/selinux/include/audit.h |   65 ++++++++++++++++++++++++++
 security/selinux/ss/services.c   |   45 +++++++++++++-----
 6 files changed, 136 insertions(+), 108 deletions(-)

diff -puN include/linux/audit.h~selinux-use-new-audit-hooks-remove-redundant-exports include/linux/audit.h
--- a/include/linux/audit.h~selinux-use-new-audit-hooks-remove-redundant-exports
+++ a/include/linux/audit.h
@@ -353,6 +353,33 @@ struct netlink_skb_parms;
 struct linux_binprm;
 struct mq_attr;
 struct mqstat;
+struct audit_watch;
+struct audit_tree;
+
+struct audit_krule {
+	int			vers_ops;
+	u32			flags;
+	u32			listnr;
+	u32			action;
+	u32			mask[AUDIT_BITMASK_SIZE];
+	u32			buflen; /* for data alloc on list rules */
+	u32			field_count;
+	char			*filterkey; /* ties events to rules */
+	struct audit_field	*fields;
+	struct audit_field	*arch_f; /* quick access to arch field */
+	struct audit_field	*inode_f; /* quick access to an inode field */
+	struct audit_watch	*watch;	/* associated watch */
+	struct audit_tree	*tree;	/* associated watched tree */
+	struct list_head	rlist;	/* entry in audit_{watch,tree}.rules list */
+};
+
+struct audit_field {
+	u32				type;
+	u32				val;
+	u32				op;
+	char				*se_str;
+	void				*se_rule;
+};
 
 #define AUDITSC_INVALID 0
 #define AUDITSC_SUCCESS 1
@@ -536,6 +563,8 @@ extern void		    audit_log_d_path(struct
 					     const char *prefix,
 					     struct path *path);
 extern void		    audit_log_lost(const char *message);
+extern int		    audit_update_lsm_rules(void);
+
 				/* Private API (for audit.c only) */
 extern int audit_filter_user(struct netlink_skb_parms *cb, int type);
 extern int audit_filter_type(int type);
diff -puN include/linux/selinux.h~selinux-use-new-audit-hooks-remove-redundant-exports include/linux/selinux.h
--- a/include/linux/selinux.h~selinux-use-new-audit-hooks-remove-redundant-exports
+++ a/include/linux/selinux.h
@@ -21,54 +21,6 @@ struct kern_ipc_perm;
 #ifdef CONFIG_SECURITY_SELINUX
 
 /**
- *	selinux_audit_rule_init - alloc/init an selinux audit rule structure.
- *	@field: the field this rule refers to
- *	@op: the operater the rule uses
- *	@rulestr: the text "target" of the rule
- *	@rule: pointer to the new rule structure returned via this
- *
- *	Returns 0 if successful, -errno if not.  On success, the rule structure
- *	will be allocated internally.  The caller must free this structure with
- *	selinux_audit_rule_free() after use.
- */
-int selinux_audit_rule_init(u32 field, u32 op, char *rulestr,
-                            struct selinux_audit_rule **rule);
-
-/**
- *	selinux_audit_rule_free - free an selinux audit rule structure.
- *	@rule: pointer to the audit rule to be freed
- *
- *	This will free all memory associated with the given rule.
- *	If @rule is NULL, no operation is performed.
- */
-void selinux_audit_rule_free(struct selinux_audit_rule *rule);
-
-/**
- *	selinux_audit_rule_match - determine if a context ID matches a rule.
- *	@sid: the context ID to check
- *	@field: the field this rule refers to
- *	@op: the operater the rule uses
- *	@rule: pointer to the audit rule to check against
- *	@actx: the audit context (can be NULL) associated with the check
- *
- *	Returns 1 if the context id matches the rule, 0 if it does not, and
- *	-errno on failure.
- */
-int selinux_audit_rule_match(u32 sid, u32 field, u32 op,
-                             struct selinux_audit_rule *rule,
-                             struct audit_context *actx);
-
-/**
- *	selinux_audit_set_callback - set the callback for policy reloads.
- *	@callback: the function to call when the policy is reloaded
- *
- *	This sets the function callback function that will update the rules
- *	upon policy reloads.  This callback should rebuild all existing rules
- *	using selinux_audit_rule_init().
- */
-void selinux_audit_set_callback(int (*callback)(void));
-
-/**
  *     selinux_string_to_sid - map a security context string to a security ID
  *     @str: the security context string to be mapped
  *     @sid: ID value returned via this.
@@ -111,30 +63,6 @@ void selinux_secmark_refcount_inc(void);
 void selinux_secmark_refcount_dec(void);
 #else
 
-static inline int selinux_audit_rule_init(u32 field, u32 op,
-                                          char *rulestr,
-                                          struct selinux_audit_rule **rule)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void selinux_audit_rule_free(struct selinux_audit_rule *rule)
-{
-	return;
-}
-
-static inline int selinux_audit_rule_match(u32 sid, u32 field, u32 op,
-                                           struct selinux_audit_rule *rule,
-                                           struct audit_context *actx)
-{
-	return 0;
-}
-
-static inline void selinux_audit_set_callback(int (*callback)(void))
-{
-	return;
-}
-
 static inline int selinux_string_to_sid(const char *str, u32 *sid)
 {
        *sid = 0;
diff -puN kernel/audit.h~selinux-use-new-audit-hooks-remove-redundant-exports kernel/audit.h
--- a/kernel/audit.h~selinux-use-new-audit-hooks-remove-redundant-exports
+++ a/kernel/audit.h
@@ -65,34 +65,9 @@ struct audit_watch {
 	struct list_head	rules;	/* associated rules */
 };
 
-struct audit_field {
-	u32				type;
-	u32				val;
-	u32				op;
-	char				*se_str;
-	struct selinux_audit_rule	*se_rule;
-};
-
 struct audit_tree;
 struct audit_chunk;
 
-struct audit_krule {
-	int			vers_ops;
-	u32			flags;
-	u32			listnr;
-	u32			action;
-	u32			mask[AUDIT_BITMASK_SIZE];
-	u32			buflen; /* for data alloc on list rules */
-	u32			field_count;
-	char			*filterkey; /* ties events to rules */
-	struct audit_field	*fields;
-	struct audit_field	*arch_f; /* quick access to arch field */
-	struct audit_field	*inode_f; /* quick access to an inode field */
-	struct audit_watch	*watch;	/* associated watch */
-	struct audit_tree	*tree;	/* associated watched tree */
-	struct list_head	rlist;	/* entry in audit_{watch,tree}.rules list */
-};
-
 struct audit_entry {
 	struct list_head	list;
 	struct rcu_head		rcu;
diff -puN security/selinux/hooks.c~selinux-use-new-audit-hooks-remove-redundant-exports security/selinux/hooks.c
--- a/security/selinux/hooks.c~selinux-use-new-audit-hooks-remove-redundant-exports
+++ a/security/selinux/hooks.c
@@ -82,6 +82,7 @@
 #include "netnode.h"
 #include "xfrm.h"
 #include "netlabel.h"
+#include "audit.h"
 
 #define XATTR_SELINUX_SUFFIX "selinux"
 #define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
@@ -5437,6 +5438,13 @@ static struct security_operations selinu
 	.key_free =                     selinux_key_free,
 	.key_permission =               selinux_key_permission,
 #endif
+
+#ifdef CONFIG_AUDIT
+	.audit_rule_init =		selinux_audit_rule_init,
+	.audit_rule_known =		selinux_audit_rule_known,
+	.audit_rule_match =		selinux_audit_rule_match,
+	.audit_rule_free =		selinux_audit_rule_free,
+#endif
 };
 
 static __init int selinux_init(void)
diff -puN /dev/null security/selinux/include/audit.h
--- /dev/null
+++ a/security/selinux/include/audit.h
@@ -0,0 +1,65 @@
+/*
+ * SELinux support for the Audit LSM hooks
+ *
+ * Most of below header was moved from include/linux/selinux.h which
+ * is released under below copyrights:
+ *
+ * Author: James Morris <jmorris@redhat.com>
+ *
+ * Copyright (C) 2005 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ * Copyright (C) 2006 Trusted Computer Solutions, Inc. <dgoeddel@trustedcs.com>
+ * Copyright (C) 2006 IBM Corporation, Timothy R. Chavez <tinytim@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2,
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef _SELINUX_AUDIT_H
+#define _SELINUX_AUDIT_H
+
+/**
+ *	selinux_audit_rule_init - alloc/init an selinux audit rule structure.
+ *	@field: the field this rule refers to
+ *	@op: the operater the rule uses
+ *	@rulestr: the text "target" of the rule
+ *	@rule: pointer to the new rule structure returned via this
+ *
+ *	Returns 0 if successful, -errno if not.  On success, the rule structure
+ *	will be allocated internally.  The caller must free this structure with
+ *	selinux_audit_rule_free() after use.
+ */
+int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **rule);
+
+/**
+ *	selinux_audit_rule_free - free an selinux audit rule structure.
+ *	@rule: pointer to the audit rule to be freed
+ *
+ *	This will free all memory associated with the given rule.
+ *	If @rule is NULL, no operation is performed.
+ */
+void selinux_audit_rule_free(void *rule);
+
+/**
+ *	selinux_audit_rule_match - determine if a context ID matches a rule.
+ *	@sid: the context ID to check
+ *	@field: the field this rule refers to
+ *	@op: the operater the rule uses
+ *	@rule: pointer to the audit rule to check against
+ *	@actx: the audit context (can be NULL) associated with the check
+ *
+ *	Returns 1 if the context id matches the rule, 0 if it does not, and
+ *	-errno on failure.
+ */
+int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *rule,
+                             struct audit_context *actx);
+
+/**
+ *	selinux_audit_rule_known - check to see if rule contains selinux fields.
+ *	@rule: rule to be checked
+ *	Returns 1 if there are selinux fields specified in the rule, 0 otherwise.
+ */
+int selinux_audit_rule_known(struct audit_krule *krule);
+
+#endif /* _SELINUX_AUDIT_H */
+
diff -puN security/selinux/ss/services.c~selinux-use-new-audit-hooks-remove-redundant-exports security/selinux/ss/services.c
--- a/security/selinux/ss/services.c~selinux-use-new-audit-hooks-remove-redundant-exports
+++ a/security/selinux/ss/services.c
@@ -56,6 +56,7 @@
 #include "netlabel.h"
 #include "xfrm.h"
 #include "ebitmap.h"
+#include "audit.h"
 
 extern void selnl_notify_policyload(u32 seqno);
 unsigned int policydb_loaded_version;
@@ -2274,21 +2275,23 @@ struct selinux_audit_rule {
 	struct context au_ctxt;
 };
 
-void selinux_audit_rule_free(struct selinux_audit_rule *rule)
+void selinux_audit_rule_free(void *vrule)
 {
+	struct selinux_audit_rule *rule = vrule;
+
 	if (rule) {
 		context_destroy(&rule->au_ctxt);
 		kfree(rule);
 	}
 }
 
-int selinux_audit_rule_init(u32 field, u32 op, char *rulestr,
-                            struct selinux_audit_rule **rule)
+int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
 {
 	struct selinux_audit_rule *tmprule;
 	struct role_datum *roledatum;
 	struct type_datum *typedatum;
 	struct user_datum *userdatum;
+	struct selinux_audit_rule **rule = (struct selinux_audit_rule **)vrule;
 	int rc = 0;
 
 	*rule = NULL;
@@ -2375,12 +2378,37 @@ int selinux_audit_rule_init(u32 field, u
 	return rc;
 }
 
-int selinux_audit_rule_match(u32 sid, u32 field, u32 op,
-                             struct selinux_audit_rule *rule,
+/* Check to see if the rule contains any selinux fields */
+int selinux_audit_rule_known(struct audit_krule *rule)
+{
+	int i;
+
+	for (i = 0; i < rule->field_count; i++) {
+		struct audit_field *f = &rule->fields[i];
+		switch (f->type) {
+		case AUDIT_SUBJ_USER:
+		case AUDIT_SUBJ_ROLE:
+		case AUDIT_SUBJ_TYPE:
+		case AUDIT_SUBJ_SEN:
+		case AUDIT_SUBJ_CLR:
+		case AUDIT_OBJ_USER:
+		case AUDIT_OBJ_ROLE:
+		case AUDIT_OBJ_TYPE:
+		case AUDIT_OBJ_LEV_LOW:
+		case AUDIT_OBJ_LEV_HIGH:
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule,
                              struct audit_context *actx)
 {
 	struct context *ctxt;
 	struct mls_level *level;
+	struct selinux_audit_rule *rule = vrule;
 	int match = 0;
 
 	if (!rule) {
@@ -2487,7 +2515,7 @@ out:
 	return match;
 }
 
-static int (*aurule_callback)(void) = NULL;
+static int (*aurule_callback)(void) = audit_update_lsm_rules;
 
 static int aurule_avc_callback(u32 event, u32 ssid, u32 tsid,
                                u16 class, u32 perms, u32 *retained)
@@ -2512,11 +2540,6 @@ static int __init aurule_init(void)
 }
 __initcall(aurule_init);
 
-void selinux_audit_set_callback(int (*callback)(void))
-{
-	aurule_callback = callback;
-}
