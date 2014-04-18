From: akpm@linux-foundation.org
Subject: + checkpatch-fix-wildcard-dt-compatible-string-checking.patch
 added to -mm tree
Date: Fri, 18 Apr 2014 11:50:00 -0700
Message-ID: <535173d8.Nfr720GLBLYaJUrD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRSuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 14:50:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, florian.vaussard@epfl.ch, apw@canonical.com, alexandre.belloni@free-electrons.com, robh@kernel.org

Subject: + checkpatch-fix-wildcard-dt-compatible-string-checking.patch added to -mm tree
To: robh@kernel.org,alexandre.belloni@free-electrons.com,apw@canonical.com,florian.vaussard@epfl.ch,joe@perches.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 11:50:00 -0700


The patch titled
     Subject: checkpatch: fix wildcard DT compatible string checking
has been added to the -mm tree.  Its filename is
     checkpatch-fix-wildcard-dt-compatible-string-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-wildcard-dt-compatible-string-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-wildcard-dt-compatible-string-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Herring <robh@kernel.org>
Subject: checkpatch: fix wildcard DT compatible string checking

We attempt to search for compatible strings which use a variable token in
the documented name such as <chip> or <soc>.  While this was attempted to
be handled, it's utterly broken.

The desired forms of matching are:

vendor,<chip>-*
vendor,name<part#>-*

For <chip>, lower case characters and numbers are permitted.  For <part#>,
only numeric values are allowed.

With this change, the number of missing compatible strings reported in
arch/arm/boot/dts is reduced from 1071 to 960.

Reported-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-wildcard-dt-compatible-string-checking scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-wildcard-dt-compatible-string-checking
+++ a/scripts/checkpatch.pl
@@ -2093,8 +2093,10 @@ sub process {
 
 			foreach my $compat (@compats) {
 				my $compat2 = $compat;
-				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
-				`grep -Erq "$compat|$compat2" $dt_path`;
+				$compat2 =~ s/\,[a-zA-Z0-9]*\-/\,<\.\*>\-/;
+				my $compat3 = $compat;
+				$compat3 =~ s/\,([a-z]*)[0-9]*\-/\,$1<\.\*>\-/;
+				`grep -Erq "$compat|$compat2|$compat3" $dt_path`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
 					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
_

Patches currently in -mm which might be from robh@kernel.org are

origin.patch
checkpatch-fix-wildcard-dt-compatible-string-checking.patch
linux-next.patch

