From: akpm@linux-foundation.org
Subject: + checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:53:52 -0800
Message-ID: <200901302153.n0ULrrOX031290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbZA3Vx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:53:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: a modifier is not an identifier at the end of a type
has been added to the -mm tree.  Its filename is
     checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch

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
Subject: checkpatch: a modifier is not an identifier at the end of a type
From: Andy Whitcroft <apw@canonical.com>

We must make sure we do not miss recognise a modifier as an Identifier
when trying to match types.  Prevent us matching this:

	void * __ref

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type
+++ a/scripts/checkpatch.pl
@@ -1686,8 +1686,8 @@ sub process {
 			# Modifiers should have spaces.
 			$to =~ s/(\b$Modifier$)/$1 /;
 
-			#print "from<$from> to<$to>\n";
-			if ($from ne $to) {
+			#print "from<$from> to<$to> ident<$ident>\n";
+			if ($from ne $to && $ident !~ /^$Modifier$/) {
 				ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
 			}
 		}
_

Patches currently in -mm which might be from apw@canonical.com are

mmc-add-modalias-linkage-for-mmc-sd-devices.patch
checkpatch-make-in_atomic-ok-in-the-core.patch
checkpatch-do-not-warn-about-p0-patches-when-checking-files.patch
checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers.patch
checkpatch-pointer-type-star-may-have-modifiers-following.patch
checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch
checkpatch-extend-attribute-testing-to-all-modifiers.patch
checkpatch-add-__ref-as-a-sparse-modifier.patch
checkpatch-version-028.patch

