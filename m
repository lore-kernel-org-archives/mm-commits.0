From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:17:17 -0700
Message-ID: <553550bd.D7nVxsqbs8AhCCBy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDTTK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andi@firstfloor.org, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add a test for const with __read_mostly uses
has been removed from the -mm tree.  Its filename was
     checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add a test for const with __read_mostly uses

const objects shouldn't be __read_mostly.  They are read-only.

Marking these objects as __read_mostly causes section conflicts with LTO
linking.

So add a test to try to avoid this issue.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-test-for-const-with-__read_mostly-uses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-test-for-const-with-__read_mostly-uses
+++ a/scripts/checkpatch.pl
@@ -4791,6 +4791,16 @@ sub process {
 			}
 		}
 
+# check for __read_mostly with const non-pointer (should just be const)
+		if ($line =~ /\b__read_mostly\b/ &&
+		    $line =~ /($Type)\s*$Ident/ && $1 !~ /\*\s*$/ && $1 =~ /\bconst\b/) {
+			if (ERROR("CONST_READ_MOSTLY",
+				  "Invalid use of __read_mostly with const type\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\s+__read_mostly\b//;
+			}
+		}
+
 # don't use __constant_<foo> functions outside of include/uapi/
 		if ($realfile !~ m@^include/uapi/@ &&
 		    $line =~ /(__constant_(?:htons|ntohs|[bl]e(?:16|32|64)_to_cpu|cpu_to_[bl]e(?:16|32|64)))\s*\(/) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

