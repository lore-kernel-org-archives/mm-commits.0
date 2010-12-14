From: akpm@linux-foundation.org
Subject: + checkpatch-check-for-world-writeable-sysfs-debugfs-files.patch added to -mm tree
Date: Tue, 14 Dec 2010 13:40:27 -0800
Message-ID: <201012142140.oBELeRWf011358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab0LNVkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 16:40:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, apw@canonical.com


The patch titled
     checkpatch: check for world-writeable sysfs/debugfs files
has been added to the -mm tree.  Its filename is
     checkpatch-check-for-world-writeable-sysfs-debugfs-files.patch

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
Subject: checkpatch: check for world-writeable sysfs/debugfs files
From: Dave Jones <davej@redhat.com>

Exporting world writable sysfs/debugfs files is usually a bad thing.  Warn
about it.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-world-writeable-sysfs-debugfs-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-world-writeable-sysfs-debugfs-files
+++ a/scripts/checkpatch.pl
@@ -2897,6 +2897,11 @@ sub process {
 				ERROR("lockdep_no_validate class is reserved for device->mutex.\n" . $herecurr);
 			}
 		}
+
+		if ($line =~ /debugfs_create_file.*S_IWUGO/ ||
+		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
+			WARN("Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch
checkpatch-check-for-world-writeable-sysfs-debugfs-files.patch

