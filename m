From: akpm@linux-foundation.org
Subject: +
 checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch added to -mm tree
Date: Fri, 15 Sep 2017 14:09:23 -0700
Message-ID: <59bc4183.ITWrciAAD1XIGN3M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59200 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdIOVJY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 17:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: support function pointers for unnamed function definition arguments
has been added to the -mm tree.  Its filename is
     checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: checkpatch: support function pointers for unnamed function definition arguments

Current unnamed function definition argument does not include function
pointer cases and it reports something like:

WARNING: function definition argument 'void' should also have an identifier name
+unsigned int (*dummy)(void);

Support function pointers for unnamed function arguments

Link: http://lkml.kernel.org/r/1505389925-31087-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-support-function-pointers-for-unnamed-function-definition-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-support-function-pointers-for-unnamed-function-definition-arguments
+++ a/scripts/checkpatch.pl
@@ -5957,7 +5957,7 @@ sub process {
 
 # check for function declarations that have arguments without identifier names
 		if (defined $stat &&
-		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*$Ident\s*\(\s*([^{]+)\s*\)\s*;/s &&
+		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*\(\s*([^{]+)\s*\)\s*;/s &&
 		    $1 ne "void") {
 			my $args = trim($1);
 			while ($args =~ m/\s*($Type\s*(?:$Ident|\(\s*\*\s*$Ident?\s*\)\s*$balanced_parens)?)/g) {
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

