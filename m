From: akpm@linux-foundation.org
Subject: [patch 003/119] scripts/decodecode: make it take multiline
 Code line
Date: Wed, 31 Jan 2018 16:14:10 -0800
Message-ID: <20180201001410.TnCS3orjP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754248AbeBAAON (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:14:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, Dave.Martin@arm.com, mm-commits@vger.kernel.org, pombredanne@nexb.com, torvalds@linux-foundation.org, will.deacon@arm.com

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
