From: akpm@linux-foundation.org
Subject: + lsm-audit-introduce-generic-audit-lsm-hooks.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:41:51 -0800
Message-ID: <200803030741.m237fpvc005098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbYCCHrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:47:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schaufler-ca.com, chrisw@sous-sol.org, dwmw2@infradead.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     LSM/Audit: Introduce generic Audit LSM hooks
has been added to the -mm tree.  Its filename is
     lsm-audit-introduce-generic-audit-lsm-hooks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: LSM/Audit: Introduce generic Audit LSM hooks
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Introduce a generic Audit interface for security modules by adding the
following new LSM hooks:

audit_rule_init(field, op, rulestr, lsmrule)
audit_rule_known(krule)
audit_rule_match(secid, field, op, rule, actx)
audit_rule_free(rule)

Those hooks are only available if CONFIG_AUDIT is enabled.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |   72 +++++++++++++++++++++++++++++++++++++
 security/dummy.c         |   31 +++++++++++++++
 security/security.c      |   25 ++++++++++++
 3 files changed, 127 insertions(+), 1 deletion(-)

diff -puN include/linux/security.h~lsm-audit-introduce-generic-audit-lsm-hooks include/linux/security.h
--- a/include/linux/security.h~lsm-audit-introduce-generic-audit-lsm-hooks
+++ a/include/linux/security.h
@@ -41,6 +41,7 @@
 #define DEFCONTEXT_MNT		0x08
 
 struct ctl_table;
+struct audit_krule;
 
 /*
  * These functions are in security/capability.c and are used
@@ -1218,6 +1219,37 @@ struct request_sock;
  *	@secdata contains the security context.
  *	@seclen contains the length of the security context.
  *
+ * Security hooks for Audit
+ *
+ * @audit_rule_init:
+ *	Allocate and initialize an LSM audit rule structure.
+ *	@field contains the required Audit action. Fields flags are defined in include/linux/audit.h
+ *	@op contains the operator the rule uses.
+ *	@rulestr contains the context where the rule will be applied to.
+ *	@lsmrule contains a pointer to receive the result.
+ *	Return 0 if @lsmrule has been successfully set,
+ *	-EINVAL in case of an invalid rule.
+ *
+ * @audit_rule_known:
+ *	Specifies whether given @rule contains any fields related to current LSM.
+ *	@rule contains the audit rule of interest.
+ *	Return 1 in case of relation found, 0 otherwise.
+ *
+ * @audit_rule_match:
+ *	Determine if given @secid matches a rule previously approved
+ *	by @audit_rule_known.
+ *	@secid contains the security id in question.
+ *	@field contains the field which relates to current LSM.
+ *	@op contains the operator that will be used for matching.
+ *	@rule points to the audit rule that will be checked against.
+ *	@actx points to the audit context associated with the check.
+ *	Return 1 if secid matches the rule, 0 if it does not, -ERRNO on failure.
+ *
+ * @audit_rule_free:
+ *	Deallocate the LSM audit rule structure previously allocated by
+ *	audit_rule_init.
+ *	@rule contains the allocated rule
+ *
  * This is the main security structure.
  */
 struct security_operations {
@@ -1478,6 +1510,13 @@ struct security_operations {
 
 #endif	/* CONFIG_KEYS */
 
+#ifdef CONFIG_AUDIT
+	int (*audit_rule_init)(u32 field, u32 op, char *rulestr, void **lsmrule);
+	int (*audit_rule_known)(struct audit_krule *krule);
+	int (*audit_rule_match)(u32 secid, u32 field, u32 op, void *lsmrule,
+				struct audit_context *actx);
+	void (*audit_rule_free)(void *lsmrule);
+#endif /* CONFIG_AUDIT */
 };
 
 /* prototypes */
@@ -2654,5 +2693,38 @@ static inline int security_key_permissio
 #endif
 #endif /* CONFIG_KEYS */
 
+#ifdef CONFIG_AUDIT
+#ifdef CONFIG_SECURITY
+int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule);
+int security_audit_rule_known(struct audit_krule *krule);
+int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
+			      struct audit_context *actx);
+void security_audit_rule_free(void *lsmrule);
+
+#else
+
+static inline int security_audit_rule_init(u32 field, u32 op, char *rulestr,
+					   void **lsmrule)
+{
+	return 0;
+}
+
+static inline int security_audit_rule_known(struct audit_krule *krule)
+{
+	return 0;
+}
+
+static inline int security_audit_rule_match(u32 secid, u32 field, u32 op,
+				   void *lsmrule, struct audit_context *actx)
+{
+	return 0;
+}
+
+static inline void security_audit_rule_free(void *lsmrule)
+{ }
+
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_AUDIT */
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff -puN security/dummy.c~lsm-audit-introduce-generic-audit-lsm-hooks security/dummy.c
--- a/security/dummy.c~lsm-audit-introduce-generic-audit-lsm-hooks
+++ a/security/dummy.c
@@ -991,6 +991,30 @@ static inline int dummy_key_permission(k
 }
 #endif /* CONFIG_KEYS */
 
