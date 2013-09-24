From: akpm@linux-foundation.org
Subject: +
 checkpatch-find-camelcase-definitions-of-struct-union-enum.patch added to
 -mm tree
Date: Tue, 24 Sep 2013 16:00:29 -0700
Message-ID: <5242198d.MfaqraY3DxG4SIJS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3IXXAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:00:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-find-camelcase-definitions-of-struct-union-enum.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:00:29 -0700


The patch titled
     Subject: checkpatch: find CamelCase definitions of struct/union/enum
has been added to the -mm tree.  Its filename is
     checkpatch-find-camelcase-definitions-of-struct-union-enum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-find-camelcase-definitions-of-struct-union-enum.patch

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
Subject: checkpatch: find CamelCase definitions of struct/union/enum

Checkpatch doesn't currently find CamelCase definitions of structs, unions
or enums.

Add that ability.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-find-camelcase-definitions-of-struct-union-enum scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-find-camelcase-definitions-of-struct-union-enum
+++ a/scripts/checkpatch.pl
@@ -443,8 +443,9 @@ sub seed_camelcase_file {
 		next if ($line !~ /(?:[A-Z][a-z]|[a-z][A-Z])/);
 		if ($line =~ /^[ \t]*(?:#[ \t]*define|typedef\s+$Type)\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)/) {
 			$camelcase{$1} = 1;
-		}
-	        elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*[\(\[,;]/) {
+		} elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*[\(\[,;]/) {
+			$camelcase{$1} = 1;
+		} elsif ($line =~ /^\s*(?:union|struct|enum)\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*[;\{]/) {
 			$camelcase{$1} = 1;
 		}
 	}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-make-extern-in-h-prototypes-quieter.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch

