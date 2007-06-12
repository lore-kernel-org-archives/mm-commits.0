From: akpm@linux-foundation.org
Subject: - checkpatch-produce-fewer-lines-of-output.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:31 -0700
Message-ID: <200706121857.l5CIvVOj018479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbXFLTEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: produce fewer lines of output
has been removed from the -mm tree.  Its filename was
     checkpatch-produce-fewer-lines-of-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: checkpatch: produce fewer lines of output
From: Randy Dunlap <rdunlap@xenotime.net>

Produce one less line of output per flagged incident.

Change this:

use tabs not spaces
PATCH: /home/rddunlap/arcmsr1200014.patch4:756:
FILE: b/drivers/scsi/arcmsr/arcmsr_hba.c:1843:
+                     return PCI_ERS_RESULT_NEED_RESET;$

to this:

use tabs not spaces
#756: FILE: b/drivers/scsi/arcmsr/arcmsr_hba.c:1843:
+                     return PCI_ERS_RESULT_NEED_RESET;$


Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-produce-fewer-lines-of-output scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-produce-fewer-lines-of-output
+++ a/scripts/checkpatch.pl
@@ -290,8 +290,8 @@ sub process {
 		}
 
 #make up the handle for any error we report on this line
-		$here = "PATCH: $ARGV:$linenr:";
-		$here .= "\nFILE: $realfile:$realline:" if ($realcnt != 0);
+		$here = "#$linenr: ";
+		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
 
 		my $herecurr = "$here\n$line\n\n";
 		my $hereprev = "$here\n$prevline\n$line\n\n";
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
git-jfs-fix.patch
x86_64-pm_trace-support.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
crc7-support.patch
crc7-support-fix.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
