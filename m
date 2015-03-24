From: akpm@linux-foundation.org
Subject: + cpuidle-menu-use-div_round_closest_ull.patch added to -mm tree
Date: Tue, 24 Mar 2015 14:01:31 -0700
Message-ID: <5511d0ab.8x7xOYksoGzVOx7d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbCXVBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javi.merino@arm.com, mgorman@suse.de, rafael.j.wysocki@intel.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuidle: menu: use DIV_ROUND_CLOSEST_ULL()
has been added to the -mm tree.  Its filename is
     cpuidle-menu-use-div_round_closest_ull.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpuidle-menu-use-div_round_closest_ull.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpuidle-menu-use-div_round_closest_ull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javi Merino <javi.merino@arm.com>
Subject: cpuidle: menu: use DIV_ROUND_CLOSEST_ULL()

Now that the kernel provides DIV_ROUND_CLOSEST_ULL(), drop the internal
implementation and use the kernel one.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
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
