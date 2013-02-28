From: akpm@linux-foundation.org
Subject: + mkcapflagspl-convert-to-mkcapflagssh.patch added to -mm tree
Date: Thu, 28 Feb 2013 14:24:12 -0800
Message-ID: <20130228222413.DE7C25A41FD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:47262 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3B1WYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 17:24:15 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so262583ggi.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 14:24:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, dhowell@redhat.com, jwboyer@redhat.com, mmarek@suse.cz, paulmck@linux.vnet.ibm.com, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     Subject: mkcapflags.pl: convert to mkcapflags.sh
has been added to the -mm tree.  Its filename is
     mkcapflagspl-convert-to-mkcapflagssh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: mkcapflags.pl: convert to mkcapflags.sh

Generate asm-x86/cpufeature.h with posix-2008 commands instead of perl.

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowell@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/Makefile      |    4 +-
 arch/x86/kernel/cpu/mkcapflags.pl |   48 ----------------------------
 arch/x86/kernel/cpu/mkcapflags.sh |   41 +++++++++++++++++++++++
 3 files changed, 43 insertions(+), 50 deletions(-)

diff -puN arch/x86/kernel/cpu/Makefile~mkcapflagspl-convert-to-mkcapflagssh arch/x86/kernel/cpu/Makefile
--- a/arch/x86/kernel/cpu/Makefile~mkcapflagspl-convert-to-mkcapflagssh
+++ a/arch/x86/kernel/cpu/Makefile
@@ -43,10 +43,10 @@ obj-$(CONFIG_MTRR)			+= mtrr/
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
-      cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
+      cmd_mkcapflags = $(CONFIG_SHELL) $(srctree)/$(src)/mkcapflags.sh $< $@
 
 cpufeature = $(src)/../../include/asm/cpufeature.h
 
 targets += capflags.c
-$(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.pl FORCE
+$(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.sh FORCE
 	$(call if_changed,mkcapflags)
diff -puN arch/x86/kernel/cpu/mkcapflags.pl~mkcapflagspl-convert-to-mkcapflagssh /dev/null
--- a/arch/x86/kernel/cpu/mkcapflags.pl
+++ /dev/null
@@ -1,48 +0,0 @@
-#!/usr/bin/perl -w
-#
-# Generate the x86_cap_flags[] array from include/asm-x86/cpufeature.h
-#
-
-($in, $out) = @ARGV;
-
-open(IN, "< $in\0")   or die "$0: cannot open: $in: $!\n";
-open(OUT, "> $out\0") or die "$0: cannot create: $out: $!\n";
-
-print OUT "#ifndef _ASM_X86_CPUFEATURE_H\n";
-print OUT "#include <asm/cpufeature.h>\n";
-print OUT "#endif\n";
-print OUT "\n";
-print OUT "const char * const x86_cap_flags[NCAPINTS*32] = {\n";
-
-%features = ();
-$err = 0;
-
-while (defined($line = <IN>)) {
-	if ($line =~ /^\s*\#\s*define\s+(X86_FEATURE_(\S+))\s+(.*)$/) {
-		$macro = $1;
-		$feature = "\L$2";
-		$tail = $3;
-		if ($tail =~ /\/\*\s*\"([^"]*)\".*\*\//) {
-			$feature = "\L$1";
-		}
-
-		next if ($feature eq '');
-
-		if ($features{$feature}++) {
-			print STDERR "$in: duplicate feature name: $feature\n";
-			$err++;
-		}
-		printf OUT "\t%-32s = \"%s\",\n", "[$macro]", $feature;
-	}
-}
-print OUT "};\n";
-
-close(IN);
-close(OUT);
-
-if ($err) {
-	unlink($out);
-	exit(1);
-}
-
-exit(0);
diff -puN /dev/null arch/x86/kernel/cpu/mkcapflags.sh
--- /dev/null
+++ a/arch/x86/kernel/cpu/mkcapflags.sh
@@ -0,0 +1,41 @@
+#!/bin/sh
+#
+# Generate the x86_cap_flags[] array from include/asm/cpufeature.h
+#
+
+IN=$1
+OUT=$2
+
+TABS="$(printf '\t\t\t\t\t')"
+trap 'rm "$OUT"' EXIT
+
+(
+	echo "#ifndef _ASM_X86_CPUFEATURE_H"
+	echo "#include <asm/cpufeature.h>"
+	echo "#endif"
+	echo ""
+	echo "const char * const x86_cap_flags[NCAPINTS*32] = {"
+
+	# Iterate through any input lines starting with #define X86_FEATURE_
+	sed -n -e 's/\t/ /g' -e 's/^ *# *define *X86_FEATURE_//p' $IN |
+	while read i
+	do
+		# Name is everything up to the first whitespace
+		NAME="$(echo "$i" | sed 's/ .*//')"
+
+		# If the /* comment */ starts with a quote string, grab that.
+		VALUE="$(echo "$i" | sed -n 's@.*/\* *\("[^"]*"\).*\*/@\1@p')"
+		[ -z "$VALUE" ] && VALUE="\"$NAME\""
+		[ "$VALUE" == '""' ] && continue
+
+		# Name is uppercase, VALUE is all lowercase
+		VALUE="$(echo "$VALUE" | tr A-Z a-z)"
+
+		TABCOUNT=$(( ( 5*8 - 14 - $(echo "$NAME" | wc -c) ) / 8 ))
+		printf "\t[%s]%.*s = %s,\n" \
+			"X86_FEATURE_$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+	done
+	echo "};"
+) > $OUT
+
+trap - EXIT
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
linux-next.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
mkcapflagspl-convert-to-mkcapflagssh.patch
headers_installpl-convert-to-headers_installsh.patch

