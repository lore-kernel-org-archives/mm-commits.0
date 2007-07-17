From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:28 -0700
Message-ID: <200707172304.l6HN4SMo011805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935871AbXGQXQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: silence a compiler warning in ACL code
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-vfs-lease-api.patch
