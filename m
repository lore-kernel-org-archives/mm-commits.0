From: akpm@linux-foundation.org
Subject: + checkpatch-warn-about-memset-with-swapped-arguments.patch added to -mm tree
Date: Thu, 17 Mar 2011 14:17:51 -0700
Message-ID: <201103172117.p2HLHpDG010970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473Ab1CQVSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Mar 2011 17:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, apw@shadowen.org, rostedt@goodmis.org


The patch titled
     checkpatch: warn about memset with swapped arguments
has been added to the -mm tree.  Its filename is
     checkpatch-warn-about-memset-with-swapped-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: warn about memset with swapped arguments
From: Dave Jones <davej@redhat.com>

Because the second and third arguments of memset have the same type, it
turns out to be really easy to mix them up.

This bug comes up time after time, so checkpatch should really be checking
for it at patch submission time.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-about-memset-with-swapped-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-about-memset-with-swapped-arguments
+++ a/scripts/checkpatch.pl
@@ -2902,6 +2902,11 @@ sub process {
 		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
 			WARN("Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+		# Check for memset with swapped arguments
+		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
+			ERROR("memset size is 3rd argument, not the second.\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
checkpatch-warn-about-memset-with-swapped-arguments.patch

