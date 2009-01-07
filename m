From: akpm@linux-foundation.org
Subject: - checkpatch-struct-file_operations-should-normally-be-const.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:08 -0800
Message-ID: <200901072217.n07MH8ZP016762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762070AbZAGWRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:17:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: struct file_operations should normally be const
has been removed from the -mm tree.  Its filename was
     checkpatch-struct-file_operations-should-normally-be-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: struct file_operations should normally be const
From: Andy Whitcroft <apw@canonical.com>

In the general use case struct file_operations should be a const object. 
Check for and warn where it is not.  As suggested by Steven and Ingo.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-struct-file_operations-should-normally-be-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-struct-file_operations-should-normally-be-const
+++ a/scripts/checkpatch.pl
@@ -2509,6 +2509,11 @@ sub process {
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
+# check for struct file_operations, ensure they are const.
+		if ($line =~ /\bstruct\s+file_operations\b/ &&
+		    $line !~ /\bconst\b/) {
+			WARN("struct file_operations should normally be const\n" . $herecurr);
+		}
 
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch

