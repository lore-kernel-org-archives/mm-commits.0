From: akpm@linux-foundation.org
Subject: [merged] cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:08 -0800
Message-ID: <201003091905.o29J588f031098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755626Ab0CITFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle menu: remove 8 bytes of padding on 64 bit builds
has been removed from the -mm tree.  Its filename was
     cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuidle menu: remove 8 bytes of padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder struct menu_device to remove 8 bytes of padding on 64 bit builds. 
Size drops from 136 to 128 bytes, so possibly needing one fewer cache
lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-menu-remove-8-bytes-of-padding-on-64-bit-builds
+++ a/drivers/cpuidle/governors/menu.c
@@ -100,8 +100,8 @@ struct menu_device {
 	int             needs_update;
 
 	unsigned int	expected_us;
-	u64		predicted_us;
 	unsigned int	measured_us;
+	u64		predicted_us;
 	unsigned int	exit_us;
 	unsigned int	bucket;
 	u64		correction_factor[BUCKETS];
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub.patch

