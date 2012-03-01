From: akpm@linux-foundation.org
Subject: + checkpatch-handle-string-concatenation-in-simple-defines.patch added to -mm tree
Date: Thu, 01 Mar 2012 12:36:45 -0800
Message-ID: <20120301203645.C6774A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:42798 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab2CAUgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 15:36:46 -0500
Received: by ghbz15 with SMTP id z15so114744ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 12:36:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: handle string concatenation in simple #defines
has been added to the -mm tree.  Its filename is
     checkpatch-handle-string-concatenation-in-simple-defines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: handle string concatenation in simple #defines

Adjacent strings indicate concatentation, therefore look at identifiers
directly adjacent to literal strings as strings too.  This allows us to
better detect the form below and accept it as a simple constant:

    #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-handle-string-concatenation-in-simple-defines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-string-concatenation-in-simple-defines
+++ a/scripts/checkpatch.pl
@@ -2889,6 +2889,12 @@ sub process {
 			{
 			}
 
+			# Flatten any obvious string concatentation.
+			while ($dstat =~ s/("X*")\s*$Ident/$1/ ||
+			       $dstat =~ s/$Ident\s*("X*")/$1/)
+			{
+			}
+
 			my $exceptions = qr{
 				$Declare|
 				module_param_named|
_
Subject: Subject: checkpatch: handle string concatenation in simple #defines

Patches currently in -mm which might be from apw@canonical.com are

checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch

