From: akpm@linux-foundation.org
Subject: [patch 025/114] checkpatch: avoid suggesting struct
 definitions should be const
Date: Mon, 08 May 2017 15:55:45 -0700
Message-ID: <20170508225545.T79GmDLZ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdEHWzq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, ybalrid@ybalrid.info

From: Joe Perches <joe@perches.com>
Subject: checkpatch: avoid suggesting struct definitions should be const

Many structs are generally used const and there is a known list of these
structs.

struct definitions should not be generally be declared const.

Add a test for the lack of an open brace immediately after the struct to
avoid definitions.

This avoids the false positive "struct foo should normally be const"
message only when the open brace is on the same line as the definition.

Link: http://lkml.kernel.org/r/0dce709150d712e66f1b90b03827634b53b28085.1491845946.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Arthur Brainville <ybalrid@ybalrid.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-suggesting-struct-definitions-should-be-const scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-suggesting-struct-definitions-should-be-const
+++ a/scripts/checkpatch.pl
@@ -6090,11 +6090,11 @@ sub process {
 		}
 
 # check for various structs that are normally const (ops, kgdb, device_tree)
+# and avoid what seem like struct definitions 'struct foo {'
 		if ($line !~ /\bconst\b/ &&
-		    $line =~ /\bstruct\s+($const_structs)\b/) {
+		    $line =~ /\bstruct\s+($const_structs)\b(?!\s*\{)/) {
 			WARN("CONST_STRUCT",
-			     "struct $1 should normally be const\n" .
-				$herecurr);
+			     "struct $1 should normally be const\n" . $herecurr);
 		}
 
 # use of NR_CPUS is usually wrong
_
