From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-parse-secinfo-information-in-exports-downcall.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:46 -0700
Message-ID: <200707172304.l6HN4kB6011852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935450AbXGQXQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andros@citi.umich.edu, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: parse secinfo information in exports downcall
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-parse-secinfo-information-in-exports-downcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: parse secinfo information in exports downcall
From: Andy Adamson <andros@citi.umich.edu>

We add a list of pseudoflavors to each export downcall, which will be used
both as a list of security flavors allowed on that export, and (in the order
given) as the list of pseudoflavors to return on secinfo calls.

This patch parses the new downcall information and adds it to the export
structure, but doesn't use it for anything yet.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andy Adamson <andros@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c            |   56 ++++++++++++++++++++++++++++++++--
 include/linux/nfsd/export.h |   17 ++++++++++
 2 files changed, 71 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd4-parse-secinfo-information-in-exports-downcall fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd4-parse-secinfo-information-in-exports-downcall
+++ a/fs/nfsd/export.c
@@ -33,6 +33,8 @@
 #include <linux/nfsd/nfsfh.h>
 #include <linux/nfsd/syscall.h>
 #include <linux/lockd/bind.h>
+#include <linux/sunrpc/msg_prot.h>
+#include <linux/sunrpc/gss_api.h>
 
 #define NFSDDBG_FACILITY	NFSDDBG_EXPORT
 
@@ -452,8 +454,48 @@ out_free_all:
 	return err;
 }
 
+static int secinfo_parse(char **mesg, char *buf, struct svc_export *exp)
+{
+	int listsize, err;
+	struct exp_flavor_info *f;
+
+	err = get_int(mesg, &listsize);
+	if (err)
+		return err;
+	if (listsize < 0 || listsize > MAX_SECINFO_LIST)
+		return -EINVAL;
+
+	for (f = exp->ex_flavors; f < exp->ex_flavors + listsize; f++) {
+		err = get_int(mesg, &f->pseudoflavor);
+		if (err)
+			return err;
+		/*
+		 * Just a quick sanity check; we could also try to check
+		 * whether this pseudoflavor is supported, but at worst
+		 * an unsupported pseudoflavor on the export would just
+		 * be a pseudoflavor that won't match the flavor of any
+		 * authenticated request.  The administrator will
+		 * probably discover the problem when someone fails to
+		 * authenticate.
+		 */
+		if (f->pseudoflavor < 0)
+			return -EINVAL;
+		err = get_int(mesg, &f->flags);
+		if (err)
+			return err;
+		/* Only some flags are allowed to differ between flavors: */
+		if (~NFSEXP_SECINFO_FLAGS & (f->flags ^ exp->ex_flags))
+			return -EINVAL;
+	}
+	exp->ex_nflavors = listsize;
+	return 0;
+}
+
 #else /* CONFIG_NFSD_V4 */
-static inline int fsloc_parse(char **mesg, char *buf, struct nfsd4_fs_locations *fsloc) { return 0; }
+static inline int
+fsloc_parse(char **mesg, char *buf, struct nfsd4_fs_locations *fsloc){return 0;}
+static inline int
+secinfo_parse(char **mesg, char *buf, struct svc_export *exp) { return 0; }
 #endif
 
 static int svc_export_parse(struct cache_detail *cd, char *mesg, int mlen)
@@ -477,6 +519,9 @@ static int svc_export_parse(struct cache
 
 	exp.ex_uuid = NULL;
 
+	/* secinfo */
+	exp.ex_nflavors = 0;
+
 	if (mesg[mlen-1] != '\n')
 		return -EINVAL;
 	mesg[mlen-1] = 0;
@@ -554,7 +599,9 @@ static int svc_export_parse(struct cache
 					if (exp.ex_uuid == NULL)
 						err = -ENOMEM;
 				}
-			} else
+			} else if (strcmp(buf, "secinfo") == 0)
+				err = secinfo_parse(&mesg, buf, &exp);
+			else
 				/* quietly ignore unknown words and anything
 				 * following. Newer user-space can try to set
 				 * new values, then see what the result was.
@@ -655,6 +702,7 @@ static void export_update(struct cache_h
 {
 	struct svc_export *new = container_of(cnew, struct svc_export, h);
 	struct svc_export *item = container_of(citem, struct svc_export, h);
+	int i;
 
 	new->ex_flags = item->ex_flags;
 	new->ex_anon_uid = item->ex_anon_uid;
@@ -670,6 +718,10 @@ static void export_update(struct cache_h
 	item->ex_fslocs.locations_count = 0;
 	new->ex_fslocs.migrated = item->ex_fslocs.migrated;
 	item->ex_fslocs.migrated = 0;
+	new->ex_nflavors = item->ex_nflavors;
+	for (i = 0; i < MAX_SECINFO_LIST; i++) {
+		new->ex_flavors[i] = item->ex_flavors[i];
+	}
 }
 
 static struct cache_head *svc_export_alloc(void)
diff -puN include/linux/nfsd/export.h~knfsd-nfsd4-parse-secinfo-information-in-exports-downcall include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~knfsd-nfsd4-parse-secinfo-information-in-exports-downcall
+++ a/include/linux/nfsd/export.h
@@ -42,6 +42,8 @@
 #define	NFSEXP_NOACL		0x8000	/* reserved for possible ACL related use */
 #define NFSEXP_ALLFLAGS		0xFE3F
 
+/* The flags that may vary depending on security flavor: */
+#define NFSEXP_SECINFO_FLAGS	0
 
 #ifdef __KERNEL__
 
@@ -64,6 +66,19 @@ struct nfsd4_fs_locations {
 	int migrated;
 };
 
+/*
+ * We keep an array of pseudoflavors with the export, in order from most
+ * to least preferred.  For the forseeable future, we don't expect more
+ * than the eight pseudoflavors null, unix, krb5, krb5i, krb5p, skpm3,
+ * spkm3i, and spkm3p (and using all 8 at once should be rare).
+ */
+#define MAX_SECINFO_LIST	8
+
+struct exp_flavor_info {
+	u32	pseudoflavor;
+	u32	flags;
+};
+
 struct svc_export {
 	struct cache_head	h;
 	struct auth_domain *	ex_client;
@@ -76,6 +91,8 @@ struct svc_export {
 	int			ex_fsid;
 	unsigned char *		ex_uuid; /* 16 byte fsid */
 	struct nfsd4_fs_locations ex_fslocs;
+	int			ex_nflavors;
+	struct exp_flavor_info	ex_flavors[MAX_SECINFO_LIST];
 };
 
 /* an "export key" (expkey) maps a filehandlefragement to an
_

Patches currently in -mm which might be from andros@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
