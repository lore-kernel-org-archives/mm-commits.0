From: akpm@linux-foundation.org
Subject: - nfsd4-idmap-upcalls-should-use-unsigned-uid-and-gid.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:35 -0700
Message-ID: <200707312355.l6VNtZBW029236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760812AbXHAAQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     nfsd4: idmap upcalls should use unsigned uid and gid
has been removed from the -mm tree.  Its filename was
     nfsd4-idmap-upcalls-should-use-unsigned-uid-and-gid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd4: idmap upcalls should use unsigned uid and gid
From: J. Bruce Fields <bfields@citi.umich.edu>

We shouldn't be using negative uid's and gid's in the idmap upcalls.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4idmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs4idmap.c~nfsd4-idmap-upcalls-should-use-unsigned-uid-and-gid fs/nfsd/nfs4idmap.c
--- a/fs/nfsd/nfs4idmap.c~nfsd4-idmap-upcalls-should-use-unsigned-uid-and-gid
+++ a/fs/nfsd/nfs4idmap.c
@@ -138,7 +138,7 @@ idtoname_request(struct cache_detail *cd
 	char idstr[11];
 
 	qword_add(bpp, blen, ent->authname);
-	snprintf(idstr, sizeof(idstr), "%d", ent->id);
+	snprintf(idstr, sizeof(idstr), "%u", ent->id);
 	qword_add(bpp, blen, ent->type == IDMAP_TYPE_GROUP ? "group" : "user");
 	qword_add(bpp, blen, idstr);
 
@@ -165,7 +165,7 @@ idtoname_show(struct seq_file *m, struct
 		return 0;
 	}
 	ent = container_of(h, struct ent, h);
-	seq_printf(m, "%s %s %d", ent->authname,
+	seq_printf(m, "%s %s %u", ent->authname,
 			ent->type == IDMAP_TYPE_GROUP ? "group" : "user",
 			ent->id);
 	if (test_bit(CACHE_VALID, &h->flags))
@@ -349,7 +349,7 @@ nametoid_show(struct seq_file *m, struct
 			ent->type == IDMAP_TYPE_GROUP ? "group" : "user",
 			ent->name);
 	if (test_bit(CACHE_VALID, &h->flags))
-		seq_printf(m, " %d", ent->id);
+		seq_printf(m, " %u", ent->id);
 	seq_printf(m, "\n");
 	return 0;
 }
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
locks-kill-redundant-local-variable.patch
