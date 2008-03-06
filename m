From: akpm@linux-foundation.org
Subject: - audit-internally-use-the-new-lsm-audit-hooks.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:24 -0800
Message-ID: <200803062223.m26MNO2T020889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758199AbYCFWkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, casey@schaufler-ca.com, chrisw@sous-sol.org, dwmw2@infradead.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, viro@zeniv.linux


The patch titled
     Audit: internally use the new LSM audit hooks
has been removed from the -mm tree.  Its filename was
     audit-internally-use-the-new-lsm-audit-hooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Audit: internally use the new LSM audit hooks
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Convert Audit to use the new LSM Audit hooks instead of the exported SELinux
interface.

Basically, use:
security_audit_rule_init
secuirty_audit_rule_free
security_audit_rule_known
security_audit_rule_match

instad of (respectively) :
selinux_audit_rule_init
selinux_audit_rule_free
audit_rule_has_selinux
selinux_audit_rule_match

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

 kernel/audit.c       |    7 ----
 kernel/auditfilter.c |   61 +++++++++++------------------------------
 kernel/auditsc.c     |    9 ++----
 3 files changed, 22 insertions(+), 55 deletions(-)

diff -puN kernel/audit.c~audit-internally-use-the-new-lsm-audit-hooks kernel/audit.c
--- a/kernel/audit.c~audit-internally-use-the-new-lsm-audit-hooks
+++ a/kernel/audit.c
@@ -21,7 +21,7 @@
  *
  * Written by Rickard E. (Rik) Faith <faith@redhat.com>
  *
- * Goals: 1) Integrate fully with SELinux.
+ * Goals: 1) Integrate fully with Security Modules.
  *	  2) Minimal run-time overhead:
  *	     a) Minimal when syscall auditing is disabled (audit_enable=0).
  *	     b) Small when syscall auditing is enabled and no audit record
@@ -55,7 +55,6 @@
 #include <net/netlink.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
-#include <linux/selinux.h>
 #include <linux/inotify.h>
 #include <linux/freezer.h>
 #include <linux/tty.h>
@@ -877,10 +876,6 @@ static int __init audit_init(void)
 	audit_enabled = audit_default;
 	audit_ever_enabled |= !!audit_default;
 
-	/* Register the callback with selinux.  This callback will be invoked
-	 * when a new policy is loaded. */
-	selinux_audit_set_callback(&selinux_audit_rule_update);
-
 	audit_log(NULL, GFP_KERNEL, AUDIT_KERNEL, "initialized");
 
 #ifdef CONFIG_AUDITSYSCALL
diff -puN kernel/auditfilter.c~audit-internally-use-the-new-lsm-audit-hooks kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-internally-use-the-new-lsm-audit-hooks
+++ a/kernel/auditfilter.c
@@ -29,7 +29,6 @@
 #include <linux/sched.h>
 #include <linux/inotify.h>
 #include <linux/security.h>
-#include <linux/selinux.h>
 #include "audit.h"
 
 /*
@@ -39,7 +38,7 @@
  * 		Synchronizes writes and blocking reads of audit's filterlist
  * 		data.  Rcu is used to traverse the filterlist and access
  * 		contents of structs audit_entry, audit_watch and opaque
- * 		selinux rules during filtering.  If modified, these structures
+ * 		LSM rules during filtering.  If modified, these structures
  * 		must be copied and replace their counterparts in the filterlist.
  * 		An audit_parent struct is not accessed during filtering, so may
  * 		be written directly provided audit_filter_mutex is held.
@@ -141,7 +140,7 @@ static inline void audit_free_rule(struc
 		for (i = 0; i < e->rule.field_count; i++) {
 			struct audit_field *f = &e->rule.fields[i];
 			kfree(f->se_str);
-			selinux_audit_rule_free(f->se_rule);
+			security_audit_rule_free(f->se_rule);
 		}
 	kfree(e->rule.fields);
 	kfree(e->rule.filterkey);
@@ -598,12 +597,12 @@ static struct audit_entry *audit_data_to
 				goto exit_free;
 			entry->rule.buflen += f->val;
 
-			err = selinux_audit_rule_init(f->type, f->op, str,
-						      &f->se_rule);
+			err = security_audit_rule_init(f->type, f->op, str,
+						       (void **)&f->se_rule);
 			/* Keep currently invalid fields around in case they
 			 * become valid after a policy reload. */
 			if (err == -EINVAL) {
-				printk(KERN_WARNING "audit rule for selinux "
+				printk(KERN_WARNING "audit rule for LSM "
 				       "\'%s\' is invalid\n",  str);
 				err = 0;
 			}
@@ -863,9 +862,9 @@ out:
 	return new;
 }
 
-/* Duplicate selinux field information.  The se_rule is opaque, so must be
+/* Duplicate LSM field information.  The se_rule is opaque, so must be
  * re-initialized. */
