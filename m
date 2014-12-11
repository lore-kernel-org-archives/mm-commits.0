From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-reduce-maintainers-update-message-frequency.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:05:31 -0800
Message-ID: <5489eafb.AN28lfiyZYCSE/Ex%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbaLKTFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: reduce MAINTAINERS update message frequency
has been removed from the -mm tree.  Its filename was
     checkpatch-reduce-maintainers-update-message-frequency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: reduce MAINTAINERS update message frequency

When files are being added/moved/deleted and a patch contains an update to
the MAINTAINERS file, assume it's to update the MAINTAINERS file correctly
and do not emit the "does MAINTAINERS need updating?" message.

Reported by many people.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-maintainers-update-message-frequency scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-maintainers-update-message-frequency
+++ a/scripts/checkpatch.pl
@@ -2082,6 +2082,12 @@ sub process {
 			$in_commit_log = 0;
 		}
 
+# Check if MAINTAINERS is being updated.  If so, there's probably no need to
+# emit the "does MAINTAINERS need updating?" message on file add/move/delete
+		if ($line =~ /^\s*MAINTAINERS\s*\|/) {
+			$reported_maintainer_file = 1;
+		}
+
 # Check signature styles
 		if (!$in_header_lines &&
 		    $line =~ /^(\s*)([a-z0-9_-]+by:|$signature_tags)(\s*)(.*)/i) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

