From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-too-short-kconfig-descriptions.patch added to -mm tree
Date: Mon, 22 Mar 2010 20:44:44 -0400
Message-ID: <201003230345.o2N3jZtI011756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297Ab0CWDqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 23:46:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, apw@shadowen.org


The patch titled
     checkpatch: add check for too short Kconfig descriptions
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-too-short-kconfig-descriptions.patch

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
Subject: checkpatch: add check for too short Kconfig descriptions
From: Andi Kleen <ak@linux.intel.com>

I've seen various new Kconfigs with rather unhelpful one liner
descriptions.  Add a Kconfig warning for a minimum length of the Kconfig
help section.

Right now I arbitarily chose 4. The exact value can be debated.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-too-short-kconfig-descriptions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-too-short-kconfig-descriptions
+++ a/scripts/checkpatch.pl
@@ -1382,6 +1382,21 @@ sub process {
 			ERROR("trailing whitespace\n" . $herevet);
 		}
 
+# check for Kconfig help text having a real description
+		if ($realfile =~ /Kconfig/ && 
+		    $line =~ /\+?\s*(---)?help(---)?$/) {
+			my $length = 0;
+			for (my $l = $linenr; defined($lines[$l]); $l++) { 
+				my $f = $lines[$l];
+				$f =~ s/#.*//; 
+				$f =~ s/^\s+//;
+				next if ($f =~ /^$/);
+				last if ($f =~ /^\s*config\s/); 
+				$length++;
+			}
+			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($length < 4);
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
hardware-latency-detector-remove-default-m.patch
drivers-base-cpuc-fix-the-output-from-sys-devices-system-cpu-offline.patch
checkpatch-add-check-for-too-short-kconfig-descriptions.patch

