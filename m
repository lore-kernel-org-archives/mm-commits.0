From: akpm@linux-foundation.org
Subject: +
 checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch added to -mm tree
Date: Wed, 18 Sep 2013 13:57:39 -0700
Message-ID: <523a13c3.c/Xvfi2VHnnDI8GQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3IRU5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 16:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sarah.a.sharp@linux.intel.com, akpm@linux-foundation.org, joe@perches.com

Subject: + checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch added to -mm tree
To: joe@perches.com,akpm@linux-foundation.org,sarah.a.sharp@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 13:57:39 -0700


The patch titled
     Subject: checkpatch: extend CamelCase types and ignore existing CamelCase uses in a patch
has been added to the -mm tree.  Its filename is
     checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch

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
Subject: checkpatch: extend CamelCase types and ignore existing CamelCase uses in a patch

Extend the CamelCase words found to include structure members.

In https://lkml.org/lkml/2013/9/3/318 Sarah Sharp (mostly) wrote:

"In general, if checkpatch.pl complains about a variable a patch
introduces that's CamelCase, you should pay attention to it.  Otherwise,
[] ignore it."

So, if checking a patch, scan the original patched file if it's available
and add any preexisting CamelCase types so reuses do not generate
CamelCase messages.

That also means Andrew's not so cruelly spurned anymore. 
https://lkml.org/lkml/2013/2/22/426

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch
+++ a/scripts/checkpatch.pl
@@ -443,7 +443,7 @@ sub seed_camelcase_file {
 		if ($line =~ /^[ \t]*(?:#[ \t]*define|typedef\s+$Type)\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)/) {
 			$camelcase{$1} = 1;
 		}
-	        elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*\(/) {
+	        elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*[\(\[,;]/) {
 			$camelcase{$1} = 1;
 		}
 	}
@@ -1612,6 +1612,8 @@ sub process {
 	my @setup_docs = ();
 	my $setup_docs = 0;
 
+	my $camelcase_file_seeded = 0;
+
 	sanitise_line_reset();
 	my $line;
 	foreach my $rawline (@rawlines) {
@@ -3394,7 +3396,13 @@ sub process {
 				while ($var =~ m{($Ident)}g) {
 					my $word = $1;
 					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
-					seed_camelcase_includes() if ($check);
+					if ($check) {
+						seed_camelcase_includes();
+						if (!$file && !$camelcase_file_seeded) {
+							seed_camelcase_file($realfile);
+							$camelcase_file_seeded = 1;
+						}
+					}
 					if (!defined $camelcase{$word}) {
 						$camelcase{$word} = 1;
 						CHK("CAMELCASE",
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-make-extern-in-h-prototypes-quieter.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch

