From: akpm@linux-foundation.org
Subject: [merged] headers_installpl-convert-to-headers_installsh.patch removed from -mm tree
Date: Mon, 15 Apr 2013 13:04:50 -0700
Message-ID: <20130415200450.8EBAA31C1BB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:53228 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3DOUEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 16:04:52 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so124336qad.4
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 13:04:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, dhowell@redhat.com, jwboyer@redhat.com, mmarek@suse.cz, paulmck@linux.vnet.ibm.com, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: headers_install.pl: convert to headers_install.sh
has been removed from the -mm tree.  Its filename was
     headers_installpl-convert-to-headers_installsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: headers_install.pl: convert to headers_install.sh

Remove perl from make headers_install by replacing a perl script (doing a
simple regex search and replace) with a smaller, faster, simpler,
POSIX-2008 shell script implementation.  The new shell script is a single
for loop calling sed and piping its output through unifdef to produce the
target file.

Same as last time except for minor tweak to deal with code review from
here: http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00078.html

(Note that this drops the "arch" argument, which isn't used. Kbuild
already points to the right input files on the command line.)

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowell@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.headersinst |    4 +-
 scripts/headers_install.pl   |   63 ---------------------------------
 scripts/headers_install.sh   |   43 ++++++++++++++++++++++
 3 files changed, 45 insertions(+), 65 deletions(-)

diff -puN scripts/Makefile.headersinst~headers_installpl-convert-to-headers_installsh scripts/Makefile.headersinst
--- a/scripts/Makefile.headersinst~headers_installpl-convert-to-headers_installsh
+++ a/scripts/Makefile.headersinst
@@ -72,7 +72,7 @@ printdir = $(patsubst $(INSTALL_HDR_PATH
 quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
                             file$(if $(word 2, $(all-files)),s))
       cmd_install = \
-        $(PERL) $< $(installdir) $(SRCARCH) $(input-files); \
+        $(CONFIG_SHELL) $< $(installdir) $(input-files); \
         for F in $(wrapper-files); do                                   \
                 echo "\#include <asm-generic/$$F>" > $(installdir)/$$F;    \
         done;                                                           \
@@ -98,7 +98,7 @@ __headersinst: $(subdirs) $(install-file
 	@:
 
 targets += $(install-file)
-$(install-file): scripts/headers_install.pl $(input-files) FORCE
+$(install-file): scripts/headers_install.sh $(input-files) FORCE
 	$(if $(unwanted),$(call cmd,remove),)
 	$(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
 	$(call if_changed,install)
diff -puN scripts/headers_install.pl~headers_installpl-convert-to-headers_installsh /dev/null
--- a/scripts/headers_install.pl
+++ /dev/null
@@ -1,63 +0,0 @@
-#!/usr/bin/perl -w
-#
-# headers_install prepare the listed header files for use in
-# user space and copy the files to their destination.
-#
-# Usage: headers_install.pl readdir installdir arch [files...]
-# installdir: dir to install the files to
-# arch:       current architecture
-#             arch is used to force a reinstallation when the arch
-#             changes because kbuild then detect a command line change.
-# files:      list of files to check
-#
-# Step in preparation for users space:
-# 1) Drop all use of compiler.h definitions
-# 2) Drop include of compiler.h
-# 3) Drop all sections defined out by __KERNEL__ (using unifdef)
-
-use strict;
-
-my ($installdir, $arch, @files) = @ARGV;
-
-my $unifdef = "scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__";
-
-foreach my $filename (@files) {
-	my $file = $filename;
-	$file =~ s!^.*/!!;
-
-	my $tmpfile = "$installdir/$file.tmp";
-
-	open(my $in, '<', $filename)
-	    or die "$filename: $!\n";
-	open(my $out, '>', $tmpfile)
-	    or die "$tmpfile: $!\n";
-	while (my $line = <$in>) {
-		$line =~ s/([\s(])__user\s/$1/g;
-		$line =~ s/([\s(])__force\s/$1/g;
-		$line =~ s/([\s(])__iomem\s/$1/g;
-		$line =~ s/\s__attribute_const__\s/ /g;
-		$line =~ s/\s__attribute_const__$//g;
-		$line =~ s/\b__packed\b/__attribute__((packed))/g;
-		$line =~ s/^#include <linux\/compiler.h>//;
-		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
-		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
-		$line =~ s/(^|\s|[(])(volatile)\b(\s|[(]|$)/$1__$2__$3/g;
-		$line =~ s/#ifndef\s+_UAPI/#ifndef /;
-		$line =~ s/#define\s+_UAPI/#define /;
-		$line =~ s!#endif\s+/[*]\s*_UAPI!#endif /* !;
-		printf {$out} "%s", $line;
-	}
-	close $out;
-	close $in;
-
-	system $unifdef . " $tmpfile > $installdir/$file";
-	# unifdef will exit 0 on success, and will exit 1 when the
-	# file was processed successfully but no changes were made,
-	# so abort only when it's higher than that.
-	my $e = $? >> 8;
-	if ($e > 1) {
-		die "$tmpfile: $!\n";
-	}
-	unlink $tmpfile;
-}
-exit 0;
diff -puN scripts/headers_install.sh~headers_installpl-convert-to-headers_installsh scripts/headers_install.sh
--- a/scripts/headers_install.sh~headers_installpl-convert-to-headers_installsh
+++ a/scripts/headers_install.sh
@@ -0,0 +1,43 @@
+#!/bin/sh
+
+if [ $# -lt 1 ]
+then
+	echo "Usage: headers_install.sh OUTDIR [FILES...]
+	echo
+	echo "Prepares kernel header files for use by user space, by removing"
+	echo "all compiler.h definitions and #includes, removing any"
+	echo "#ifdef __KERNEL__ sections, and putting __underscores__ around"
+	echo "asm/inline/volatile keywords."
+	echo
+	echo "OUTDIR: directory to write each userspace header FILE to."
+	echo "FILES:  list of header files to operate on."
+
+	exit 1
+fi
+
+# Grab arguments
+
+OUTDIR="$1"
+shift
+
+# Iterate through files listed on command line
+
+FILE=
+trap 'rm -f "$OUTDIR/$FILE" "$OUTDIR/$FILE.sed"' EXIT
+for i in "$@"
+do
+	FILE="$(basename "$i")"
+	sed -r \
+		-e 's/([ \t(])(__user|__force|__iomem)[ \t]/\1/g' \
+		-e 's/__attribute_const__([ \t]|$)/\1/g' \
+		-e 's@^#include <linux/compiler.h>@@' \
+		-e 's/(^|[^a-zA-Z0-9])__packed([^a-zA-Z0-9_]|$)/\1__attribute__((packed))\2/g' \
+		-e 's/(^|[ \t(])(inline|asm|volatile)([ \t(]|$)/\1__\2__\3/g' \
+		-e 's@#(ifndef|define|endif[ \t]*/[*])[ \t]*_UAPI@#\1 @' \
+		"$i" > "$OUTDIR/$FILE.sed" || exit 1
+	scripts/unifdef -U__KERNEL__ -D__EXPORTED_HEADERS__ "$OUTDIR/$FILE.sed" \
+		> "$OUTDIR/$FILE"
+	[ $? -gt 1 ] && exit 1
+	rm -f "$OUTDIR/$FILE.sed"
+done
+trap - EXIT
_

Patches currently in -mm which might be from rob@landley.net are

linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
mkcapflagspl-convert-to-mkcapflagssh.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch

