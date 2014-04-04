From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-compatible-strings-in-c-and-h-too.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:20 -0700
Message-ID: <533f093c.RTOlpe4T8JjVMw7D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaDDTeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh@kernel.org, joe@perches.com, florian.vaussard@epfl.ch

Subject: [merged] checkpatch-check-compatible-strings-in-c-and-h-too.patch removed from -mm tree
To: florian.vaussard@epfl.ch,joe@perches.com,robh@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:20 -0700


The patch titled
     Subject: checkpatch: check compatible strings in .c and .h too
has been removed from the -mm tree.  Its filename was
     checkpatch-check-compatible-strings-in-c-and-h-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2074,8 +2074,10 @@ sub process {
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

origin.patch
linux-next.patch

