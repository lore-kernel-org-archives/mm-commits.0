From: akpm@linux-foundation.org
Subject: [nacked] markup_oops-fix-perlcritic-warnings.patch removed from -mm tree
Date: Wed, 28 Apr 2010 07:45:36 -0400
Message-ID: <201004281447.o3SEl9CR001487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709Ab0D1OrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 10:47:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, amwang@redhat.com, arjan@infradead.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     markup_oops: fix perlcritic warnings
has been removed from the -mm tree.  Its filename was
     markup_oops-fix-perlcritic-warnings.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markup_oops: fix perlcritic warnings
From: Stephen Hemminger <shemminger@vyatta.com>

Turn on strict checking.
Use local file handles and 3 argument open.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: WANG Cong <amwang@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/markup_oops.pl~markup_oops-fix-perlcritic-warnings scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~markup_oops-fix-perlcritic-warnings
+++ a/scripts/markup_oops.pl
@@ -1,5 +1,7 @@
 #!/usr/bin/perl
 
+use strict;
+
 use File::Basename;
 use Math::BigInt;
 use Getopt::Long;
@@ -126,7 +128,7 @@ sub process_x86_regs
 		$clobber = "";
 	}
 
-	foreach $reg (keys(%regs)) {
+	foreach my $reg (keys(%regs)) {
 		my $clobberprime = reg_name($clobber);
 		my $lastwordprime = reg_name($lastword);
 		my $val = $regs{$reg};
@@ -263,7 +265,7 @@ while (<FILE>) {
 	}
 }
 
-close(FILE);
+close($file);
 
 if ($counter == 0) {
 	print "No matching code found \n";
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
markup_oops-fix-perlcritic-warnings.patch

