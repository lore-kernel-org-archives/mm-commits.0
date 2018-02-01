From: akpm@linux-foundation.org
Subject: [merged]
 scripts-decodecode-make-it-take-multiline-code-line.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:28:52 -0800
Message-ID: <20180201192852.7CmBj5KSH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753197AbeBAT2y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, Dave.Martin@arm.com, mm-commits@vger.kernel.org, pombredanne@nexb.com, will.deacon@arm.com


The patch titled
     Subject: scripts/decodecode: make it take multiline Code line
has been removed from the -mm tree.  Its filename was
     scripts-decodecode-make-it-take-multiline-code-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: scripts/decodecode: make it take multiline Code line

In case of running scripts/decodecode without any parameters in order to
give a copy'n'pasted Code line from, for example, email it would parse
only first line of it, while in emails it's split to few.


ie, when you have a file out of oops the Code line looks like

Code: hh hh ... <hh> ... hh\n

When copy'n'paste from, for example, email where sender or some middle
MTA split it, the line looks like:

Code: hh hh ... hh\n
hh ... <hh> ... hh\n
hh hh ... hh\n

The Code line followed by another oops line usually contains characters
out of hex digit + space + < + > set.

So add logic to join this split back if and only if the following lines
have hex digits, or spaces, or '<', or '>' characters.  It will be quite
unlikely to have a broken input in well formed Oops or dmesg, thus a
simple regex is being used.

Link: http://lkml.kernel.org/r/20171212100323.33201-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN scripts/decodecode~scripts-decodecode-make-it-take-multiline-code-line scripts/decodecode
--- a/scripts/decodecode~scripts-decodecode-make-it-take-multiline-code-line
+++ a/scripts/decodecode
@@ -21,12 +21,24 @@ trap cleanup EXIT
 
 T=`mktemp` || die "cannot create temp file"
 code=
+cont=
 
 while read i ; do
 
 case "$i" in
 *Code:*)
 	code=$i
+	cont=yes
+	;;
+*)
+	[ -n "$cont" ] && {
+		xdump="$(echo $i | grep '^[[:xdigit:]<>[:space:]]\+$')"
+		if [ -n "$xdump" ]; then
+			code="$code $xdump"
+		else
+			cont=
+		fi
+	}
 	;;
 esac
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

bitmap-add-bitmap_zero-bitmap_clear-test-cases.patch
bitmap-add-bitmap_fill-bitmap_set-test-cases.patch
bitmap-clean-up-test_zero_fill_copy-test-case-and-rename.patch
bitmap-make-bitmap_fill-and-bitmap_zero-consistent.patch

