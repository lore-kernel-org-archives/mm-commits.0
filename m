From: akpm@linux-foundation.org
Subject: [merged] cpuidle-menu-use-div_round_closest_ull.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:16:38 -0700
Message-ID: <55355096.Er6010YJc06sAY9W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbbDTTKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javi.merino@arm.com, mgorman@suse.de, rafael.j.wysocki@intel.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuidle: menu: use DIV_ROUND_CLOSEST_ULL()
has been removed from the -mm tree.  Its filename was
     cpuidle-menu-use-div_round_closest_ull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Javi Merino <javi.merino@arm.com>
Subject: cpuidle: menu: use DIV_ROUND_CLOSEST_ULL()

Now that the kernel provides DIV_ROUND_CLOSEST_ULL(), drop the internal
implementation and use the kernel one.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-menu-use-div_round_closest_ull drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-menu-use-div_round_closest_ull
+++ a/drivers/cpuidle/governors/menu.c
@@ -190,12 +190,6 @@ static DEFINE_PER_CPU(struct menu_device
 
 static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev);
 
-/* This implements DIV_ROUND_CLOSEST but avoids 64 bit division */
-static u64 div_round64(u64 dividend, u32 divisor)
-{
-	return div_u64(dividend + (divisor / 2), divisor);
-}
