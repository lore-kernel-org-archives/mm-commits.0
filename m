From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-warn-on-logging-functions-with-kern_level.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:53 -0700
Message-ID: <543d6949.6W60Jz0HUO9EwXV2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on logging functions with KERN_<LEVEL>
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-logging-functions-with-kern_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on logging functions with KERN_<LEVEL>

Warn on probable misuses of logging functions with KERN_<LEVEL>
like pr_err(KERN_ERR "foo\n");

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-logging-functions-with-kern_level scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-logging-functions-with-kern_level
+++ a/scripts/checkpatch.pl
@@ -4447,6 +4447,17 @@ sub process {
 			}
 		}
 
+# check for logging functions with KERN_<LEVEL>
+		if ($line !~ /printk\s*\(/ &&
+		    $line =~ /\b$logFunctions\s*\(.*\b(KERN_[A-Z]+)\b/) {
+			my $level = $1;
+			if (WARN("UNNECESSARY_KERN_LEVEL",
+				 "Possible unnecessary $level\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\s*$level\s*//;
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