-static inline int audit_dupe_selinux_field(struct audit_field *df,
+static inline int audit_dupe_lsm_field(struct audit_field *df,
 					   struct audit_field *sf)
 {
 	int ret = 0;
@@ -878,12 +877,12 @@ static inline int audit_dupe_selinux_fie
 	df->se_str = se_str;
 
 	/* our own (refreshed) copy of se_rule */
-	ret = selinux_audit_rule_init(df->type, df->op, df->se_str,
-				      &df->se_rule);
+	ret = security_audit_rule_init(df->type, df->op, df->se_str,
+				       (void **)&df->se_rule);
 	/* Keep currently invalid fields around in case they
 	 * become valid after a policy reload. */
 	if (ret == -EINVAL) {
-		printk(KERN_WARNING "audit rule for selinux \'%s\' is "
+		printk(KERN_WARNING "audit rule for LSM \'%s\' is "
 		       "invalid\n", df->se_str);
 		ret = 0;
 	}
@@ -892,7 +891,7 @@ static inline int audit_dupe_selinux_fie
 }
 
 /* Duplicate an audit rule.  This will be a deep copy with the exception
- * of the watch - that pointer is carried over.  The selinux specific fields
+ * of the watch - that pointer is carried over.  The LSM specific fields
  * will be updated in the copy.  The point is to be able to replace the old
  * rule with the new rule in the filterlist, then free the old rule.
  * The rlist element is undefined; list manipulations are handled apart from
@@ -945,7 +944,7 @@ static struct audit_entry *audit_dupe_ru
 		case AUDIT_OBJ_TYPE:
 		case AUDIT_OBJ_LEV_LOW:
 		case AUDIT_OBJ_LEV_HIGH:
-			err = audit_dupe_selinux_field(&new->fields[i],
+			err = audit_dupe_lsm_field(&new->fields[i],
 						       &old->fields[i]);
 			break;
 		case AUDIT_FILTERKEY:
@@ -1763,38 +1762,12 @@ unlock_and_return:
 	return result;
 }
 
-/* Check to see if the rule contains any selinux fields.  Returns 1 if there
-   are selinux fields specified in the rule, 0 otherwise. */
-static inline int audit_rule_has_selinux(struct audit_krule *rule)
-{
-	int i;
-
-	for (i = 0; i < rule->field_count; i++) {
-		struct audit_field *f = &rule->fields[i];
-		switch (f->type) {
-		case AUDIT_SUBJ_USER:
-		case AUDIT_SUBJ_ROLE:
-		case AUDIT_SUBJ_TYPE:
-		case AUDIT_SUBJ_SEN:
-		case AUDIT_SUBJ_CLR:
-		case AUDIT_OBJ_USER:
-		case AUDIT_OBJ_ROLE:
-		case AUDIT_OBJ_TYPE:
-		case AUDIT_OBJ_LEV_LOW:
-		case AUDIT_OBJ_LEV_HIGH:
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
 /* This function will re-initialize the se_rule field of all applicable rules.
- * It will traverse the filter lists serarching for rules that contain selinux
+ * It will traverse the filter lists serarching for rules that contain LSM
  * specific filter fields.  When such a rule is found, it is copied, the
- * selinux field is re-initialized, and the old rule is replaced with the
+ * LSM field is re-initialized, and the old rule is replaced with the
  * updated rule. */
-int selinux_audit_rule_update(void)
+int audit_update_lsm_rules(void)
 {
 	struct audit_entry *entry, *n, *nentry;
 	struct audit_watch *watch;
@@ -1806,7 +1779,7 @@ int selinux_audit_rule_update(void)
 
 	for (i = 0; i < AUDIT_NR_FILTERS; i++) {
 		list_for_each_entry_safe(entry, n, &audit_filter_list[i], list) {
-			if (!audit_rule_has_selinux(&entry->rule))
+			if (!security_audit_rule_known(&entry->rule))
 				continue;
 
 			watch = entry->rule.watch;
@@ -1817,7 +1790,7 @@ int selinux_audit_rule_update(void)
 				 * return value */
 				if (!err)
 					err = PTR_ERR(nentry);
-				audit_panic("error updating selinux filters");
+				audit_panic("error updating LSM filters");
 				if (watch)
 					list_del(&entry->rule.rlist);
 				list_del_rcu(&entry->list);
diff -puN kernel/auditsc.c~audit-internally-use-the-new-lsm-audit-hooks kernel/auditsc.c
--- a/kernel/auditsc.c~audit-internally-use-the-new-lsm-audit-hooks
+++ a/kernel/auditsc.c
@@ -61,7 +61,6 @@
 #include <linux/security.h>
 #include <linux/list.h>
 #include <linux/tty.h>
-#include <linux/selinux.h>
 #include <linux/binfmts.h>
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
@@ -533,7 +532,7 @@ static int audit_filter_rules(struct tas
 					security_task_getsecid(tsk, &sid);
 					need_sid = 0;
 				}
-				result = selinux_audit_rule_match(sid, f->type,
+				result = security_audit_rule_match(sid, f->type,
 				                                  f->op,
 				                                  f->se_rule,
 				                                  ctx);
@@ -549,12 +548,12 @@ static int audit_filter_rules(struct tas
 			if (f->se_rule) {
 				/* Find files that match */
 				if (name) {
-					result = selinux_audit_rule_match(
+					result = security_audit_rule_match(
 					           name->osid, f->type, f->op,
 					           f->se_rule, ctx);
 				} else if (ctx) {
 					for (j = 0; j < ctx->name_count; j++) {
-						if (selinux_audit_rule_match(
+						if (security_audit_rule_match(
 						      ctx->names[j].osid,
 						      f->type, f->op,
 						      f->se_rule, ctx)) {
@@ -570,7 +569,7 @@ static int audit_filter_rules(struct tas
 					     aux = aux->next) {
 						if (aux->type == AUDIT_IPC) {
 							struct audit_aux_data_ipcctl *axi = (void *)aux;
-							if (selinux_audit_rule_match(axi->osid, f->type, f->op, f->se_rule, ctx)) {
+							if (security_audit_rule_match(axi->osid, f->type, f->op, f->se_rule, ctx)) {
 								++result;
 								break;
 							}
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-kvm.patch
git-security-testing.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch

