From: akpm@linux-foundation.org
Subject: + scripts-add-x86-register-parser-to-markup_oopspl.patch added to -mm tree
Date: Tue, 13 Jan 2009 15:33:43 -0800
Message-ID: <200901132333.n0DNXhNl023030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbZAMXds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 18:33:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, sam@ravnborg.org


The patch titled
     scripts: add x86 register parser to markup_oops.pl
has been added to the -mm tree.  Its filename is
     scripts-add-x86-register-parser-to-markup_oopspl.patch

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
Subject: scripts: add x86 register parser to markup_oops.pl
From: Arjan van de Ven <arjan@linux.intel.com>

An oops dump also contains the register values.

This patch parses these for (32 bit) x86, and then annotates the
disassembly with these values; this helps in analysis of the oops by the
developer, for example, NULL pointer or other pointer bugs show up clearly
this way.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |  106 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 100 insertions(+), 6 deletions(-)

diff -puN scripts/markup_oops.pl~scripts-add-x86-register-parser-to-markup_oopspl scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~scripts-add-x86-register-parser-to-markup_oopspl
+++ a/scripts/markup_oops.pl
@@ -32,6 +32,78 @@ my $module = "";
 my $func_offset;
 my $vmaoffset = 0;
 
+my %regs;
+
+
+sub parse_x86_regs
+{
+	my ($line) = @_;
+	if ($line =~ /EAX: ([0-9a-f]+) EBX: ([0-9a-f]+) ECX: ([0-9a-f]+) EDX: ([0-9a-f]+)/) {
+		$regs{"%eax"} = $1;
+		$regs{"%ebx"} = $2;
+		$regs{"%ecx"} = $3;
+		$regs{"%edx"} = $4;
+	}
+	if ($line =~ /ESI: ([0-9a-f]+) EDI: ([0-9a-f]+) EBP: ([0-9a-f]+) ESP: ([0-9a-f]+)/) {
+		$regs{"%esi"} = $1;
+		$regs{"%edi"} = $2;
+		$regs{"%esp"} = $4;
+	}
+}
+
+sub process_x86_regs
+{
+	my ($line, $cntr) = @_;
+	my $str = "";
+	if (length($line) < 40) {
+		return ""; # not an asm istruction
+	}
+
+	# find the arguments to the instruction
+	if ($line =~ /([0-9a-zA-Z\,\%\(\)\-\+]+)$/) {
+		$lastword = $1;
+	} else {
+		return "";
+	}
+
+	# we need to find the registers that get clobbered,
+	# since their value is no longer relevant for previous
+	# instructions in the stream.
+
+	$clobber = $lastword;
+	# first, remove all memory operands, they're read only
+	$clobber =~ s/\([a-z0-9\%\,]+\)//g;
+	# then, remove everything before the comma, thats the read part
+	$clobber =~ s/.*\,//g;
+
+	# if this is the instruction that faulted, we haven't actually done
+	# the write yet... nothing is clobbered.
+	if ($cntr == 0) {
+		$clobber = "";
+	}
+
+	foreach $reg (keys(%regs)) {
+		my $val = $regs{$reg};
+		# first check if we're clobbering this register; if we do
+		# we print it with a =>, and then delete its value
+		if ($clobber =~ /$reg/) {
+			if (length($val) > 0) {
+				$str = $str . " $reg => $val ";
+			}
+			$regs{$reg} = "";
+			$val = "";
+		}
+		# now check if we're reading this register
+		if ($lastword =~ /$reg/) {
+			if (length($val) > 0) {
+				$str = $str . " $reg = $val ";
+			}
+		}
+	}
+	return $str;
+}
+
+# parse the oops
 while (<STDIN>) {
 	my $line = $_;
 	if ($line =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
@@ -46,10 +118,11 @@ while (<STDIN>) {
 	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]+\W\[([a-zA-Z0-9\_\-]+)\]/) {
 		$module = $3;
 	}
+	parse_x86_regs($line);
 }
 
 my $decodestart = hex($target) - hex($func_offset);
-my $decodestop = $decodestart + 8192;
+my $decodestop = hex($target) + 8192;
 if ($target eq "0") {
 	print "No oops found!\n";
 	print "Usage: \n";
@@ -84,6 +157,7 @@ my $counter = 0;
 my $state   = 0;
 my $center  = 0;
 my @lines;
+my @reglines;
 
 sub InRange {
 	my ($address, $target) = @_;
@@ -188,16 +262,36 @@ while ($finish < $counter) {
 
 my $i;
 
-my $fulltext = "";
+
+# start annotating the registers in the asm.
+# this goes from the oopsing point back, so that the annotator
+# can track (opportunistically) which registers got written and
+# whos value no longer is relevant.
+
+$i = $center;
+while ($i >= $start) {
+	$reglines[$i] = process_x86_regs($lines[$i], $center - $i);
+	$i = $i - 1;
+}
+
 $i = $start;
 while ($i < $finish) {
+	my $line;
 	if ($i == $center) {
-		$fulltext = $fulltext . "*$lines[$i]     <----- faulting instruction\n";
+		$line =  "*$lines[$i] ";
 	} else {
-		$fulltext = $fulltext .  " $lines[$i]\n";
+		$line =  " $lines[$i] ";
+	}
+	print $line;
+	if (defined($reglines[$i]) && length($reglines[$i]) > 0) {
+		my $c = 60 - length($line);
+		while ($c > 0) { print " "; $c = $c - 1; };
+		print "| $reglines[$i]";
 	}
+	if ($i == $center) {
+		print "<--- faulting instruction";
+	}
+	print "\n";
 	$i = $i +1;
 }
 
-print $fulltext;
