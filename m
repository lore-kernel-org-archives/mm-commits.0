From: akpm@linux-foundation.org
Subject: - knfsd-fix-typo-in-export-display-print-uid-and-gid-as.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:33:50 -0700
Message-ID: <200707230933.l6N9Xogv016328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437AbXGWJe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: fix typo in export display, print uid and gid as unsigned
has been removed from the -mm tree.  Its filename was
     knfsd-fix-typo-in-export-display-print-uid-and-gid-as.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: fix typo in export display, print uid and gid as unsigned
From: J. Bruce Fields <bfields@citi.umich.edu>

For display purposes, treat uid's and gid's as unsigned ints for now.
Also fix a typo.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-fix-typo-in-export-display-print-uid-and-gid-as fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-fix-typo-in-export-display-print-uid-and-gid-as
+++ a/fs/nfsd/export.c
@@ -1503,9 +1503,9 @@ static void exp_flags(struct seq_file *m
 	if (flag & NFSEXP_FSID)
 		seq_printf(m, ",fsid=%d", fsid);
 	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
-		seq_printf(m, ",sanonuid=%d", anonu);
+		seq_printf(m, ",anonuid=%u", anonu);
 	if (anong != (gid_t)-2 && anong != (0x10000-2))
-		seq_printf(m, ",sanongid=%d", anong);
+		seq_printf(m, ",anongid=%u", anong);
 	if (fsloc && fsloc->locations_count > 0) {
 		char *loctype = (fsloc->migrated) ? "refer" : "replicas";
 		int i;
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

auth_gss-unregister-gss_domain-when-unloading-module.patch
locks-kill-redundant-local-variable.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
