From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-nommuc-use-bug_on-correctly.patch removed from -mm tree
Date: Thu, 27 Jan 2011 14:43:18 -0800
Message-ID: <201101272243.p0RMhI8V004115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab1A0WpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 17:45:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bosong.ly@taobao.com, dhowells@redhat.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     mm/nommu.c: use BUG_ON correctly
has been removed from the -mm tree.  Its filename was
     mm-nommuc-use-bug_on-correctly.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/nommu.c: use BUG_ON correctly
From: Coly Li <bosong.ly@taobao.com>

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/nommu.c~mm-nommuc-use-bug_on-correctly mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-use-bug_on-correctly
+++ a/mm/nommu.c
@@ -534,16 +534,16 @@ static noinline void validate_nommu_regi
 		return;
 
 	last = rb_entry(lastp, struct vm_region, vm_rb);
-	BUG_ON(unlikely(last->vm_end <= last->vm_start));
-	BUG_ON(unlikely(last->vm_top < last->vm_end));
+	BUG_ON(last->vm_end <= last->vm_start);
+	BUG_ON(last->vm_top < last->vm_end);
 
 	while ((p = rb_next(lastp))) {
 		region = rb_entry(p, struct vm_region, vm_rb);
 		last = rb_entry(lastp, struct vm_region, vm_rb);
 
-		BUG_ON(unlikely(region->vm_end <= region->vm_start));
-		BUG_ON(unlikely(region->vm_top < region->vm_end));
-		BUG_ON(unlikely(region->vm_start < last->vm_top));
+		BUG_ON(region->vm_end <= region->vm_start);
+		BUG_ON(region->vm_top < region->vm_end);
+		BUG_ON(region->vm_start < last->vm_top);
 
 		lastp = p;
 	}
_

Patches currently in -mm which might be from bosong.ly@taobao.com are


