From: akpm@linux-foundation.org
Subject: + knfsd-nfsd-factor-out-code-from-show_expflags.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:34:03 -0700
Message-ID: <200707130734.l6D7Y3m1005439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38895 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933025AbXGMHeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd: factor out code from show_expflags
has been added to the -mm tree.  Its filename is
     knfsd-nfsd-factor-out-code-from-show_expflags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd: factor out code from show_expflags
From: J. Bruce Fields <bfields@citi.umich.edu>

Factor out some code to be shared by secinfo display code.  Remove some
unnecessary conditional printing of commas where we know the condition is
true.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-nfsd-factor-out-code-from-show_expflags fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-nfsd-factor-out-code-from-show_expflags
+++ a/fs/nfsd/export.c
@@ -1453,28 +1453,35 @@ static struct flags {
 	{ 0, {"", ""}}
 };
 
-static void exp_flags(struct seq_file *m, int flag, int fsid,
-		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
+static void show_expflags(struct seq_file *m, int flags, int mask)
 {
-	int first = 0;
 	struct flags *flg;
+	int state, first = 0;
 
 	for (flg = expflags; flg->flag; flg++) {
-		int state = (flg->flag & flag)?0:1;
+		if (flg->flag & ~mask)
+			continue;
+		state = (flg->flag & flags) ? 0 : 1;
 		if (*flg->name[state])
 			seq_printf(m, "%s%s", first++?",":"", flg->name[state]);
 	}
+}
+
+static void exp_flags(struct seq_file *m, int flag, int fsid,
+		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
+{
+	show_expflags(m, flag, NFSEXP_ALLFLAGS);
 	if (flag & NFSEXP_FSID)
-		seq_printf(m, "%sfsid=%d", first++?",":"", fsid);
+		seq_printf(m, ",fsid=%d", fsid);
 	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
-		seq_printf(m, "%sanonuid=%d", first++?",":"", anonu);
+		seq_printf(m, ",sanonuid=%d", anonu);
 	if (anong != (gid_t)-2 && anong != (0x10000-2))
-		seq_printf(m, "%sanongid=%d", first++?",":"", anong);
+		seq_printf(m, ",sanongid=%d", anong);
 	if (fsloc && fsloc->locations_count > 0) {
 		char *loctype = (fsloc->migrated) ? "refer" : "replicas";
 		int i;
 
-		seq_printf(m, "%s%s=", first++?",":"", loctype);
+		seq_printf(m, ",%s=", loctype);
 		seq_escape(m, fsloc->locations[0].path, ",;@ \t\n\\");
 		seq_putc(m, '@');
 		seq_escape(m, fsloc->locations[0].hosts, ",;@ \t\n\\");
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
