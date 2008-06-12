From: akpm@linux-foundation.org
Subject: - hrtimer-remove-unused-variables-in-ktime_divns.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:52 -0700
Message-ID: <200806122036.m5CKaqqB005372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbYFLUgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:36:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crmafra2@gmail.com, crmafra@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hrtimer: remove unused variables in ktime_divns()
has been removed from the -mm tree.  Its filename was
     hrtimer-remove-unused-variables-in-ktime_divns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimer: remove unused variables in ktime_divns()
From: "Carlos R. Mafra" <crmafra2@gmail.com>

The variables dns and inc are not used, remove them.

Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/hrtimer.c~hrtimer-remove-unused-variables-in-ktime_divns kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-remove-unused-variables-in-ktime_divns
+++ a/kernel/hrtimer.c
@@ -300,11 +300,10 @@ EXPORT_SYMBOL_GPL(ktime_sub_ns);
  */
 u64 ktime_divns(const ktime_t kt, s64 div)
 {
-	u64 dclc, inc, dns;
+	u64 dclc;
 	int sft = 0;
 
-	dclc = dns = ktime_to_ns(kt);
-	inc = div;
+	dclc = ktime_to_ns(kt);
 	/* Make sure the divisor is less than 2^32: */
 	while (div >> 32) {
 		sft++;
_

Patches currently in -mm which might be from crmafra2@gmail.com are

linux-next.patch
drm-remove-defines-for-non-linux-systems.patch

