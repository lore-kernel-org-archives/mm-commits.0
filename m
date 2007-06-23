From: akpm@linux-foundation.org
Subject: + audit-fix-oops-removing-watch-if-audit-disabled.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:51:34 -0700
Message-ID: <200706231651.l5NGpVeR019597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759654AbXFWQvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tonyj@suse.de, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     audit: fix oops removing watch if audit disabled
has been added to the -mm tree.  Its filename is
     audit-fix-oops-removing-watch-if-audit-disabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: audit: fix oops removing watch if audit disabled
From: Tony Jones <tonyj@suse.de>

Removing a watched file will oops if audit is disabled (auditctl -e 0).

To reproduce:
- auditctl -e 1
- touch /tmp/foo
- auditctl -w /tmp/foo
- auditctl -e 0
- rm /tmp/foo (or mv)

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/auditfilter.c~audit-fix-oops-removing-watch-if-audit-disabled kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-fix-oops-removing-watch-if-audit-disabled
+++ a/kernel/auditfilter.c
@@ -947,7 +947,7 @@ static void audit_update_watch(struct au
 
 		/* If the update involves invalidating rules, do the inode-based
 		 * filtering now, so we don't omit records. */
-		if (invalidating &&
+		if (invalidating && current->audit_context &&
 		    audit_filter_inodes(current, current->audit_context) == AUDIT_RECORD_CONTEXT)
 			audit_set_auditable(current->audit_context);
 
_

Patches currently in -mm which might be from tonyj@suse.de are

audit-fix-oops-removing-watch-if-audit-disabled.patch
