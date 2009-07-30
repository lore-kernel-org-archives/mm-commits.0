From: akpm@linux-foundation.org
Subject: [merged] markup_oops-fix-it-with-32-bit-userspace-on-a-64-bit-kernel.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:34:47 -0700
Message-ID: <200907302034.n6UKYlTB007042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbZG3Uet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, arjan@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     markup_oops: fix it with 32-bit userspace on a 64-bit kernel
has been removed from the -mm tree.  Its filename was
     markup_oops-fix-it-with-32-bit-userspace-on-a-64-bit-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markup_oops: fix it with 32-bit userspace on a 64-bit kernel
From: Matthew Wilcox <matthew@wil.cx>

A 32-bit perl can't handle 64-bit addresses without using the BigInt
package.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/markup_oops.pl~markup_oops-fix-it-with-32-bit-userspace-on-a-64-bit-kernel scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~markup_oops-fix-it-with-32-bit-userspace-on-a-64-bit-kernel
+++ a/scripts/markup_oops.pl
@@ -1,6 +1,7 @@
 #!/usr/bin/perl
 
 use File::Basename;
+use Math::BigInt;
 
 # Copyright 2008, Intel Corporation
 #
@@ -172,8 +173,8 @@ while (<STDIN>) {
 	parse_x86_regs($line);
 }
 
-my $decodestart = hex($target) - hex($func_offset);
-my $decodestop = hex($target) + 8192;
+my $decodestart = Math::BigInt->from_hex("0x$target") - Math::BigInt->from_hex("0x$func_offset");
+my $decodestop = Math::BigInt->from_hex("0x$target") + 8192;
 if ($target eq "0") {
 	print "No oops found!\n";
 	print "Usage: \n";
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
linux-next.patch
make-sure-nobodys-leaking-resources.patch

