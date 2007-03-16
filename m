From: akpm@linux-foundation.org
Subject: + cleanfile-a-script-to-clean-up-stealth-whitespace.patch added to -mm tree
Date: Thu, 15 Mar 2007 19:23:03 -0800
Message-ID: <200703160323.l2G3N3Db001466@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbXCPDXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 23:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com


The patch titled
     cleanfile: a script to clean up stealth whitespace
has been added to the -mm tree.  Its filename is
     cleanfile-a-script-to-clean-up-stealth-whitespace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanfile: a script to clean up stealth whitespace
From: "H. Peter Anvin" <hpa@zytor.com>

This script cleans up various classes of stealth whitespace.  In
particular, it cleans up:

- Whitespace (spaces or tabs)before newline;
- DOS line endings (CR before LF);
- Space before tab (spaces are deleted or converted to tabs);
- Empty lines at end of file.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/cleanfile |  126 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff -puN /dev/null scripts/cleanfile
--- /dev/null
+++ a/scripts/cleanfile
@@ -0,0 +1,126 @@
+#!/usr/bin/perl -w
+#
+# Clean a text file -- or directory of text files -- of stealth whitespace.
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
+    $blank_bytes = 0;
+
+    @blanks = ();
+    @lines  = ();
+
+    while ( defined($line = <FILE>) ) {
+	$in_bytes += length($line);
+	$line =~ s/[ \t\r]*$//;		# Remove trailing spaces
+	$line = clean_space_tabs($line);
+
+	if ( $line eq "\n" ) {
+	    push(@blanks, $line);
+	    $blank_bytes += length($line);
+	} else {
+	    push(@lines, @blanks);
+	    $out_bytes += $blank_bytes;
+	    push(@lines, $line);
+	    $out_bytes += length($line);
+	    @blanks = ();
+	    $blank_bytes = 0;
+	}
+    }
+
+    # Any blanks at the end of the file are discarded
+
+    if ($in_bytes != $out_bytes) {
+	# Only write to the file if changed
+	seek(FILE, 0, 0);
+	print FILE @lines;
+
+	if ( !defined($where = tell(FILE)) ||
+	     !truncate(FILE, $where) ) {
+	    die "$name: Failed to truncate modified file: $f: $!\n";
+	}
+    }
+
+    close(FILE);
+}
_

Patches currently in -mm which might be from hpa@zytor.com are

devpts-add-fsnotify-create-event.patch
cleanfile-a-script-to-clean-up-stealth-whitespace.patch
