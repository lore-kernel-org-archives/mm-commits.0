From: akpm@linux-foundation.org
Subject: - netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:11 -0800
Message-ID: <200802052232.m15MWq2n012362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932352AbYBEWnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.moore@hp.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     NetLabel: introduce a new kernel configuration API for NetLabel
has been removed from the -mm tree.  Its filename was
     netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NetLabel: introduce a new kernel configuration API for NetLabel
From: Paul Moore <paul.moore@hp.com>

Add a new set of configuration functions to the NetLabel/LSM API so that
LSMs can perform their own configuration of the NetLabel subsystem without
relying on assistance from userspace.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/netlabel.h             |   47 ++++++-
 net/ipv4/cipso_ipv4.c              |    4 
 net/netlabel/netlabel_cipso_v4.c   |    2 
 net/netlabel/netlabel_cipso_v4.h   |    3 
 net/netlabel/netlabel_domainhash.h |    1 
 net/netlabel/netlabel_kapi.c       |  177 +++++++++++++++++++++++++++
 6 files changed, 225 insertions(+), 9 deletions(-)

diff -puN include/net/netlabel.h~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel include/net/netlabel.h
--- a/include/net/netlabel.h~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel
+++ a/include/net/netlabel.h
@@ -36,6 +36,8 @@
 #include <net/netlink.h>
 #include <asm/atomic.h>
 
+struct cipso_v4_doi;
+
 /*
  * NetLabel - A management interface for maintaining network packet label
  *            mapping tables for explicit packet labling protocols.
@@ -103,12 +105,6 @@ struct netlbl_audit {
 	uid_t loginuid;
 };
 
-/* Domain mapping definition struct */
-struct netlbl_dom_map;
-
-/* Domain mapping operations */
-int netlbl_domhsh_remove(const char *domain, struct netlbl_audit *audit_info);
-
 /*
  * LSM security attributes
  */
