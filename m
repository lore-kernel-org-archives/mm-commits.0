From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-fix-wildcard-dt-compatible-string-checking.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 13:05:39 -0700
Message-ID: <5390cd93.BjYdNvQOV+o45fcs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaFEUFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, geert@linux-m68k.org, florian.vaussard@epfl.ch, apw@canonical.com, alexandre.belloni@free-electrons.com, robh@kernel.org

Subject: [merged] checkpatch-fix-wildcard-dt-compatible-string-checking.patch removed from -mm tree
To: robh@kernel.org,alexandre.belloni@free-electrons.com,apw@canonical.com,florian.vaussard@epfl.ch,geert@linux-m68k.org,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:39 -0700


The patch titled
     Subject: checkpatch: fix wildcard DT compatible string checking
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-wildcard-dt-compatible-string-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
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
linux-next.patch

