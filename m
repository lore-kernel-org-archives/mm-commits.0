From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-for-world-writeable-sysfs-debugfs-files.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:06:54 -0800
Message-ID: <201101132009.p0DK9Z6W029970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933680Ab1AMUKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: check for world-writeable sysfs/debugfs files
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-world-writeable-sysfs-debugfs-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
sched-remove-long-deprecated-clone_stopped-flag.patch

