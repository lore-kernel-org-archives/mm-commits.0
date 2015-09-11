From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-report-the-right-line-when-using-emacs-and-file.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:12:19 -0700
Message-ID: <55f31983.FuW3N/kDsjPhPSnl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbIKSMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: report the right line # when using --emacs and --file
has been removed from the -mm tree.  Its filename was
     checkpatch-report-the-right-line-when-using-emacs-and-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: report the right line # when using --emacs and --file

commit 34d8815f9512 ("checkpatch: add --showfile to allow input via pipe
to show filenames") broke the --emacs with --file option.

Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-report-the-right-line-when-using-emacs-and-file scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-report-the-right-line-when-using-emacs-and-file
+++ a/scripts/checkpatch.pl
@@ -2166,7 +2166,11 @@ sub process {
 		if ($showfile) {
 			$prefix = "$realfile:$realline: "
 		} elsif ($emacs) {
-			$prefix = "$filename:$linenr: ";
+			if ($file) {
+				$prefix = "$filename:$realline: ";
+			} else {
+				$prefix = "$filename:$linenr: ";
+			}
 		}
 
 		if ($found_file) {
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

