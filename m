From: akpm@linux-foundation.org
Subject: - cleanpatch-a-script-to-clean-up-stealth-whitespace-added-by-a-patch.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:29 -0800
Message-ID: <200703180910.l2I9ATmo020093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbXCRJKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     cleanpatch: a script to clean up stealth whitespace added by a patch
has been removed from the -mm tree.  Its filename was
     cleanpatch-a-script-to-clean-up-stealth-whitespace-added-by-a-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cleanpatch: a script to clean up stealth whitespace added by a patch
From: "H. Peter Anvin" <hpa@zytor.com>

This script is a companion to the "cleanfile" script.  This cleans up a
patch in unified diff format *before* it is applied.  Note that the empty
lines at the end of file detection *requires* that the diff was taken with
at least one line of context around each hunk, or bad things will happen.

This script cleans up various classes of stealth whitespace.  In
particular, it cleans up:

- Whitespace (spaces or tabs)before newline;
- DOS line endings (CR before LF);
- Space before tab (spaces are deleted or converted to tabs);
- Empty lines at end of file.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/cleanpatch |  206 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff -puN /dev/null scripts/cleanpatch
--- /dev/null
+++ a/scripts/cleanpatch
@@ -0,0 +1,206 @@
+#!/usr/bin/perl -w
+#
+# Clean a patch file -- or directory of patch files -- of stealth whitespace.
+# WARNING: this can be a highly destructive operation.  Use with caution.
+#
+
+use bytes;
+use File::Basename;
+
+#
+# Clean up space-tab sequences, either by removing spaces or
+# replacing them with tabs.
+sub clean_space_tabs($)
+{
+    no bytes;			# Tab alignment depends on characters
+
+    my($li) = @_;
+    my($lo) = '';
+    my $pos = 0;
+    my $nsp = 0;
+    my($i, $c);
+
+    for ($i = 0; $i < length($li); $i++) {
+	$c = substr($li, $i, 1);
+	if ($c eq "\t") {
+	    my $npos = ($pos+$nsp+8) & ~7;
+	    my $ntab = ($npos >> 3) - ($pos >> 3);
+	    $lo .= "\t" x $ntab;
+	    $pos = $npos;
+	    $nsp = 0;
+	} elsif ($c eq "\n" || $c eq "\r") {
+	    $lo .= " " x $nsp;
+	    $pos += $nsp;
+	    $nsp = 0;
+	    $lo .= $c;
+	    $pos = 0;
+	} elsif ($c eq " ") {
+	    $nsp++;
+	} else {
+	    $lo .= " " x $nsp;
+	    $pos += $nsp;
+	    $nsp = 0;
+	    $lo .= $c;
+	    $pos++;
+	}
+    }
+    $lo .= " " x $nsp;
+    return $lo;
+}
+
+$name = basename($0);
+
+foreach $f ( @ARGV ) {
+    print STDERR "$name: $f\n";
+
+    if (! -f $f) {
+	print STDERR "$f: not a file\n";
+	next;
+    }
+
+    if (!open(FILE, '+<', $f)) {
+	print STDERR "$name: Cannot open file: $f: $!\n";
+	next;
+    }
+
+    binmode FILE;
+
+    # First, verify that it is not a binary file; consider any file
+    # with a zero byte to be a binary file.  Is there any better, or
+    # additional, heuristic that should be applied?
+    $is_binary = 0;
+
+    while (read(FILE, $data, 65536) > 0) {
+	if ($data =~ /\0/) {
+	    $is_binary = 1;
+	    last;
+	}
+    }
+
+    if ($is_binary) {
+	print STDERR "$name: $f: binary file\n";
+	next;
+    }
+
+    seek(FILE, 0, 0);
+
+    $in_bytes = 0;
+    $out_bytes = 0;
+
+    @lines  = ();
+
+    $in_hunk = 0;
+    $err = 0;
+
+    while ( defined($line = <FILE>) ) {
+	$in_bytes += length($line);
+
+	if (!$in_hunk) {
+	    if ($line =~ /^\@\@\s+\-([0-9]+),([0-9]+)\s+\+([0-9]+),([0-9]+)\s\@\@/) {
+		$minus_lines = $2;
+		$plus_lines = $4;
+		if ($minus_lines || $plus_lines) {
+		    $in_hunk = 1;
+		    @hunk_lines = ($line);
+		}
+	    } else {
+		push(@lines, $line);
+		$out_bytes += length($line);
+	    }
+	} else {
+	    # We're in a hunk
+
+	    if ($line =~ /^\+/) {
+		$plus_lines--;
+
+		$text = substr($line, 1);
+		$text =~ s/[ \t\r]*$//;		# Remove trailing spaces
+		$text = clean_space_tabs($text);
+
+		push(@hunk_lines, '+'.$text);
+	    } elsif ($line =~ /^\-/) {
+		$minus_lines--;
+		push(@hunk_lines, $line);
+	    } elsif ($line =~ /^ /) {
+		$plus_lines--;
+		$minus_lines--;
+		push(@hunk_lines, $line);
+	    } else {
+		print STDERR "$name: $f: malformed patch\n";
+		$err = 1;
+		last;
+	    }
+
+	    if ($plus_lines < 0 || $minus_lines < 0) {
+		print STDERR "$name: $f: malformed patch\n";
+		$err = 1;
+		last;
+	    } elsif ($plus_lines == 0 && $minus_lines == 0) {
+		# End of a hunk.  Process this hunk.
+		my $i;
+		my $l;
+		my @h = ();
+		my $adj = 0;
+		my $done = 0;
+
+		for ($i = scalar(@hunk_lines)-1; $i > 0; $i--) {
+		    $l = $hunk_lines[$i];
+		    if (!$done && $l eq "+\n") {
+			$adj++; # Skip this line
+		    } elsif ($l =~ /^[ +]/) {
+			$done = 1;
+			unshift(@h, $l);
+		    } else {
+			unshift(@h, $l);
+		    }
+		}
+
+		$l = $hunk_lines[0];  # Hunk header
+		undef @hunk_lines;    # Free memory
+
+		if ($adj) {
+		    die unless
+			($l =~ /^\@\@\s+\-([0-9]+),([0-9]+)\s+\+([0-9]+),([0-9]+)\s\@\@(.*)$/);
+		    my $mstart = $1;
+		    my $mlin = $2;
+		    my $pstart = $3;
+		    my $plin = $4;
+		    my $tail = $5; # doesn't include the final newline
+
+		    $l = sprintf("@@ -%d,%d +%d,%d @@%s\n",
+				 $mstart, $mlin, $pstart, $plin-$adj,
+				 $tail);
+		}
+		unshift(@h, $l);
+
+		# Transfer to the output array
+		foreach $l (@h) {
+		    $out_bytes += length($l);
+		    push(@lines, $l);
+		}
+
+		$in_hunk = 0;
+	    }
+	}
+    }
+
+    if ($in_hunk) {
+	print STDERR "$name: $f: malformed patch\n";
+	$err = 1;
+    }
+
+    if (!$err) {
+	if ($in_bytes != $out_bytes) {
+	    # Only write to the file if changed
+	    seek(FILE, 0, 0);
+	    print FILE @lines;
+
+	    if ( !defined($where = tell(FILE)) ||
+		 !truncate(FILE, $where) ) {
+		die "$name: Failed to truncate modified file: $f: $!\n";
+	    }
+	}
+    }
+
+    close(FILE);
+}
_

Patches currently in -mm which might be from hpa@zytor.com are

git-kbuild.patch
devpts-add-fsnotify-create-event.patch
