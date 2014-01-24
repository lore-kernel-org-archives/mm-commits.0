From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-warning-of-future-__gfp_nofail-use.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:47 -0800
Message-ID: <52e2b89b.hVIFppRgQkUQVW85%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaAXTBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, rientjes@google.com

Subject: [merged] checkpatch-add-warning-of-future-__gfp_nofail-use.patch removed from -mm tree
To: rientjes@google.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:47 -0800


The patch titled
     Subject: checkpatch: add warning of future __GFP_NOFAIL use
has been removed from the -mm tree.  Its filename was
     checkpatch-add-warning-of-future-__gfp_nofail-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: checkpatch: add warning of future __GFP_NOFAIL use

gfp.h and page_alloc.c already specify that __GFP_NOFAIL is deprecated and
no new users should be added.

Add a warning to checkpatch to catch this.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-of-future-__gfp_nofail-use scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-of-future-__gfp_nofail-use
+++ a/scripts/checkpatch.pl
@@ -4113,6 +4113,12 @@ sub process {
 			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
 		}
 
+# check for GFP_NOWAIT use
+		if ($line =~ /\b__GFP_NOFAIL\b/) {
+			WARN("__GFP_NOFAIL",
+			     "Use of __GFP_NOFAIL is deprecated, no new users should be added\n" . $herecurr);
+		}
+
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
 			if (WARN("ONE_SEMICOLON",
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch
firmware-google-drop-select-efi-to-avoid-recursive-dependency.patch

