From: akpm@linux-foundation.org
Subject: + checkpatch-if-no-filenames-then-read-stdin.patch added to -mm
 tree
Date: Mon, 01 Aug 2016 16:48:33 -0700
Message-ID: <579fdfd1.MfiT6Z0S7ymq8wO2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbcHAX6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 19:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allenbh@gmail.com, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: if no filenames then read stdin
has been added to the -mm tree.  Its filename is
     checkpatch-if-no-filenames-then-read-stdin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-if-no-filenames-then-read-stdin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-if-no-filenames-then-read-stdin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Allen Hubbe <allenbh@gmail.com>
Subject: checkpatch: if no filenames then read stdin

If no filenames are given, then read the patch from stdin.

Link: http://lkml.kernel.org/r/a8784f291ccb5067361992bf5d41ff6cfb0ce5cb.1469830917.git.allenbh@gmail.com
Signed-off-by: Allen Hubbe <allenbh@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-if-no-filenames-then-read-stdin scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-if-no-filenames-then-read-stdin
+++ a/scripts/checkpatch.pl
@@ -228,9 +228,9 @@ if ($^V && $^V lt $minimum_perl_version)
 	}
 }
 
+#if no filenames are given, push '-' to read patch from stdin
 if ($#ARGV < 0) {
-	print "$P: no input files\n";
-	exit(1);
+	push(@ARGV, '-');
 }
 
 sub hash_save_array_words {
_

Patches currently in -mm which might be from allenbh@gmail.com are

checkpatch-check-signoff-when-reading-stdin.patch
checkpatch-if-no-filenames-then-read-stdin.patch

