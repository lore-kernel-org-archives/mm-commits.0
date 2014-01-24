From: akpm@linux-foundation.org
Subject: [merged] headers_check-special-case-seqbuf_dump.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:00:39 -0800
Message-ID: <52e2b857.3Fkfe0UlBb+UIL3S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tiwai@suse.de, mmarek@suse.cz, arnd@arndb.de, pebolle@tiscali.nl

Subject: [merged] headers_check-special-case-seqbuf_dump.patch removed from -mm tree
To: pebolle@tiscali.nl,arnd@arndb.de,mmarek@suse.cz,tiwai@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:39 -0800


The patch titled
     Subject: headers_check: special case seqbuf_dump()
has been removed from the -mm tree.  Its filename was
     headers_check-special-case-seqbuf_dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: headers_check: special case seqbuf_dump()

"make headers_check" warns about soundcard.h for (at least) five years
now:
    [...]/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel

We're apparently stuck with providing OSSlib-3.8 compatibility, so let's
special case this declaration just to silence it.

Notes:

0) Support for OSSlib post 3.8 was already removed in commit 43a990765a
   ("sound: Remove OSSlib stuff from linux/soundcard.h").  Five years have
   passed since that commit: do people still care about OSSlib-3.8?  If
   not, quite a bit of code could be remove from soundcard.h (and probably
   ultrasound.h).

2) By the way, what is actually meant by:
    It is no longer possible to actually link against OSSlib with this
    header, but we still provide these macros for programs using them.

Doesn't that mean compatibility to OSSlib isn't even useful?

3) Anyhow, a previous discussion soundcard.h, which led to that commit,
   starts at https://lkml.org/lkml/2009/1/20/349 .

4) And, yes, I sneaked in a whitespace fix.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Takashi Iwai <tiwai@suse.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_check.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/headers_check.pl~headers_check-special-case-seqbuf_dump scripts/headers_check.pl
--- a/scripts/headers_check.pl~headers_check-special-case-seqbuf_dump
+++ a/scripts/headers_check.pl
@@ -65,7 +65,11 @@ sub check_include
 
 sub check_declarations
 {
-	if ($line =~m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
+	# soundcard.h is what it is
+	if ($line =~ m/^void seqbuf_dump\(void\);/) {
+		return;
+	}
+	if ($line =~ m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
 		printf STDERR "$filename:$lineno: " .
 			      "userspace cannot reference function or " .
 			      "variable defined in the kernel\n";
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

origin.patch
linux-next.patch

