From: akpm@linux-foundation.org
Subject: - audit-fix-oops-removing-watch-if-audit-disabled.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:23 -0700
Message-ID: <200706250921.l5P9LNgF031092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbXFYJYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tonyj@suse.de, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: fix oops removing watch if audit disabled
has been removed from the -mm tree.  Its filename was
     audit-fix-oops-removing-watch-if-audit-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
