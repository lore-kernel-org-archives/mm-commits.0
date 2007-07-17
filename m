From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-display-export-secinfo-information.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:07 -0700
Message-ID: <200707172305.l6HN57dA011889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935539AbXGQXPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: display export secinfo information
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-display-export-secinfo-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd: display export secinfo information
From: J. Bruce Fields <bfields@citi.umich.edu>

Add secinfo information to the display in proc/net/sunrpc/nfsd.export/content.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN fs/nfsd/export.c~knfsd-nfsd-display-export-secinfo-information fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-display-export-secinfo-information
+++ a/fs/nfsd/export.c
@@ -641,6 +641,7 @@ static int svc_export_parse(struct cache
 
 static void exp_flags(struct seq_file *m, int flag, int fsid,
 		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fslocs);
+static void show_secinfo(struct seq_file *m, struct svc_export *exp);
 
 static int svc_export_show(struct seq_file *m,
 			   struct cache_detail *cd,
@@ -670,6 +671,7 @@ static int svc_export_show(struct seq_fi
 				seq_printf(m, "%02x", exp->ex_uuid[i]);
 			}
 		}
+		show_secinfo(m, exp);
 	}
 	seq_puts(m, ")\n");
 	return 0;
@@ -1467,6 +1469,33 @@ static void show_expflags(struct seq_fil
 	}
 }
 
+static void show_secinfo_flags(struct seq_file *m, int flags)
+{
+	seq_printf(m, ",");
+	show_expflags(m, flags, NFSEXP_SECINFO_FLAGS);
+}
+
+static void show_secinfo(struct seq_file *m, struct svc_export *exp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+	int lastflags = 0, first = 0;
+
+	if (exp->ex_nflavors == 0)
+		return;
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (first || f->flags != lastflags) {
+			if (!first)
+				show_secinfo_flags(m, lastflags);
+			seq_printf(m, ",sec=%d", f->pseudoflavor);
+			lastflags = f->flags;
+		} else {
+			seq_printf(m, ":%d", f->pseudoflavor);
+		}
+	}
+	show_secinfo_flags(m, lastflags);
+}
+
 static void exp_flags(struct seq_file *m, int flag, int fsid,
 		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
 {
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
