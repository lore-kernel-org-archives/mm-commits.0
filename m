From: akpm@linux-foundation.org
Subject: + checkpatch-make-extern-in-h-prototypes-quieter.patch added to
 -mm tree
Date: Tue, 17 Sep 2013 14:18:52 -0700
Message-ID: <5238c73c.yLeT2G34L/pFzEsy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3IQVSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 17:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, joe@perches.com

Subject: + checkpatch-make-extern-in-h-prototypes-quieter.patch added to -mm tree
To: joe@perches.com,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 14:18:52 -0700


The patch titled
     Subject: checkpatch: make extern in .h prototypes quieter
has been added to the -mm tree.  Its filename is
     checkpatch-make-extern-in-h-prototypes-quieter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-make-extern-in-h-prototypes-quieter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-make-extern-in-h-prototypes-quieter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: make extern in .h prototypes quieter

The use of extern in .h files is a bit contentious.

Make the warning be emitted only when --strict is used on the command line.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-extern-in-h-prototypes-quieter scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-extern-in-h-prototypes-quieter
+++ a/scripts/checkpatch.pl
@@ -3975,8 +3975,8 @@ sub string_find_replace {
 # check for new externs in .h files.
 		if ($realfile =~ /\.h$/ &&
 		    $line =~ /^\+\s*(extern\s+)$Type\s*$Ident\s*\(/s) {
-			if (WARN("AVOID_EXTERNS",
-				 "extern prototypes should be avoided in .h files\n" . $herecurr) &&
+			if (CHK("AVOID_EXTERNS",
+				"extern prototypes should be avoided in .h files\n" . $herecurr) &&
 			    $fix) {
 				$fixed[$linenr - 1] =~ s/(.*)\bextern\b\s*(.*)/$1$2/;
 			}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-make-extern-in-h-prototypes-quieter.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
linux-next.patch

