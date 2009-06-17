From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-dont-print-maintainers-when-not-requested.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:19 -0700
Message-ID: <200906171838.n5HIcJ74004305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759537AbZFQSqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: don't print maintainers when not requested
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-dont-print-maintainers-when-not-requested.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: don't print maintainers when not requested
From: Joe Perches <joe@perches.com>

Fixed bug introduced after using rfc822 address checking.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-dont-print-maintainers-when-not-requested scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-dont-print-maintainers-when-not-requested
+++ a/scripts/get_maintainer.pl
@@ -436,10 +436,12 @@ sub push_email_address {
 	$email_address = $2;
     }
 
-    if ($email_usename && $email_name) {
-	push(@email_to,	format_email($email_name, $email_address));
-    } else {
-	push(@email_to, $email_address);
+    if ($email_maintainer) {
+	if ($email_usename && $email_name) {
+	    push(@email_to, format_email($email_name, $email_address));
+	} else {
+	    push(@email_to, $email_address);
+	}
     }
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

