From: akpm@linux-foundation.org
Subject: + scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch added to -mm tree
Date: Mon, 24 Nov 2008 16:12:31 -0800
Message-ID: <200811250012.mAP0CVH8016169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbYKYANL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 19:13:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com


The patch titled
     scripts: script from kerneloops.org to pretty print oops dumps
has been added to the -mm tree.  Its filename is
     scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch

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
Subject: scripts: script from kerneloops.org to pretty print oops dumps
From: Arjan van de Ven <arjan@infradead.org>

We're struggling all the time to figure out where the code came from that
oopsed..  The script below (a adaption from a script used by
kerneloops.org) can help developers quite a bit, at least for non-module
cases.

It works and looks like this:

[/home/arjan/linux]$ dmesg | perl scripts/markup_oops.pl vmlinux
 {
 	struct agp_memory *memory;

 	memory = agp_allocate_memory(agp_bridge, pg_count, type);
 c055c10f:	89 c2                	mov    %eax,%edx
 	if (memory == NULL)
 c055c111:	74 19                	je     c055c12c <agp_allocate_memory_wrap+0x30>
 /* This function must only be called when current_controller != NULL */
 static void agp_insert_into_pool(struct agp_memory * temp)
 {
 	struct agp_memory *prev;

 	prev = agp_fe.current_controller->pool;
 c055c113:	a1 ec dc 8f c0       	mov    0xc08fdcec,%eax
*c055c118:	8b 40 10             	mov    0x10(%eax),%eax     <----- faulting instruction

 	if (prev != NULL) {
 c055c11b:	85 c0                	test   %eax,%eax
 c055c11d:	74 05                	je     c055c124 <agp_allocate_memory_wrap+0x28>
 		prev->prev = temp;
 c055c11f:	89 50 04             	mov    %edx,0x4(%eax)
 		temp->next = prev;
 c055c122:	89 02                	mov    %eax,(%edx)
 	}
 	agp_fe.current_controller->pool = temp;
 c055c124:	a1 ec dc 8f c0       	mov    0xc08fdcec,%eax
 c055c129:	89 50 10             	mov    %edx,0x10(%eax)
 	if (memory == NULL)
 		return NULL;

 	agp_insert_into_pool(memory);

so in this case, we faulted while dereferencing agp_fe.current_controller pointer, and we get to see
exactly which function and line it affects... Personally I find this very useful, and I can
see value for having this script in the kernel for more-than-just-me to use.

Caveats:
* It only works for oopses not-in-modules
* It only works nicely for kernels compiled with CONFIG_DEBUG_INFO
* It's not very fast.
* It only works on x86

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |  162 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 162 insertions(+)

diff -puN /dev/null scripts/markup_oops.pl
--- /dev/null
+++ a/scripts/markup_oops.pl
@@ -0,0 +1,162 @@
+#!/usr/bin/perl -w
+
+# Copyright 2008, Intel Corporation
+#
+# This file is part of the Linux kernel
+#
+# This program file is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License.
+#
+# Authors:
+# 	Arjan van de Ven <arjan@linux.intel.com>
+
+
+my $vmlinux_name = $ARGV[0];
+
+#
+# Step 1: Parse the oops to find the EIP value
+#
+
+my $target = "0";
+while (<STDIN>) {
+	if ($_ =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
+		$target = $1;
+	}
+}
+
+if ($target =~ /^f8/) {
+	print "This script does not work on modules ... \n";
+	exit;
+}
+
+if ($target eq "0") {
+	print "No oops found!\n";
+	print "Usage: \n";
+	print "    dmesg | perl scripts/markup_oops.pl vmlinux\n";
+	exit;
+}
+
+my $counter = 0;
+my $state   = 0;
+my $center  = 0;
+my @lines;
+
+sub InRange {
+	my ($address, $target) = @_;
+	my $ad = "0x".$address;
+	my $ta = "0x".$target;
+	my $delta = hex($ad) - hex($ta);
+
+	if (($delta > -4096) && ($delta < 4096)) {
+		return 1;
+	}
+	return 0;
+}
+
+
+
+# first, parse the input into the lines array, but to keep size down,
+# we only do this for 4Kb around the sweet spot
+
+my $filename;
+
+open(FILE, "objdump -dS $vmlinux_name |") || die "Cannot start objdump";
+
+while (<FILE>) {
+	my $line = $_;
+	chomp($line);
+	if ($state == 0) {
+		if ($line =~ /^([a-f0-9]+)\:/) {
+			if (InRange($1, $target)) {
+				$state = 1;
+			}
+		}
+	} else {
+		if ($line =~ /^([a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]+)\:/) {
+			my $val = $1;
+			if (!InRange($val, $target)) {
+				last;
+			}
+			if ($val eq $target) {
+				$center = $counter;
+			}
+		}
+		$lines[$counter] = $line;
+
+		$counter = $counter + 1;
+	}
+}
+
+close(FILE);
+
+if ($counter == 0) {
+	print "No matching code found \n";
+	exit;
+}
+
+if ($center == 0) {
+	print "No matching code found \n";
+	exit;
+}
+
+my $start;
+my $finish;
+my $codelines = 0;
+my $binarylines = 0;
+# now we go up and down in the array to find how much we want to print
+
+$start = $center;
+
+while ($start > 1) {
+	$start = $start - 1;
+	my $line = $lines[$start];
+	if ($line =~ /^([a-f0-9]+)\:/) {
+		$binarylines = $binarylines + 1;
+	} else {
+		$codelines = $codelines + 1;
+	}
+	if ($codelines > 10) {
+		last;
+	}
+	if ($binarylines > 20) {
+		last;
+	}
+}
+
+
+$finish = $center;
+$codelines = 0;
+$binarylines = 0;
+while ($finish < $counter) {
+	$finish = $finish + 1;
+	my $line = $lines[$finish];
+	if ($line =~ /^([a-f0-9]+)\:/) {
+		$binarylines = $binarylines + 1;
+	} else {
+		$codelines = $codelines + 1;
+	}
+	if ($codelines > 10) {
+		last;
+	}
+	if ($binarylines > 20) {
+		last;
+	}
+}
+
+
+my $i;
+
+my $fulltext = "";
+$i = $start;
+while ($i < $finish) {
+	if ($i == $center) {
+		$fulltext = $fulltext . "*$lines[$i]     <----- faulting instruction\n";
+	} else {
+		$fulltext = $fulltext .  " $lines[$i]\n";
+	}
+	$i = $i +1;
+}
+
+print $fulltext;
+
_

Patches currently in -mm which might be from arjan@infradead.org are

mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
jbd-improve-fsync-batching.patch
jbd-improve-fsync-batching-update.patch
scripts-script-from-kerneloopsorg-to-pretty-print-oops-dumps.patch
vfs-expand-some-comments-d_path-seq_path.patch

