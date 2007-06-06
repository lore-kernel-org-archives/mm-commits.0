From: akpm@linux-foundation.org
Subject: + checkpatch-produce-fewer-lines-of-output.patch added to -mm tree
Date: Tue, 05 Jun 2007 23:59:20 -0700
Message-ID: <200706060659.l566xKEu011365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755246AbXFFG76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 02:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, apw@shadowen.org


The patch titled
     checkpatch: produce fewer lines of output
has been added to the -mm tree.  Its filename is
     checkpatch-produce-fewer-lines-of-output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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

checkpatch-produce-fewer-lines-of-output.patch
x86_64-pm_trace-support.patch
ext3-ext4-orphan-list-check-on-destroy_inode-fix.patch
crc7-support.patch
crc7-support-fix.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
