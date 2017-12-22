From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-the-tabstop-test-to-include-declarations.patch added to
 -mm tree
Date: Fri, 22 Dec 2017 14:15:52 -0800
Message-ID: <5a3d8418.Qvz8JivD7xOoRrgO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756149AbdLVWPy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Dec 2017 17:15:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the TABSTOP test to include declarations
has been added to the -mm tree.  Its filename is
     checkpatch-improve-the-tabstop-test-to-include-declarations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-the-tabstop-test-to-include-declarations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-the-tabstop-test-to-include-declarations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the TABSTOP test to include declarations

Declarations should start on a tabstop too.

Link: http://lkml.kernel.org/r/1b5f97673f36595956ad43329f77bf1a5546d2ff.1513976662.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-tabstop-test-to-include-declarations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-tabstop-test-to-include-declarations
+++ a/scripts/checkpatch.pl
@@ -3020,7 +3020,7 @@ sub process {
 
 # check indentation starts on a tab stop
 		if ($^V && $^V ge 5.10.0 &&
-		    $sline =~ /^\+\t+( +)(?:$c90_Keywords\b|\{\s*$|\}\s*(?:else\b|while\b|\s*$))/) {
+		    $sline =~ /^\+\t+( +)(?:$c90_Keywords\b|\{\s*$|\}\s*(?:else\b|while\b|\s*$)|$Declare\s*$Ident\s*[;=\[])/) {
 			my $indent = length($1);
 			if ($indent % 8) {
 				if (WARN("TABSTOP",
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-ignore-some-octal-permissions-of-0.patch
checkpatch-improve-quoted-string-and-line-continuation-test.patch
checkpatch-add-a-few-device_attr-style-tests.patch
checkpatch-improve-the-tabstop-test-to-include-declarations.patch