+#ifdef CONFIG_AUDIT
+static inline int dummy_audit_rule_init(u32 field, u32 op, char *rulestr,
+					void **lsmrule)
+{
+	return 0;
+}
+
+static inline int dummy_audit_rule_known(struct audit_krule *krule)
+{
+	return 0;
+}
+
+static inline int dummy_audit_rule_match(u32 secid, u32 field, u32 op,
+					 void *lsmrule,
+					 struct audit_context *actx)
+{
+	return 0;
+}
+
+static inline void dummy_audit_rule_free(void *lsmrule)
+{ }
+
+#endif /* CONFIG_AUDIT */
+
 struct security_operations dummy_security_ops;
 
 #define set_to_dummy_if_null(ops, function)				\
@@ -1179,6 +1203,11 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, key_free);
 	set_to_dummy_if_null(ops, key_permission);
 #endif	/* CONFIG_KEYS */
-
+#ifdef CONFIG_AUDIT
+	set_to_dummy_if_null(ops, audit_rule_init);
+	set_to_dummy_if_null(ops, audit_rule_known);
+	set_to_dummy_if_null(ops, audit_rule_match);
+	set_to_dummy_if_null(ops, audit_rule_free);
+#endif
 }
 
diff -puN security/security.c~lsm-audit-introduce-generic-audit-lsm-hooks security/security.c
--- a/security/security.c~lsm-audit-introduce-generic-audit-lsm-hooks
+++ a/security/security.c
@@ -1113,3 +1113,28 @@ int security_key_permission(key_ref_t ke
 }
 
 #endif	/* CONFIG_KEYS */
+
+#ifdef CONFIG_AUDIT
+
+int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
+{
+	return security_ops->audit_rule_init(field, op, rulestr, lsmrule);
+}
+
+int security_audit_rule_known(struct audit_krule *krule)
+{
+	return security_ops->audit_rule_known(krule);
+}
+
+void security_audit_rule_free(void *lsmrule)
+{
+	security_ops->audit_rule_free(lsmrule);
+}
+
+int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
+			      struct audit_context *actx)
+{
+	return security_ops->audit_rule_match(secid, field, op, lsmrule, actx);
+}
+
+#endif /* CONFIG_AUDIT */
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks.patch
selinux-setup-new-inode-ipc-getsecid-hooks.patch
audit-use-new-lsm-hooks-instead-of-selinux-exports.patch
netlink-use-generic-lsm-hook.patch
selinux-remove-redundant-exports.patch
lsm-audit-introduce-generic-audit-lsm-hooks.patch
audit-internally-use-the-new-lsm-audit-hooks.patch
selinux-use-new-audit-hooks-remove-redundant-exports.patch
audit-final-renamings-and-cleanup.patch

