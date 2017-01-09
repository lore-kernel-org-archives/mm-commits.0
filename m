From: akpm@linux-foundation.org
Subject: + checkpatchpl-warn-against-using-%z.patch added to -mm tree
Date: Mon, 09 Jan 2017 14:06:51 -0800
Message-ID: <5874097b.9qSu0RzumDZgC5iZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932080AbdAIWFY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 17:05:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch.pl: warn against using %Z
has been added to the -mm tree.  Its filename is
     checkpatchpl-warn-against-using-%z.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-warn-against-using-%25z.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-warn-against-using-%25z.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: checkpatch.pl: warn against using %Z

%Z is going to be removed in favour of %z.

Link: http://lkml.kernel.org/r/20170109235955.GA6787@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-warn-against-using-%z scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-warn-against-using-%z
+++ a/scripts/checkpatch.pl
@@ -5207,6 +5207,12 @@ sub process {
 				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
 				last;
 			}
+			# check for %Z
+			if ($string =~ /(?<!%)%[\*\d\.\$]*Z[diouxX]/) {
+				WARN("PRINTF_Z",
+				     "%Z is non-standard C, use %z\n" . $herecurr);
+				last;
+			}
 			if ($string =~ /0x%[\*\d\.\$\Llzth]*[udi]/) {
 				ERROR("PRINTF_0xDECIMAL",
 				      "Prefixing 0x with decimal output is defective\n" . $herecurr);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-less-code-duplication-in-proc-cmdline.patch
lib-vsprintfc-remove-%z-support.patch
checkpatchpl-warn-against-using-%z.patch

