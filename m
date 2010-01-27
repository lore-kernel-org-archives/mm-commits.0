From: akpm@linux-foundation.org
Subject: + markup_oopspl-add-options-to-improve-cross-compilation-environments.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:45:37 -0800
Message-ID: <201001272345.o0RNjbbq007432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab0A0XqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:46:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: teawater@gmail.com, arjan@linux.intel.com


The patch titled
     markup_oops.pl: add options to improve cross-compilation environments
has been added to the -mm tree.  Its filename is
     markup_oopspl-add-options-to-improve-cross-compilation-environments.patch

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
Subject: markup_oops.pl: add options to improve cross-compilation environments
From: Hui Zhu <teawater@gmail.com>

The markup_oops.pl have 3 troubles to support cross-compiler environment:

1.  It uses objdump directly.
2.  It uses modinfo to get the message of module.
3.  It uses hex function that cannot support 64-bit number in 32-bit arch.

This patch add 3 options to markup_oops.pl:

1. -c CROSS_COMPILE	Specify the prefix used for toolchain.
2. -m MODULE_DIRNAME	Specify the module directory name.
3. Change hex function to Math::BigInt->from_hex.

After this patch, when parsing the x86_64 oops on x86, we can:

cat amd64m | perl ~/kernel/tmp/m.pl -c /home/teawater/kernel/bin/x8664- -m ./e.ko vmlinux

Signed-off-by: Hui Zhu <teawater@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |   71 +++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 10 deletions(-)

diff -puN scripts/markup_oops.pl~markup_oopspl-add-options-to-improve-cross-compilation-environments scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~markup_oopspl-add-options-to-improve-cross-compilation-environments
+++ a/scripts/markup_oops.pl
@@ -15,8 +15,46 @@ use Math::BigInt;
 # 	Arjan van de Ven <arjan@linux.intel.com>
 
 
-my $vmlinux_name = $ARGV[0];
-if (!defined($vmlinux_name)) {
+my $cross_compile = "";
+my $vmlinux_name = "";
+my $modulefile = "";
+
+# Get options
+my $option = 0;
+for (my $i = 0; $i <= $#ARGV; $i++) {
+	if ($option == 0) {
+		if ($ARGV[$i] eq "-c") {
+			$option = 1;
+		}
+		elsif ($ARGV[$i] eq "-m") {
+			$option = 2;
+		}
+		elsif ($ARGV[$i] eq "-h") {
+			usage();
+			exit;
+		}
+		elsif ($i == $#ARGV) {
+			$vmlinux_name = $ARGV[$i];
+		}
+		else {
+			usage();
+			exit;
+		}
+	}
+	elsif ($option == 1) {
+		$cross_compile = $ARGV[$i];
+		$option = 0;
+	}
+	elsif ($option == 2) {
+		$modulefile = $ARGV[$i];
+		$option = 0;
+	}
+}
+
+if ($vmlinux_name ne "") {
+	$vmlinux_name = $ARGV[$#ARGV];
+}
+else {
 	my $kerver = `uname -r`;
 	chomp($kerver);
 	$vmlinux_name = "/lib/modules/$kerver/build/vmlinux";
@@ -177,26 +215,27 @@ my $decodestart = Math::BigInt->from_hex
 my $decodestop = Math::BigInt->from_hex("0x$target") + 8192;
 if ($target eq "0") {
 	print "No oops found!\n";
-	print "Usage: \n";
-	print "    dmesg | perl scripts/markup_oops.pl vmlinux\n";
+	usage();
 	exit;
 }
 
 # if it's a module, we need to find the .ko file and calculate a load offset
 if ($module ne "") {
-	my $modulefile = `modinfo $module | grep '^filename:' | awk '{ print \$2 }'`;
-	chomp($modulefile);
+	if ($modulefile eq "") {
+		my $modulefile = `modinfo $module | grep '^filename:' | awk '{ print \$2 }'`;
+		chomp($modulefile);
+	}
 	$filename = $modulefile;
 	if ($filename eq "") {
 		print "Module .ko file for $module not found. Aborting\n";
 		exit;
 	}
 	# ok so we found the module, now we need to calculate the vma offset
-	open(FILE, "objdump -dS $filename |") || die "Cannot start objdump";
+	open(FILE, $cross_compile."objdump -dS $filename |") || die "Cannot start objdump";
 	while (<FILE>) {
 		if ($_ =~ /^([0-9a-f]+) \<$function\>\:/) {
 			my $fu = $1;
-			$vmaoffset = hex($target) - hex($fu) - hex($func_offset);
+			$vmaoffset = Math::BigInt->from_hex("0x$target") - Math::BigInt->from_hex("0x$fu") - Math::BigInt->from_hex("0x$func_offset");
 		}
 	}
 	close(FILE);
@@ -212,7 +251,7 @@ sub InRange {
 	my ($address, $target) = @_;
 	my $ad = "0x".$address;
 	my $ta = "0x".$target;
-	my $delta = hex($ad) - hex($ta);
+	my $delta = Math::BigInt->from_hex($ad) - Math::BigInt->from_hex($ta);
 
 	if (($delta > -4096) && ($delta < 4096)) {
 		return 1;
@@ -225,7 +264,7 @@ sub InRange {
 # first, parse the input into the lines array, but to keep size down,
 # we only do this for 4Kb around the sweet spot
 
-open(FILE, "objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
+open(FILE, $cross_compile."objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
 
 while (<FILE>) {
 	my $line = $_;
@@ -344,3 +383,15 @@ while ($i < $finish) {
 	$i = $i +1;
 }
 
+sub usage {
+    print <<EOT;
+Usage:
+  dmesg | perl $0 [OPTION] [VMLINUX]
+
+OPTION:
+  -c CROSS_COMPILE	Specify the prefix used for toolchain.
+  -m MODULE_DIRNAME	Specify the module directory name.
+  -h			Help
+EOT
+}
+
_

Patches currently in -mm which might be from teawater@gmail.com are

markup_oopspl-fix-func_offset-error-with-x86_64.patch
markup_oopspl-add-options-to-improve-cross-compilation-environments.patch

