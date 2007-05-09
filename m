From: akpm@linux-foundation.org
Subject: - kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:12 -0700
Message-ID: <200705090249.l492nC7w009199@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966385AbXEICtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: handle arrays with arithmetic expressions as initializers
has been removed from the -mm tree.  Its filename was
     kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: handle arrays with arithmetic expressions as initializers
From: Borislav Petkov <bbpetkov@yahoo.de>

In a different approach here's a patch that handles the special case of
composite arithmetic expressions in array size initializers.  With it,
prior to pushing the split strings on the @first_arg array, I split the
keywords before the array name as before and then keep the array name along
with the subscript expression as a single whole element which gets pushed
last.  In this manner, kernel-doc produces correct output without removing
whitespaces which makes the array subscripts unreadable in the docs.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-handle-arrays-with-arithmetic-expressions-as scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-handle-arrays-with-arithmetic-expressions-as
+++ a/scripts/kernel-doc
@@ -1456,7 +1456,16 @@ sub create_parameterlist($$$) {
 	    if ($args[0] =~ m/\*/) {
 		$args[0] =~ s/(\*+)\s*/ $1/;
 	    }
-	    my @first_arg = split('\s+', shift @args);
+
+	    my @first_arg;
+	    if ($args[0] =~ /^(.*\s+)(.*?\[.*\].*)$/) {
+		    shift @args;
+		    push(@first_arg, split('\s+', $1));
+		    push(@first_arg, $2);
+	    } else {
+		    @first_arg = split('\s+', shift @args);
+	    }
+
 	    unshift(@args, pop @first_arg);
 	    $type = join " ", @first_arg;
 
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
kernel-doc-small-kernel-doc-optimization.patch
