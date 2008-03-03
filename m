From: akpm@linux-foundation.org
Subject: + audit-final-renamings-and-cleanup.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:41:57 -0800
Message-ID: <200803030741.m237fvZC005107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbYCCHoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:44:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schaufler-ca.com, chrisw@sous-sol.org, dwmw2@infradead.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     Audit: Final renamings and cleanup
has been added to the -mm tree.  Its filename is
     audit-final-renamings-and-cleanup.patch

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
Subject: Audit: Final renamings and cleanup
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Rename the se_str and se_rule audit fields elements to lsm_str and lsm_rule to
avoid confusion.

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

 include/linux/audit.h |    4 ++--
 kernel/auditfilter.c  |   40 ++++++++++++++++++++--------------------
 kernel/auditsc.c      |   12 ++++++------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff -puN include/linux/audit.h~audit-final-renamings-and-cleanup include/linux/audit.h
--- a/include/linux/audit.h~audit-final-renamings-and-cleanup
+++ a/include/linux/audit.h
@@ -377,8 +377,8 @@ struct audit_field {
 	u32				type;
 	u32				val;
 	u32				op;
-	char				*se_str;
-	void				*se_rule;
+	char				*lsm_str;
+	void				*lsm_rule;
 };
 
 #define AUDITSC_INVALID 0
