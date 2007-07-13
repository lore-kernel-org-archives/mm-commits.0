From: akpm@linux-foundation.org
Subject: + knfsd-nfsd-display-export-secinfo-information.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:34:04 -0700
Message-ID: <200707130734.l6D7Y4F6005442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061AbXGMHeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:34:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd: display export secinfo information
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-display-export-secinfo-information.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
fix-trivial-typos-in-anon_inodesc-comments.patch
knfsd-lockd-nfsd4-use-same-grace-period-for-lockd-and-nfsd4.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch
knfsd-nfsd-make-all-exp_finding-functions-return-errnos-on-err.patch
knfsd-nfsd4-build-rpcsec_gss-whenever-nfsd4-is-built.patch
knfsd-nfsd4-store-pseudoflavor-in-request.patch
knfsd-nfsd4-parse-secinfo-information-in-exports-downcall.patch
knfsd-nfsd4-simplify-exp_pseudoroot-arguments.patch
knfsd-nfsd-remove-superfluous-assignment-from-nfsd_lookup.patch
knfsd-nfsd-provide-export-lookup-wrappers-which-take-a-svc_rqst.patch
knfsd-nfsd-set-rq_client-to-ip-address-determined-domain.patch
knfsd-nfsd-use-ip-address-based-domain-in-secinfo-case.patch
knfsd-nfsd-factor-nfsd_lookup-into-2-pieces.patch
knfsd-nfsd4-return-nfserr_wrongsec.patch
knfsd-nfsd4-make-readonly-access-depend-on-pseudoflavor.patch
knfsd-nfsd-factor-out-code-from-show_expflags.patch
knfsd-nfsd-display-export-secinfo-information.patch
knfsd-rpc-add-gss-krb5-and-spkm3-oid-values.patch
knfsd-nfsd4-implement-secinfo.patch
knfsd-nfsd4-secinfo-handling-without-secinfo=-option.patch
knfsd-nfsd-allow-auth_sys-nlm-on-rpcsec_gss-exports.patch
knfsd-nfsd-enforce-per-flavor-id-squashing.patch
