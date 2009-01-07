From: akpm@linux-foundation.org
Subject: - checkpatch-add-checks-for-in_atomic.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:28 -0800
Message-ID: <200901072216.n07MGS9l016114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761042AbZAGWQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add checks for in_atomic()
has been removed from the -mm tree.  Its filename was
     checkpatch-add-checks-for-in_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add checks for in_atomic()
From: Andy Whitcroft <apw@shadowen.org>

in_atomic() is not for driver use so report any such use as an ERROR. 
Also in_atomic() is often used to determine if we may sleep, but it is not
reliable in this use model therefore strongly discourage its use.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-checks-for-in_atomic scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-checks-for-in_atomic
+++ a/scripts/checkpatch.pl
@@ -2466,6 +2466,15 @@ sub process {
 				last;
 			}
 		}
+
+# whine mightly about in_atomic
+		if ($line =~ /\bin_atomic\s*\(/) {
+			if ($realfile =~ m@^drivers/@) {
+				ERROR("do not use in_atomic in drivers\n" . $herecurr);
+			} else {
+				WARN("use of in_atomic() is incorrect outside core kernel code\n" . $herecurr);
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch

