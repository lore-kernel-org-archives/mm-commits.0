From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 11:12:35 -0700
Message-ID: <57a23413.hTMGJEaI+I/pAcmg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbcHCSNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: skip long lines that use an EFI_GUID macro
has been removed from the -mm tree.  Its filename was
     checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: skip long lines that use an EFI_GUID macro

These are also possible single line uses that exceed the
generic maximum line length (typically 80 columns)

Link: http://lkml.kernel.org/r/32a6a85fbd6161f1bb55ce176a464e44591afc5b.1468368420.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-skip-long-lines-that-use-an-efi_guid-macro scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-skip-long-lines-that-use-an-efi_guid-macro
+++ a/scripts/checkpatch.pl
@@ -2763,6 +2763,10 @@ sub process {
 				 $line =~ /^\+\s*#\s*define\s+\w+\s+$String$/) {
 				$msg_type = "";
 
+			# EFI_GUID is another special case
+			} elsif ($line =~ /^\+.*\bEFI_GUID\s*\(/) {
+				$msg_type = "";
+
 			# Otherwise set the alternate message types
 
 			# a comment starts before $max_line_length
_

Patches currently in -mm which might be from joe@perches.com are


