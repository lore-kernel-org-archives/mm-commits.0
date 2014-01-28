From: akpm@linux-foundation.org
Subject: [merged]
 checkpatchpl-check-for-function-declarations-without-arguments.patch
 removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:57 -0800
Message-ID: <52e80085.W9alvbWecyCAS9N6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbaA1TJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richard@nod.at, bp@alien8.de, joe@perches.com

Subject: [merged] checkpatchpl-check-for-function-declarations-without-arguments.patch removed from -mm tree
To: joe@perches.com,bp@alien8.de,richard@nod.at,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:57 -0800


The patch titled
     Subject: checkpatch.pl: check for function declarations without arguments
has been removed from the -mm tree.  Its filename was
     checkpatchpl-check-for-function-declarations-without-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch.pl: check for function declarations without arguments

Functions like this one are evil:

void foo()
{
	...
}

Because these functions allow variadic arguments without
checking the arguments at all.

Original patch by Richard Weinberger.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-check-for-function-declarations-without-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-check-for-function-declarations-without-arguments
+++ a/scripts/checkpatch.pl
@@ -2665,6 +2665,15 @@ sub process {
 				$herecurr);
                }
 
+# check for function declarations without arguments like "int foo()"
+		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
+			if (ERROR("FUNCTION_WITHOUT_ARGS",
+				  "Bad function definition - $1() should probably be $1(void)\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/(\b($Type)\s+($Ident))\s*\(\s*\)/$2 $3(void)/;
+			}
+		}
+
 # check for uses of DEFINE_PCI_DEVICE_TABLE
 		if ($line =~ /\bDEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=/) {
 			if (WARN("DEFINE_PCI_DEVICE_TABLE",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
linux-next.patch

