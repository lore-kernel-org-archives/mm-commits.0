From: akpm@linux-foundation.org
Subject: + knfsd-fix-typo-in-export-display-print-uid-and-gid-as.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:28:15 -0700
Message-ID: <200707202228.l6KMSFlG019781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758329AbXGTW2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: fix typo in export display, print uid and gid as unsigned
has been added to the -mm tree.  Its filename is
     knfsd-fix-typo-in-export-display-print-uid-and-gid-as.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
knfsd-fix-typo-in-export-display-print-uid-and-gid-as.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
locks-kill-redundant-local-variable.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
