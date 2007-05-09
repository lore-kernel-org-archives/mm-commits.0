From: akpm@linux-foundation.org
Subject: - codingstyle-start-flamewar-about-use-of-braces.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:53 -0700
Message-ID: <200705090250.l492orcw009399@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970031AbXEICvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oliver@neukum.org, oneukum@suse.de, tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     CodingStyle: start flamewar about use of braces
has been removed from the -mm tree.  Its filename was
     codingstyle-start-flamewar-about-use-of-braces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CodingStyle: start flamewar about use of braces
From: Oliver Neukum <oliver@neukum.org>

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN Documentation/CodingStyle~codingstyle-start-flamewar-about-use-of-braces Documentation/CodingStyle
--- a/Documentation/CodingStyle~codingstyle-start-flamewar-about-use-of-braces
+++ a/Documentation/CodingStyle
@@ -160,6 +160,21 @@ supply of new-lines on your screen is no
 25-line terminal screens here), you have more empty lines to put
 comments on.
 
+Do not unnecessarily use braces where a single statement will do.
+
+if (condition)
+	action();
+
+This does not apply if one branch of a conditional statement is a single
+statement. Use braces in both branches.
+
+if (condition) {
+	do_this();
+	do_that();
+} else {
+	otherwise();
+}
+
 		3.1:  Spaces
 
 Linux kernel style for use of spaces depends (mostly) on
_

Patches currently in -mm which might be from oliver@neukum.org are

origin.patch
