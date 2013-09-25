From: akpm@linux-foundation.org
Subject: [merged] checkpatch-make-extern-in-h-prototypes-quieter.patch
 removed from -mm tree
Date: Wed, 25 Sep 2013 12:06:20 -0700
Message-ID: <5243342c.UVqxSi3Gib7A0Rbb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3IYTGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, joe@perches.com

Subject: [merged] checkpatch-make-extern-in-h-prototypes-quieter.patch removed from -mm tree
To: joe@perches.com,dhowells@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:06:20 -0700


The patch titled
     Subject: checkpatch: make extern in .h prototypes quieter
has been removed from the -mm tree.  Its filename was
     checkpatch-make-extern-in-h-prototypes-quieter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: make extern in .h prototypes quieter

The use of extern in .h files is a bit contentious.

Make the warning be emitted only when --strict is used on the command line.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-extern-in-h-prototypes-quieter scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-extern-in-h-prototypes-quieter
+++ a/scripts/checkpatch.pl
@@ -3975,8 +3975,8 @@ sub string_find_replace {
 # check for new externs in .h files.
 		if ($realfile =~ /\.h$/ &&
 		    $line =~ /^\+\s*(extern\s+)$Type\s*$Ident\s*\(/s) {
-			if (WARN("AVOID_EXTERNS",
-				 "extern prototypes should be avoided in .h files\n" . $herecurr) &&
+			if (CHK("AVOID_EXTERNS",
+				"extern prototypes should be avoided in .h files\n" . $herecurr) &&
 			    $fix) {
 				$fixed[$linenr - 1] =~ s/(.*)\bextern\b\s*(.*)/$1$2/;
 			}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
kernel-modulec-use-pr_foo.patch

