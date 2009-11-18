From: akpm@linux-foundation.org
Subject: + checkpatch-fix-false-positive-on-__initconst.patch added to -mm tree
Date: Wed, 18 Nov 2009 11:57:20 -0800
Message-ID: <200911181957.nAIJvKE9018480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758476AbZKRT6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 14:58:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, apw@shadowen.org


The patch titled
     checkpatch: fix false positive on __initconst
has been added to the -mm tree.  Its filename is
     checkpatch-fix-false-positive-on-__initconst.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: fix false positive on __initconst
From: Wolfram Sang <w.sang@pengutronix.de>

checkpatch falsely complained about '__initconst' because it thought the
'const' needed a space before.  Fix this by changing the list of
attributes:

- add '__initconst'
- force plain 'init' to contain a word-boundary at the end

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-false-positive-on-__initconst scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-false-positive-on-__initconst
+++ a/scripts/checkpatch.pl
@@ -145,11 +145,14 @@ our $Sparse	= qr{
 			__kprobes|
 			__ref
 		}x;
+
+# Notes to $Attribute:
+# We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
 our $Attribute	= qr{
 			const|
 			__read_mostly|
 			__kprobes|
-			__(?:mem|cpu|dev|)(?:initdata|init)|
+			__(?:mem|cpu|dev|)(?:initdata|initconst|init\b)|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
checkpatch-fix-false-positive-on-__initconst.patch

