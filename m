From: akpm@linux-foundation.org
Subject: - codingstyle-proscribe-do-while-without-braces.patch removed from -mm tree
Date: Fri, 27 Jul 2007 11:28:12 -0700
Message-ID: <200707271828.l6RISCfq003669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40575 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757426AbXG0S2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 14:28:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josht@linux.vnet.ibm.com, josh@kernel.org, mm-commits@vger.kernel.org


The patch titled
     CodingStyle: proscribe do-while without braces.
has been removed from the -mm tree.  Its filename was
     codingstyle-proscribe-do-while-without-braces.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: CodingStyle: proscribe do-while without braces.
From: Josh Triplett <josht@linux.vnet.ibm.com>

Sparse warns about do-while loops without braces; Linus's rationale from the
Sparse Git changelog:

> Add warning message for naked do-while
>
> Does it necessarily make sense? Dunno, but it does tend to be bad
> practice, or at least result in code that can be hard to mentally parse.
>
> Maybe that mental parsing is just me.	 Or maybe it should be warned
> about. You decide.

Signed-off-by: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/CodingStyle~codingstyle-proscribe-do-while-without-braces Documentation/CodingStyle
--- a/Documentation/CodingStyle~codingstyle-proscribe-do-while-without-braces
+++ a/Documentation/CodingStyle
@@ -175,6 +175,13 @@ if (condition) {
 	otherwise();
 }
 
+This also does not apply to a do-while loop; always use braces with a do-while,
+even if it contains a single statement:
+
+do {
+	this();
+} while(condition);
+
 		3.1:  Spaces
 
 Linux kernel style for use of spaces depends (mostly) on
_

Patches currently in -mm which might be from josht@linux.vnet.ibm.com are

codingstyle-proscribe-do-while-without-braces.patch
i386-mark-pit_clockevent-static.patch