diff -puN kernel/auditfilter.c~audit-final-renamings-and-cleanup kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-final-renamings-and-cleanup
+++ a/kernel/auditfilter.c
@@ -139,8 +139,8 @@ static inline void audit_free_rule(struc
 	if (e->rule.fields)
 		for (i = 0; i < e->rule.field_count; i++) {
 			struct audit_field *f = &e->rule.fields[i];
-			kfree(f->se_str);
-			security_audit_rule_free(f->se_rule);
+			kfree(f->lsm_str);
+			security_audit_rule_free(f->lsm_rule);
 		}
 	kfree(e->rule.fields);
 	kfree(e->rule.filterkey);
@@ -554,8 +554,8 @@ static struct audit_entry *audit_data_to
 		f->op = data->fieldflags[i] & AUDIT_OPERATORS;
 		f->type = data->fields[i];
 		f->val = data->values[i];
-		f->se_str = NULL;
-		f->se_rule = NULL;
+		f->lsm_str = NULL;
+		f->lsm_rule = NULL;
 		switch(f->type) {
 		case AUDIT_PID:
 		case AUDIT_UID:
@@ -598,7 +598,7 @@ static struct audit_entry *audit_data_to
 			entry->rule.buflen += f->val;
 
 			err = security_audit_rule_init(f->type, f->op, str,
-						       (void **)&f->se_rule);
+						       (void **)&f->lsm_rule);
 			/* Keep currently invalid fields around in case they
 			 * become valid after a policy reload. */
 			if (err == -EINVAL) {
@@ -610,7 +610,7 @@ static struct audit_entry *audit_data_to
 				kfree(str);
 				goto exit_free;
 			} else
-				f->se_str = str;
+				f->lsm_str = str;
 			break;
 		case AUDIT_WATCH:
 			str = audit_unpack_string(&bufp, &remain, f->val);
@@ -754,7 +754,7 @@ static struct audit_rule_data *audit_kru
 		case AUDIT_OBJ_LEV_LOW:
 		case AUDIT_OBJ_LEV_HIGH:
 			data->buflen += data->values[i] =
-				audit_pack_string(&bufp, f->se_str);
+				audit_pack_string(&bufp, f->lsm_str);
 			break;
 		case AUDIT_WATCH:
 			data->buflen += data->values[i] =
@@ -806,7 +806,7 @@ static int audit_compare_rule(struct aud
 		case AUDIT_OBJ_TYPE:
 		case AUDIT_OBJ_LEV_LOW:
 		case AUDIT_OBJ_LEV_HIGH:
-			if (strcmp(a->fields[i].se_str, b->fields[i].se_str))
+			if (strcmp(a->fields[i].lsm_str, b->fields[i].lsm_str))
 				return 1;
 			break;
 		case AUDIT_WATCH:
@@ -862,28 +862,28 @@ out:
 	return new;
 }
 
-/* Duplicate LSM field information.  The se_rule is opaque, so must be
+/* Duplicate LSM field information.  The lsm_rule is opaque, so must be
  * re-initialized. */
 static inline int audit_dupe_lsm_field(struct audit_field *df,
 					   struct audit_field *sf)
 {
 	int ret = 0;
-	char *se_str;
+	char *lsm_str;
 
-	/* our own copy of se_str */
-	se_str = kstrdup(sf->se_str, GFP_KERNEL);
-	if (unlikely(!se_str))
+	/* our own copy of lsm_str */
+	lsm_str = kstrdup(sf->lsm_str, GFP_KERNEL);
+	if (unlikely(!lsm_str))
 		return -ENOMEM;
-	df->se_str = se_str;
+	df->lsm_str = lsm_str;
 
-	/* our own (refreshed) copy of se_rule */
-	ret = security_audit_rule_init(df->type, df->op, df->se_str,
-				       (void **)&df->se_rule);
+	/* our own (refreshed) copy of lsm_rule */
+	ret = security_audit_rule_init(df->type, df->op, df->lsm_str,
+				       (void **)&df->lsm_rule);
 	/* Keep currently invalid fields around in case they
 	 * become valid after a policy reload. */
 	if (ret == -EINVAL) {
 		printk(KERN_WARNING "audit rule for LSM \'%s\' is "
-		       "invalid\n", df->se_str);
+		       "invalid\n", df->lsm_str);
 		ret = 0;
 	}
 
@@ -930,7 +930,7 @@ static struct audit_entry *audit_dupe_ru
 	new->tree = old->tree;
 	memcpy(new->fields, old->fields, sizeof(struct audit_field) * fcount);
 
-	/* deep copy this information, updating the se_rule fields, because
+	/* deep copy this information, updating the lsm_rule fields, because
 	 * the originals will all be freed when the old rule is freed. */
 	for (i = 0; i < fcount; i++) {
 		switch (new->fields[i].type) {
@@ -1762,7 +1762,7 @@ unlock_and_return:
 	return result;
 }
 
-/* This function will re-initialize the se_rule field of all applicable rules.
+/* This function will re-initialize the lsm_rule field of all applicable rules.
  * It will traverse the filter lists serarching for rules that contain LSM
  * specific filter fields.  When such a rule is found, it is copied, the
  * LSM field is re-initialized, and the old rule is replaced with the
diff -puN kernel/auditsc.c~audit-final-renamings-and-cleanup kernel/auditsc.c
--- a/kernel/auditsc.c~audit-final-renamings-and-cleanup
+++ a/kernel/auditsc.c
@@ -527,14 +527,14 @@ static int audit_filter_rules(struct tas
 			   match for now to avoid losing information that
 			   may be wanted.   An error message will also be
 			   logged upon error */
-			if (f->se_rule) {
+			if (f->lsm_rule) {
 				if (need_sid) {
 					security_task_getsecid(tsk, &sid);
 					need_sid = 0;
 				}
 				result = security_audit_rule_match(sid, f->type,
 				                                  f->op,
-				                                  f->se_rule,
+				                                  f->lsm_rule,
 				                                  ctx);
 			}
 			break;
@@ -545,18 +545,18 @@ static int audit_filter_rules(struct tas
 		case AUDIT_OBJ_LEV_HIGH:
 			/* The above note for AUDIT_SUBJ_USER...AUDIT_SUBJ_CLR
 			   also applies here */
-			if (f->se_rule) {
+			if (f->lsm_rule) {
 				/* Find files that match */
 				if (name) {
 					result = security_audit_rule_match(
 					           name->osid, f->type, f->op,
-					           f->se_rule, ctx);
+					           f->lsm_rule, ctx);
 				} else if (ctx) {
 					for (j = 0; j < ctx->name_count; j++) {
 						if (security_audit_rule_match(
 						      ctx->names[j].osid,
 						      f->type, f->op,
-						      f->se_rule, ctx)) {
+						      f->lsm_rule, ctx)) {
 							++result;
 							break;
 						}
@@ -569,7 +569,7 @@ static int audit_filter_rules(struct tas
 					     aux = aux->next) {
 						if (aux->type == AUDIT_IPC) {
 							struct audit_aux_data_ipcctl *axi = (void *)aux;
-							if (security_audit_rule_match(axi->osid, f->type, f->op, f->se_rule, ctx)) {
+							if (security_audit_rule_match(axi->osid, f->type, f->op, f->lsm_rule, ctx)) {
 								++result;
 								break;
 							}
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

