From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-drop-unlikely-behind-bug_on.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:15:47 -0800
Message-ID: <563d0a73.FDO3QVJ7GMmhpw7j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031654AbbKFUPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu.c: drop unlikely inside BUG_ON()
has been removed from the -mm tree.  Its filename was
     mm-nommu-drop-unlikely-behind-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/nommu.c: drop unlikely inside BUG_ON()

(1) For !CONFIG_BUG cases, the bug call is a no-op, so we couldn't
    care less and the change is ok.

(2) ppc and mips, which HAVE_ARCH_BUG_ON, do not rely on branch
    predictions as it seems to be pointless[1] and thus callers should not
    be trying to push an optimization in the first place.

(3) For CONFIG_BUG and !HAVE_ARCH_BUG_ON cases, BUG_ON() contains an
    unlikely compiler flag already.

Hence, we can drop unlikely behind BUG_ON().

[1] http://lkml.iu.edu/hypermail/linux/kernel/1101.3/02289.html

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/nommu.c~mm-nommu-drop-unlikely-behind-bug_on mm/nommu.c
--- a/mm/nommu.c~mm-nommu-drop-unlikely-behind-bug_on
+++ a/mm/nommu.c
@@ -578,16 +578,16 @@ static noinline void validate_nommu_regi
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

Patches currently in -mm which might be from geliangtang@163.com are

zram-make-is_partial_io-valid_io_request-page_zero_filled-return-boolean.patch

