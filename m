From: akpm@linux-foundation.org
Subject: [patch 40/94] checkpatch: support function pointers for
 unnamed function definition arguments
Date: Fri, 17 Nov 2017 15:28:34 -0800
Message-ID: <20171117232834.NhWhq1h-W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965766AbdKQX2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
