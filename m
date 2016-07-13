From: akpm@linux-foundation.org
Subject: + checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
 added to -mm tree
Date: Wed, 13 Jul 2016 15:09:29 -0700
Message-ID: <5786bc19.eXFr0JHXGLy0Y7uU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbcGMWJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 18:09:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: skip long lines that use an EFI_GUID macro
has been added to the -mm tree.  Its filename is
     checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2764,6 +2764,10 @@ sub process {
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

printk-create-pr_level-functions.patch
checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
checkpatch-allow-c99-style-comments.patch