@@ -344,6 +340,19 @@ static inline void netlbl_secattr_free(s
 
 #ifdef CONFIG_NETLABEL
 /*
+ * LSM configuration operations
+ */
+int netlbl_cfg_map_del(const char *domain, struct netlbl_audit *audit_info);
+int netlbl_cfg_unlbl_add_map(const char *domain,
+			     struct netlbl_audit *audit_info);
+int netlbl_cfg_cipsov4_add(struct cipso_v4_doi *doi_def,
+			   struct netlbl_audit *audit_info);
+int netlbl_cfg_cipsov4_add_map(struct cipso_v4_doi *doi_def,
+			       const char *domain,
+			       struct netlbl_audit *audit_info);
+int netlbl_cfg_cipsov4_del(u32 doi, struct netlbl_audit *audit_info);
+
+/*
  * LSM security attribute operations
  */
 int netlbl_secattr_catmap_walk(struct netlbl_lsm_secattr_catmap *catmap,
@@ -378,6 +387,32 @@ void netlbl_cache_invalidate(void);
 int netlbl_cache_add(const struct sk_buff *skb,
 		     const struct netlbl_lsm_secattr *secattr);
 #else
+static inline int netlbl_cfg_map_del(const char *domain,
+				     struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_unlbl_add_map(const char *domain,
+					   struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_cipsov4_add(struct cipso_v4_doi *doi_def,
+					 struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_cipsov4_add_map(struct cipso_v4_doi *doi_def,
+					     const char *domain,
+					     struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_cipsov4_del(u32 doi,
+					 struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
 static inline int netlbl_secattr_catmap_walk(
 	                              struct netlbl_lsm_secattr_catmap *catmap,
 				      u32 offset)
diff -puN net/ipv4/cipso_ipv4.c~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel net/ipv4/cipso_ipv4.c
--- a/net/ipv4/cipso_ipv4.c~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel
+++ a/net/ipv4/cipso_ipv4.c
@@ -547,8 +547,8 @@ int cipso_v4_doi_remove(u32 doi,
 		rcu_read_lock();
 		list_for_each_entry_rcu(dom_iter, &doi_def->dom_list, list)
 			if (dom_iter->valid)
-				netlbl_domhsh_remove(dom_iter->domain,
-						     audit_info);
+				netlbl_cfg_map_del(dom_iter->domain,
+						   audit_info);
 		rcu_read_unlock();
 		cipso_v4_cache_invalidate();
 		call_rcu(&doi_def->rcu, callback);
diff -puN net/netlabel/netlabel_cipso_v4.c~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel net/netlabel/netlabel_cipso_v4.c
--- a/net/netlabel/netlabel_cipso_v4.c~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel
+++ a/net/netlabel/netlabel_cipso_v4.c
@@ -90,7 +90,7 @@ static const struct nla_policy netlbl_ci
  * safely.
  *
  */
-static void netlbl_cipsov4_doi_free(struct rcu_head *entry)
+void netlbl_cipsov4_doi_free(struct rcu_head *entry)
 {
 	struct cipso_v4_doi *ptr;
 
diff -puN net/netlabel/netlabel_cipso_v4.h~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel net/netlabel/netlabel_cipso_v4.h
--- a/net/netlabel/netlabel_cipso_v4.h~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel
+++ a/net/netlabel/netlabel_cipso_v4.h
@@ -163,4 +163,7 @@ enum {
 /* NetLabel protocol functions */
 int netlbl_cipsov4_genl_init(void);
 
+/* Free the memory associated with a CIPSOv4 DOI definition */
+void netlbl_cipsov4_doi_free(struct rcu_head *entry);
+
 #endif
diff -puN net/netlabel/netlabel_domainhash.h~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel net/netlabel/netlabel_domainhash.h
--- a/net/netlabel/netlabel_domainhash.h~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel
+++ a/net/netlabel/netlabel_domainhash.h
@@ -61,6 +61,7 @@ int netlbl_domhsh_add(struct netlbl_dom_
 		      struct netlbl_audit *audit_info);
 int netlbl_domhsh_add_default(struct netlbl_dom_map *entry,
 			      struct netlbl_audit *audit_info);
+int netlbl_domhsh_remove(const char *domain, struct netlbl_audit *audit_info);
 int netlbl_domhsh_remove_default(struct netlbl_audit *audit_info);
 struct netlbl_dom_map *netlbl_domhsh_getentry(const char *domain);
 int netlbl_domhsh_walk(u32 *skip_bkt,
diff -puN net/netlabel/netlabel_kapi.c~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel net/netlabel/netlabel_kapi.c
--- a/net/netlabel/netlabel_kapi.c~netlabel-introduce-a-new-kernel-configuration-api-for-netlabel
+++ a/net/netlabel/netlabel_kapi.c
@@ -30,6 +30,7 @@
 
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/audit.h>
 #include <net/ip.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
@@ -38,10 +39,186 @@
 
 #include "netlabel_domainhash.h"
 #include "netlabel_unlabeled.h"
+#include "netlabel_cipso_v4.h"
 #include "netlabel_user.h"
 #include "netlabel_mgmt.h"
 
 /*
+ * Configuration Functions
+ */
+
+/**
+ * netlbl_cfg_map_del - Remove a NetLabel/LSM domain mapping
+ * @domain: the domain mapping to remove
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Removes a NetLabel/LSM domain mapping.  A @domain value of NULL causes the
+ * default domain mapping to be removed.  Returns zero on success, negative
+ * values on failure.
+ *
+ */
+int netlbl_cfg_map_del(const char *domain, struct netlbl_audit *audit_info)
+{
+	return netlbl_domhsh_remove(domain, audit_info);
+}
+
+/**
+ * netlbl_cfg_unlbl_add_map - Add an unlabeled NetLabel/LSM domain mapping
+ * @domain: the domain mapping to add
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Adds a new unlabeled NetLabel/LSM domain mapping.  A @domain value of NULL
+ * causes a new default domain mapping to be added.  Returns zero on success,
+ * negative values on failure.
+ *
+ */
+int netlbl_cfg_unlbl_add_map(const char *domain,
+			     struct netlbl_audit *audit_info)
+{
+	int ret_val = -ENOMEM;
+	struct netlbl_dom_map *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (entry == NULL)
+		goto cfg_unlbl_add_map_failure;
+	if (domain != NULL) {
+		entry->domain = kstrdup(domain, GFP_ATOMIC);
+		if (entry->domain == NULL)
+			goto cfg_unlbl_add_map_failure;
+	}
+	entry->type = NETLBL_NLTYPE_UNLABELED;
+
+	ret_val = netlbl_domhsh_add(entry, audit_info);
+	if (ret_val != 0)
+		goto cfg_unlbl_add_map_failure;
+
+	return 0;
+
+cfg_unlbl_add_map_failure:
+	if (entry != NULL)
+		kfree(entry->domain);
+	kfree(entry);
+	return ret_val;
+}
+
+/**
+ * netlbl_cfg_cipsov4_add - Add a new CIPSOv4 DOI definition
+ * @doi_def: the DOI definition
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Add a new CIPSOv4 DOI definition to the NetLabel subsystem.  Returns zero on
+ * success, negative values on failure.
+ *
+ */
+int netlbl_cfg_cipsov4_add(struct cipso_v4_doi *doi_def,
+			   struct netlbl_audit *audit_info)
+{
+	int ret_val;
+	const char *type_str;
+	struct audit_buffer *audit_buf;
+
+	ret_val = cipso_v4_doi_add(doi_def);
+
+	audit_buf = netlbl_audit_start_common(AUDIT_MAC_CIPSOV4_ADD,
+					      audit_info);
+	if (audit_buf != NULL) {
+		switch (doi_def->type) {
+		case CIPSO_V4_MAP_STD:
+			type_str = "std";
+			break;
+		case CIPSO_V4_MAP_PASS:
+			type_str = "pass";
+			break;
+		default:
+			type_str = "(unknown)";
+		}
+		audit_log_format(audit_buf,
+				 " cipso_doi=%u cipso_type=%s res=%u",
+				 doi_def->doi,
+				 type_str,
+				 ret_val == 0 ? 1 : 0);
+		audit_log_end(audit_buf);
+	}
+
+	return ret_val;
+}
+
+/**
+ * netlbl_cfg_cipsov4_add_map - Add a new CIPSOv4 DOI definition and mapping
+ * @doi_def: the DOI definition
+ * @domain: the domain mapping to add
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Add a new CIPSOv4 DOI definition and NetLabel/LSM domain mapping for this
+ * new DOI definition to the NetLabel subsystem.  A @domain value of NULL adds
+ * a new default domain mapping.  Returns zero on success, negative values on
+ * failure.
+ *
+ */
+int netlbl_cfg_cipsov4_add_map(struct cipso_v4_doi *doi_def,
+			       const char *domain,
+			       struct netlbl_audit *audit_info)
+{
+	int ret_val = -ENOMEM;
+	struct netlbl_dom_map *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (entry == NULL)
+		goto cfg_cipsov4_add_map_failure;
+	if (domain != NULL) {
+		entry->domain = kstrdup(domain, GFP_ATOMIC);
+		if (entry->domain == NULL)
+			goto cfg_cipsov4_add_map_failure;
+	}
+	entry->type = NETLBL_NLTYPE_CIPSOV4;
+	entry->type_def.cipsov4 = doi_def;
+
+	/* Grab a RCU read lock here so nothing happens to the doi_def variable
+	 * between adding it to the CIPSOv4 protocol engine and adding a
+	 * domain mapping for it. */
+
+	rcu_read_lock();
+	ret_val = netlbl_cfg_cipsov4_add(doi_def, audit_info);
+	if (ret_val != 0)
+		goto cfg_cipsov4_add_map_failure_unlock;
+	ret_val = netlbl_domhsh_add(entry, audit_info);
+	if (ret_val != 0)
+		goto cfg_cipsov4_add_map_failure_remove_doi;
+	rcu_read_unlock();
+
+	return 0;
+
+cfg_cipsov4_add_map_failure_remove_doi:
+	cipso_v4_doi_remove(doi_def->doi, audit_info, netlbl_cipsov4_doi_free);
+cfg_cipsov4_add_map_failure_unlock:
+	rcu_read_unlock();
+cfg_cipsov4_add_map_failure:
+	if (entry != NULL)
+		kfree(entry->domain);
+	kfree(entry);
+	return ret_val;
+}
+
+/**
+ * netlbl_cfg_cipsov4_del - Removean existing CIPSOv4 DOI definition
+ * @doi: the CIPSO DOI value
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Removes an existing CIPSOv4 DOI definition from the NetLabel subsystem.
+ * Returns zero on success, negative values on failure.
+ *
+ */
+int netlbl_cfg_cipsov4_del(u32 doi, struct netlbl_audit *audit_info)
+{
+	return cipso_v4_doi_remove(doi, audit_info, netlbl_cipsov4_doi_free);
+}
+
+/*
  * Security Attribute Functions
  */
 
_

Patches currently in -mm which might be from paul.moore@hp.com are

origin.patch
git-lblnet.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
