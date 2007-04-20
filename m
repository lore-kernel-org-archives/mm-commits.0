From: akpm@linux-foundation.org
Subject: + codingstyle-start-flamewar-about-use-of-braces.patch added to -mm tree
Date: Fri, 20 Apr 2007 11:02:23 -0700
Message-ID: <200704201802.l3KI2Nlh020621@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993307AbXDTSCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 14:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oliver@neukum.org, oneukum@suse.de, tilman@imap.cc


The patch titled
     CodingStyle: start flamewar about use of braces
has been added to the -mm tree.  Its filename is
     codingstyle-start-flamewar-about-use-of-braces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CodingStyle: start flamewar about use of braces
From: Oliver Neukum <oliver@neukum.org>

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   15 +++++++++++++++
 1 files changed, 15 insertions(+)

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

codingstyle-start-flamewar-about-use-of-braces.patch
