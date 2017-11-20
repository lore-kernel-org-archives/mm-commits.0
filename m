From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?checkpatch-support-function-pointers-for-unnamed-function-de?=
 =?US-ASCII?Q?finition-arguments.patch?= removed from -mm tree
Date: Mon, 20 Nov 2017 13:24:33 -0800
Message-ID: <20171120212433.BQxK4pxFF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752988AbdKTVYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: support function pointers for unnamed function definition arguments
has been removed from the -mm tree.  Its filename was
     checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


