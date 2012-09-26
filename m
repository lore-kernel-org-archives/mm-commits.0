From: akpm@linux-foundation.org
Subject: [merged] lib-flex_proportionsc-fix-corruption-of-denominator-in-flexible-proportions.patch removed from -mm tree
Date: Wed, 26 Sep 2012 12:35:34 -0700
Message-ID: <20120926193534.692F41E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53673 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab2IZTff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 15:35:35 -0400
Received: by qcqs25 with SMTP id s25so113303qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 12:35:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, a.p.zijlstra@chello.nl, bp@amd64.org, conny.seidel@amd.com, fengguang.wu@intel.com, srivatsa.bhat@linux.vnet.ibm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/flex_proportions.c: fix corruption of denominator in flexible proportions
has been removed from the -mm tree.  Its filename was
     lib-flex_proportionsc-fix-corruption-of-denominator-in-flexible-proportions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: lib/flex_proportions.c: fix corruption of denominator in flexible proportions

When racing with CPU hotplug, percpu_counter_sum() can return negative
values for the number of observed events.  This confuses
fprop_new_period(), which uses unsigned type and as a result number of
events is set to big *positive* number.  From that moment on, things go
pear shaped and can result e.g.  in division by zero as denominator is
later truncated to 32-bits.

This bug causes a divide-by-zero oops in bdi_dirty_limit() in Borislav's
3.6.0-rc6 based kernel.

Fix the issue by using a signed type in fprop_new_period().  That makes us
bail out from the function without doing anything (mistakenly) thinking
there are no events to age.  That makes aging somewhat inaccurate but
getting accurate data would be rather hard.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Borislav Petkov <bp@amd64.org>
Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_proportions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/flex_proportions.c~lib-flex_proportionsc-fix-corruption-of-denominator-in-flexible-proportions lib/flex_proportions.c
--- a/lib/flex_proportions.c~lib-flex_proportionsc-fix-corruption-of-denominator-in-flexible-proportions
+++ a/lib/flex_proportions.c
@@ -62,7 +62,7 @@ void fprop_global_destroy(struct fprop_g
  */
 bool fprop_new_period(struct fprop_global *p, int periods)
 {
-	u64 events;
+	s64 events;
 	unsigned long flags;
 
 	local_irq_save(flags);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
fs-change-return-values-from-eacces-to-eperm.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

