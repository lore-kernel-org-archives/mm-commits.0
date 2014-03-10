From: akpm@linux-foundation.org
Subject: + checkpatch-fix-spurious-vendor-compatible-warnings.patch added
 to -mm tree
Date: Mon, 10 Mar 2014 12:09:24 -0700
Message-ID: <531e0de4.htkm5REwTEmBhJ+w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaCJTJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh@kernel.org, joe@perches.com, florian.vaussard@epfl.ch

Subject: + checkpatch-fix-spurious-vendor-compatible-warnings.patch added to -mm tree
To: florian.vaussard@epfl.ch,joe@perches.com,robh@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:09:24 -0700


The patch titled
     Subject: checkpatch: fix spurious vendor compatible warnings
has been added to the -mm tree.  Its filename is
     checkpatch-fix-spurious-vendor-compatible-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-spurious-vendor-compatible-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-spurious-vendor-compatible-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Florian Vaussard <florian.vaussard@epfl.ch>
Subject: checkpatch: fix spurious vendor compatible warnings

With a compatible string like

compatible = "foo";

checkpatch will currently try to find "foo" in  vendor-prefixes.txt,
which is wrong since the vendor prefix is empty in this specific case.

Skip the vendor test if the compatible is not like

compatible = "vendor,something";

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Joe Perches <joe@perches.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-spurious-vendor-compatible-warnings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-spurious-vendor-compatible-warnings
+++ a/scripts/checkpatch.pl
@@ -2081,10 +2081,10 @@ sub process {
 					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
 				}
 
-				my $vendor = $compat;
 				my $vendor_path = $dt_path . "vendor-prefixes.txt";
 				next if (! -f $vendor_path);
-				$vendor =~ s/^([a-zA-Z0-9\-]+)\,.*/$1/;
+				next if $compat !~ /^([a-zA-Z0-9\-]+)\,/;
+				my $vendor = $1;
 				`grep -Eq "$vendor" $vendor_path`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
_

Patches currently in -mm which might be from florian.vaussard@epfl.ch are

checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
linux-next.patch

