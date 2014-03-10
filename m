From: akpm@linux-foundation.org
Subject: + checkpatch-check-compatible-strings-in-c-and-h-too.patch added
 to -mm tree
Date: Mon, 10 Mar 2014 12:09:25 -0700
Message-ID: <531e0de5.0h1dNP29HHChgWx7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbaCJTJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:09:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh@kernel.org, joe@perches.com, florian.vaussard@epfl.ch

Subject: + checkpatch-check-compatible-strings-in-c-and-h-too.patch added to -mm tree
To: florian.vaussard@epfl.ch,joe@perches.com,robh@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:09:25 -0700


The patch titled
     Subject: checkpatch: check compatible strings in .c and .h too
has been added to the -mm tree.  Its filename is
     checkpatch-check-compatible-strings-in-c-and-h-too.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-check-compatible-strings-in-c-and-h-too.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-check-compatible-strings-in-c-and-h-too.patch

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
Subject: checkpatch: check compatible strings in .c and .h too

Look for ".compatible = "foo" strings not only in .dts files, but
in .c and .h too.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Joe Perches <joe@perches.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-compatible-strings-in-c-and-h-too scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-compatible-strings-in-c-and-h-too
+++ a/scripts/checkpatch.pl
@@ -2067,8 +2067,10 @@ sub process {
 		}
 
 # check for DT compatible documentation
-		if (defined $root && $realfile =~ /\.dts/ &&
-		    $rawline =~ /^\+\s*compatible\s*=/) {
+		if (defined $root &&
+			(($realfile =~ /\.dtsi?$/ && $line =~ /^\+\s*compatible\s*=\s*\"/) ||
+			 ($realfile =~ /\.[ch]$/ && $line =~ /^\+.*\.compatible\s*=\s*\"/))) {
+
 			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
 
 			foreach my $compat (@compats) {
_

Patches currently in -mm which might be from florian.vaussard@epfl.ch are

checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
linux-next.patch

