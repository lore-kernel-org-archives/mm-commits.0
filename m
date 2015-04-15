From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-parse-slub_debug-o-option-in-switch-statement.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 12:08:58 -0700
Message-ID: <552eb74a.uU1rzrwiu4sU4rGi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbbDOTI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris.j.arges@canonical.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: parse slub_debug O option in switch statement
has been removed from the -mm tree.  Its filename was
     mm-slub-parse-slub_debug-o-option-in-switch-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris J Arges <chris.j.arges@canonical.com>
Subject: mm/slub.c: parse slub_debug O option in switch statement

By moving the O option detection into the switch statement, we allow this
parameter to be combined with other options correctly.  Previously options
like slub_debug=OFZ would only detect the 'o' and use DEBUG_DEFAULT_FLAGS
to fill in the rest of the flags.

Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN mm/slub.c~mm-slub-parse-slub_debug-o-option-in-switch-statement mm/slub.c
--- a/mm/slub.c~mm-slub-parse-slub_debug-o-option-in-switch-statement
+++ a/mm/slub.c
@@ -1137,15 +1137,6 @@ static int __init setup_slub_debug(char
 		 */
 		goto check_slabs;
 
-	if (tolower(*str) == 'o') {
-		/*
-		 * Avoid enabling debugging on caches if its minimum order
-		 * would increase as a result.
-		 */
-		disable_higher_order_debug = 1;
-		goto out;
-	}
