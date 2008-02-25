From: akpm@linux-foundation.org
Subject: - kernel-doc-fix-function-pointer-parameter-parsing.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:37 -0800
Message-ID: <200802250045.m1P0jbnd006273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187AbYBYAtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: fix function-pointer-parameter parsing
has been removed from the -mm tree.  Its filename was
     kernel-doc-fix-function-pointer-parameter-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: fix function-pointer-parameter parsing
From: Richard Kennedy <richard@rsk.demon.co.uk>

When running "make htmldocs" I'm seeing some non-fatal perl errors caused
by trying to parse the callback function definitions in blk-core.c.

The errors are "Use of uninitialized value in concatenation (.)..."
in combination with:
Warning(linux-2.6.25-rc2/block/blk-core.c:1877): No description found for parameter ''

The function pointers are defined without a * i.e.
int (drv_callback)(struct request *)

The compiler is happy with them, but kernel-doc isn't.

This patch teaches create_parameterlist in kernel-doc to parse this type of
function pointer definition, but is it the right way to fix the problem ? 
The problem only seems to occur in blk-core.c.

However with the patch applied, kernel-doc finds the correct parameter
description for the callback in blk_end_request_callback, which is doesn't
normally.

I thought it would be a bit odd to change to code to use the more normal
form of function pointers just to get the documentation to work, so I fixed
kernel-doc instead - even though this is teaching it to understand code
that might go away (The comment for blk_end_request_callback says that it
should not be used and will removed at some point).

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-function-pointer-parameter-parsing scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-function-pointer-parameter-parsing
+++ a/scripts/kernel-doc
@@ -1512,13 +1512,13 @@ sub create_parameterlist($$$) {
 	    # corresponding data structures "correctly". Catch it later in
 	    # output_* subs.
 	    push_parameter($arg, "", $file);
-	} elsif ($arg =~ m/\(.*\*/) {
+	} elsif ($arg =~ m/\(.+\)\s*\(/) {
 	    # pointer-to-function
 	    $arg =~ tr/#/,/;
-	    $arg =~ m/[^\(]+\(\*\s*([^\)]+)\)/;
+	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
 	    $param = $1;
 	    $type = $arg;
-	    $type =~ s/([^\(]+\(\*)$param/$1/;
+	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
 	    push_parameter($param, $type, $file);
 	} elsif ($arg) {
 	    $arg =~ s/\s*:\s*/:/g;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are
