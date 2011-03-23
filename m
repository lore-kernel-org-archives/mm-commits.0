From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-about-memset-with-swapped-arguments.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:25 -0700
Message-ID: <201103232044.p2NKi1nd029019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933310Ab1CWUoW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, apw@shadowen.org, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: warn about memset with swapped arguments
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-about-memset-with-swapped-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

