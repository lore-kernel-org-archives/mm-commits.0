From: akpm@linux-foundation.org
Subject: - knfsd-nfsd-factor-out-code-from-show_expflags.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:05 -0700
Message-ID: <200707172305.l6HN55Kp011886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935660AbXGQXPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd: factor out code from show_expflags
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd-factor-out-code-from-show_expflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
