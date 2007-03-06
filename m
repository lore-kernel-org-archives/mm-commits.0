From: akpm@linux-foundation.org
Subject: - profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:20:55 -0800
Message-ID: <200703060220.l262KtFj009286@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965629AbXCFCVC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:21:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     remove likely profiling int cast
has been removed from the -mm tree.  Its filename was
     profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

------------------------------------------------------
Subject: remove likely profiling int cast
From: Daniel Walker <dwalker@mvista.com>

Fix some wrong casting from unsigned int to int. Reported by Andreas Mohr.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/likely_prof.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/likely_prof.c~profile-likely-unlikely-macros_remove-likely-profiling-int-cast lib/likely_prof.c
--- a/lib/likely_prof.c~profile-likely-unlikely-macros_remove-likely-profiling-int-cast
+++ a/lib/likely_prof.c
@@ -86,8 +86,8 @@ static void *lp_seq_next(struct seq_file
 static int lp_seq_show(struct seq_file *out, void *p)
 {
 	struct likeliness *entry = p;
-	int true = entry->count[1];
-	int false = entry->count[0];
+	unsigned int true = entry->count[1];
+	unsigned int false = entry->count[0];
 
 	if (!entry->type) {
 		if (true > false)
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch
profile-likely-unlikely-macros-x86_64-fix.patch
