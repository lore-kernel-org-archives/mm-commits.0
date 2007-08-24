From: akpm@linux-foundation.org
Subject: + script-to-check-for-undefined-kconfig-symbols.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:31:48 -0700
Message-ID: <200708242331.l7ONVnEJ020311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbXHXXch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, bunk@stusta.de, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     Script to check for undefined Kconfig symbols
has been added to the -mm tree.  Its filename is
     script-to-check-for-undefined-kconfig-symbols.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Script to check for undefined Kconfig symbols
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

To avoid having to look manually for used but undefined Kconfig variables,
I've written a script which tries do this efficiently, in case all other
attention fail.  It accounts for _MODULE suffix and for UML_ prefixes to
Kconfig variable, but otherwise looks for exact matches (i.e.  \<CONFIG_;
this is done to exclude macros like MMCONFIG_).

Undefined Kconfig variables should be not be removed without care, but for
instance arch/i386/boot/ uses a bunch of undefined Kconfig vars:

$ scripts/checkunknowndefines.sh arch/i386/boot/
arch/i386/boot/video.h uses undefined symbol VIDEO_400_HACK
arch/i386/boot/video-vga.c uses undefined symbol VIDEO_400_HACK
arch/i386/boot/video.c uses undefined symbol VIDEO_RETAIN
arch/i386/boot/video.h uses undefined symbol VIDEO_RETAIN
arch/i386/boot/video.h uses undefined symbol VIDEO_SVGA
arch/i386/boot/video.h uses undefined symbol VIDEO_VESA
arch/i386/boot/video-vesa.c uses undefined symbol VIDEO_VESA

It should also be mentioned in SubmittingPatches and SubmitChecklist.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkunknowndefines.sh |   59 +++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+)

diff -puN /dev/null scripts/checkunknowndefines.sh
--- /dev/null
+++ a/scripts/checkunknowndefines.sh
@@ -0,0 +1,59 @@
+#!/bin/sh
+# Find Kconfig variables used in source code but never defined in Kconfig
+# Copyright (C) 2007, Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
+
+# Tested with dash.
+paths="$@"
+[ -z "$paths" ] && paths=.
+
+# Doing this once at the beginning saves a lot of time, on a cache-hot tree.
+Kconfigs="`find . -name 'Kconfig' -o -name 'Kconfig*[^~]'`"
+
+echo "File list \tundefined symbol used"
+find $paths -name '*.[chS]' -o -name 'Makefile' -o -name 'Makefile*[^~]'| while read i
+do
+	# Output the bare Kconfig variable and the filename; the _MODULE part at
+	# the end is not removed here (would need perl an not-hungry regexp for that).
+	sed -ne 's!^.*\<\(UML_\)\?CONFIG_\([0-9A-Z_]\+\).*!\2 '$i'!p' < $i
+done | \
+# Smart "sort|uniq" implemented in awk and tuned to collect the names of all
+# files which use a given symbol
+awk '{map[$1, count[$1]++] = $2; }
+END {
+	for (combIdx in map) {
+		split(combIdx, separate, SUBSEP);
+		# The value may have been removed.
+		if (! ( (separate[1], separate[2]) in map ) )
+			continue;
+		symb=separate[1];
+		printf "%s ", symb;
+		#Use gawk extension to delete the names vector
+		delete names;
+		#Portably delete the names vector
+		#split("", names);
+		for (i=0; i < count[symb]; i++) {
+			names[map[symb, i]] = 1;
+			# Unfortunately, we may still encounter symb, i in the
+			# outside iteration.
+			delete map[symb, i];
+		}
+		i=0;
+		for (name in names) {
+			if (i > 0)
+				printf ", %s", name;
+			else
+				printf "%s", name;
+			i++;
+		}
+		printf "\n";
+	}
+}' |
+while read symb files; do
+	# Remove the _MODULE suffix when checking the variable name. This should
+	# be done only on tristate symbols, actually, but Kconfig parsing is
+	# beyond the purpose of this script.
+	symb_bare=`echo $symb | sed -e 's/_MODULE//'`
+	if ! grep -q "\<$symb_bare\>" $Kconfigs; then
+		echo "$files: \t$symb"
+	fi
+done|sort
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
usbmon-doc-update-mention-new-wildcard-0-bus.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
script-to-check-for-undefined-kconfig-symbols.patch
