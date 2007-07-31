From: akpm@linux-foundation.org
Subject: - knfsd-eliminate-unnecessary-enoent-returns-on-export-downcalls.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:37 -0700
Message-ID: <200707312355.l6VNtbwS029239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760676AbXHAAQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: eliminate unnecessary -ENOENT returns on export downcalls
has been removed from the -mm tree.  Its filename was
     knfsd-eliminate-unnecessary-enoent-returns-on-export-downcalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: eliminate unnecessary -ENOENT returns on export downcalls
From: J. Bruce Fields <bfields@citi.umich.edu>

A succesful downcall with a negative result (which indicates that the given
filesystem is not exported to the given user) should not return an error.

Currently mountd is depending on stdio to write these downcalls.  With some
versions of libc this appears to cause subsequent writes to attempt to write
all accumulated data (for which writes previously failed) along with any new
data.  This can prevent the kernel from seeing responses to later downcalls. 
Symptoms will be that nfsd fails to respond to certain requests.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/export.c~knfsd-eliminate-unnecessary-enoent-returns-on-export-downcalls fs/nfsd/export.c
--- a/fs/nfsd/export.c~knfsd-eliminate-unnecessary-enoent-returns-on-export-downcalls
+++ a/fs/nfsd/export.c
@@ -564,9 +564,10 @@ static int svc_export_parse(struct cache
 
 	/* flags */
 	err = get_int(&mesg, &an_int);
-	if (err == -ENOENT)
+	if (err == -ENOENT) {
+		err = 0;
 		set_bit(CACHE_NEGATIVE, &exp.h.flags);
-	else {
+	} else {
 		if (err || an_int < 0) goto out;	
 		exp.ex_flags= an_int;
 	
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
locks-kill-redundant-local-variable.patch
