From: akpm@linux-foundation.org
Subject: + kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch added to -mm tree
Date: Sat, 07 Apr 2007 15:23:33 -0700
Message-ID: <200704072223.l37MNXjr011259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35071 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965987AbXDGWXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 18:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de, randy.dunlap@oracle.com


The patch titled
     kernel-doc: handle arrays with arithmetic expressions as initializers
has been added to the -mm tree.  Its filename is
     kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1461,7 +1461,16 @@ sub create_parameterlist($$$) {
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

drivers-acpi-kconfig-formulation-fixpatch.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
