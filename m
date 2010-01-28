From: akpm@linux-foundation.org
Subject: + markup_oopspl-add-options-to-improve-cross-compilation-environments-update.patch added to -mm tree
Date: Wed, 27 Jan 2010 16:20:40 -0800
Message-ID: <201001280020.o0S0KeSQ009123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850Ab0A1AVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 19:21:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hui.zhu@windriver.com, arjan@linux.intel.com, teawater@gmail.com, xiyou.wangcong@gmail.com


The patch titled
     markup_oopspl-add-options-to-improve-cross-compilation-environments-update
has been added to the -mm tree.  Its filename is
     markup_oopspl-add-options-to-improve-cross-compilation-environments-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markup_oopspl-add-options-to-improve-cross-compilation-environments-update
From: Hui Zhu <hui.zhu@windriver.com>

Signed-off-by: Hui Zhu <teawater@gmail.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |   58 ++++++++++-----------------------------
 1 file changed, 15 insertions(+), 43 deletions(-)

diff -puN scripts/markup_oops.pl~markup_oopspl-add-options-to-improve-cross-compilation-environments-update scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~markup_oopspl-add-options-to-improve-cross-compilation-environments-update
+++ a/scripts/markup_oops.pl
@@ -2,6 +2,7 @@
 
 use File::Basename;
 use Math::BigInt;
+use Getopt::Long;
 
 # Copyright 2008, Intel Corporation
 #
@@ -20,50 +21,21 @@ my $vmlinux_name = "";
 my $modulefile = "";
 
 # Get options
-my $option = 0;
-for (my $i = 0; $i <= $#ARGV; $i++) {
-	if ($option == 0) {
-		if ($ARGV[$i] eq "-c") {
-			$option = 1;
-		}
-		elsif ($ARGV[$i] eq "-m") {
-			$option = 2;
-		}
-		elsif ($ARGV[$i] eq "-h") {
-			usage();
-			exit;
-		}
-		elsif ($i == $#ARGV) {
-			$vmlinux_name = $ARGV[$i];
-		}
-		else {
-			usage();
-			exit;
-		}
-	}
-	elsif ($option == 1) {
-		$cross_compile = $ARGV[$i];
-		$option = 0;
-	}
-	elsif ($option == 2) {
-		$modulefile = $ARGV[$i];
-		$option = 0;
-	}
-}
-
-if ($vmlinux_name ne "") {
-	$vmlinux_name = $ARGV[$#ARGV];
-}
-else {
+Getopt::Long::GetOptions(
+	'cross-compile|c=s'	=> \$cross_compile,
+	'module|m=s'	=> \$modulefile,
+	'help|h'		=> \&usage,
+);
+my $vmlinux_name = $ARGV[$#ARGV];
+if (!defined($vmlinux_name)) {
 	my $kerver = `uname -r`;
 	chomp($kerver);
 	$vmlinux_name = "/lib/modules/$kerver/build/vmlinux";
 	print "No vmlinux specified, assuming $vmlinux_name\n";
 }
 my $filename = $vmlinux_name;
-#
-# Step 1: Parse the oops to find the EIP value
-#
+
+# Parse the oops to find the EIP value
 
 my $target = "0";
 my $function;
@@ -216,7 +188,6 @@ my $decodestop = Math::BigInt->from_hex(
 if ($target eq "0") {
 	print "No oops found!\n";
 	usage();
-	exit;
 }
 
 # if it's a module, we need to find the .ko file and calculate a load offset
@@ -384,14 +355,15 @@ while ($i < $finish) {
 }
 
 sub usage {
-    print <<EOT;
+	print <<EOT;
 Usage:
   dmesg | perl $0 [OPTION] [VMLINUX]
 
 OPTION:
-  -c CROSS_COMPILE	Specify the prefix used for toolchain.
-  -m MODULE_DIRNAME	Specify the module directory name.
-  -h			Help
+  -c, --cross-compile CROSS_COMPILE	Specify the prefix used for toolchain.
+  -m, --module MODULE_DIRNAME		Specify the module directory name.
+  -h, --help				Help.
 EOT
+	exit;
 }
 
_

Patches currently in -mm which might be from hui.zhu@windriver.com are

markup_oopspl-add-options-to-improve-cross-compilation-environments-update.patch

