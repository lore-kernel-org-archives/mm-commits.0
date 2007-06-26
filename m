From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:46:23 -0700
Message-ID: <200706260346.l5Q3kNvb017626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbXFZDql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: silence a compiler warning in ACL code
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: silence a compiler warning in ACL code
From: "J. Bruce Fields" <bfields@fieldses.org>

Silence a compiler warning in the ACL code, and add a comment making clear the
initialization serves no other purpose.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4acl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/nfs4acl.c~knfsd-nfsd4-silence-a-compiler-warning-in-acl-code fs/nfsd/nfs4acl.c
--- a/fs/nfsd/nfs4acl.c~knfsd-nfsd4-silence-a-compiler-warning-in-acl-code
+++ a/fs/nfsd/nfs4acl.c
@@ -183,8 +183,13 @@ static void
 summarize_posix_acl(struct posix_acl *acl, struct posix_acl_summary *pas)
 {
 	struct posix_acl_entry *pa, *pe;
-	pas->users = 0;
-	pas->groups = 0;
+
+	/*
+	 * Only pas.users and pas.groups need initialization; previous
+	 * posix_acl_valid() calls ensure that the other fields will be
+	 * initialized in the following loop.  But, just to placate gcc:
+	 */
+	memset(pas, 0, sizeof(*pas));
 	pas->mask = 07;
 
 	pe = acl->a_entries + acl->a_count;
_

Patches currently in -mm which might be from bfields@fieldses.org are

nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
