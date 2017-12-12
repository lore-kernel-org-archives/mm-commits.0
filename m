From: akpm@linux-foundation.org
Subject: + scripts-decodecode-make-it-take-multiline-code-line.patch added to -mm tree
Date: Tue, 12 Dec 2017 12:51:09 -0800
Message-ID: <5a30413d.hJ1R4XjGHztvmTAv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbdLLUvK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 15:51:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, Dave.Martin@arm.com, pombredanne@nexb.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decodecode: make it take multiline Code line
has been added to the -mm tree.  Its filename is
     scripts-decodecode-make-it-take-multiline-code-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-decodecode-make-it-take-multiline-code-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-decodecode-make-it-take-multiline-code-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: scripts/decodecode: make it take multiline Code line

In case of running scripts/decodecode without any parameters in order to
give a copy'n'pasted Code line from, for example, email it would parse
only first line of it, while in emails it's split to few.

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

scripts-decodecode-make-it-take-multiline-code-line.patch

