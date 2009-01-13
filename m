From: akpm@linux-foundation.org
Subject: + scripts-add-x86-64-bit-support-to-the-markup_oopspl-script.patch added to -mm tree
Date: Tue, 13 Jan 2009 15:33:45 -0800
Message-ID: <200901132333.n0DNXjuS023037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240AbZAMXdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 18:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, sam@ravnborg.org


The patch titled
     scripts: add x86 64 bit support to the markup_oops.pl script
has been added to the -mm tree.  Its filename is
     scripts-add-x86-64-bit-support-to-the-markup_oopspl-script.patch

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
Subject: scripts: add x86 64 bit support to the markup_oops.pl script
From: Arjan van de Ven <arjan@linux.intel.com>

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |   59 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 4 deletions(-)

diff -puN scripts/markup_oops.pl~scripts-add-x86-64-bit-support-to-the-markup_oopspl-script scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~scripts-add-x86-64-bit-support-to-the-markup_oopspl-script
+++ a/scripts/markup_oops.pl
@@ -1,4 +1,4 @@
-#!/usr/bin/perl -w
+#!/usr/bin/perl
 
 use File::Basename;
 
@@ -29,7 +29,7 @@ my $filename = $vmlinux_name;
 my $target = "0";
 my $function;
 my $module = "";
-my $func_offset;
+my $func_offset = 0;
 my $vmaoffset = 0;
 
 my %regs;
@@ -49,6 +49,39 @@ sub parse_x86_regs
 		$regs{"%edi"} = $2;
 		$regs{"%esp"} = $4;
 	}
+	if ($line =~ /RAX: ([0-9a-f]+) RBX: ([0-9a-f]+) RCX: ([0-9a-f]+)/) {
+		$regs{"%eax"} = $1;
+		$regs{"%ebx"} = $2;
+		$regs{"%ecx"} = $3;
+	}
+	if ($line =~ /RDX: ([0-9a-f]+) RSI: ([0-9a-f]+) RDI: ([0-9a-f]+)/) {
+		$regs{"%edx"} = $1;
+		$regs{"%esi"} = $2;
+		$regs{"%edi"} = $3;
+	}
+	if ($line =~ /RBP: ([0-9a-f]+) R08: ([0-9a-f]+) R09: ([0-9a-f]+)/) {
+		$regs{"%r08"} = $2;
+		$regs{"%r09"} = $3;
+	}
+	if ($line =~ /R10: ([0-9a-f]+) R11: ([0-9a-f]+) R12: ([0-9a-f]+)/) {
+		$regs{"%r10"} = $1;
+		$regs{"%r11"} = $2;
+		$regs{"%r12"} = $3;
+	}
+	if ($line =~ /R13: ([0-9a-f]+) R14: ([0-9a-f]+) R15: ([0-9a-f]+)/) {
+		$regs{"%r13"} = $1;
+		$regs{"%r14"} = $2;
+		$regs{"%r15"} = $3;
+	}
+}
+
+sub reg_name
+{
+	my ($reg) = @_;
+	$reg =~ s/r(.)x/e\1x/;
+	$reg =~ s/r(.)i/e\1i/;
+	$reg =~ s/r(.)p/e\1p/;
+	return $reg;
 }
 
 sub process_x86_regs
@@ -83,10 +116,18 @@ sub process_x86_regs
 	}
 
 	foreach $reg (keys(%regs)) {
+		my $clobberprime = reg_name($clobber);
+		my $lastwordprime = reg_name($lastword);
 		my $val = $regs{$reg};
+		if ($val =~ /^[0]+$/) {
+			$val = "0";
+		} else {
+			$val =~ s/^0*//;
+		}
+
 		# first check if we're clobbering this register; if we do
 		# we print it with a =>, and then delete its value
-		if ($clobber =~ /$reg/) {
+		if ($clobber =~ /$reg/ || $clobberprime =~ /$reg/) {
 			if (length($val) > 0) {
 				$str = $str . " $reg => $val ";
 			}
@@ -94,7 +135,7 @@ sub process_x86_regs
 			$val = "";
 		}
 		# now check if we're reading this register
-		if ($lastword =~ /$reg/) {
+		if ($lastword =~ /$reg/ || $lastwordprime =~ /$reg/) {
 			if (length($val) > 0) {
 				$str = $str . " $reg = $val ";
 			}
@@ -109,15 +150,25 @@ while (<STDIN>) {
 	if ($line =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
 		$target = $1;
 	}
+	if ($line =~ /RIP: 0010:\[\<([a-z0-9]+)\>\]/) {
+		$target = $1;
+	}
 	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
+	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+		$function = $1;
+		$func_offset = $2;
+	}
 
 	# check if it's a module
 	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]+\W\[([a-zA-Z0-9\_\-]+)\]/) {
 		$module = $3;
 	}
+	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]+\W\[([a-zA-Z0-9\_\-]+)\]/) {
+		$module = $3;
+	}
 	parse_x86_regs($line);
 }
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
scripts-add-x86-register-parser-to-markup_oopspl.patch
scripts-add-x86-64-bit-support-to-the-markup_oopspl-script.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

