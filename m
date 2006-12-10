From: akpm@osdl.org
Subject: + profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:22:53 -0800
Message-ID: <200612101922.kBAJMrmi000705@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762405AbWLJTXD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     remove likely profiling int cast
has been added to the -mm tree.  Its filename is
     profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch

