From: akpm@linux-foundation.org
Subject: [obsolete] include-linux-mlx5-deviceh-kill-build_bug_ons.patch
 removed from -mm tree
Date: Mon, 17 Oct 2016 13:07:36 -0700
Message-ID: <58052f88.CkzekZEzdQAhO1AQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755873AbcJQUHi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 16:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mlx5/device.h: kill BUILD_BUG_ON()s
has been removed from the -mm tree.  Its filename was
     include-linux-mlx5-deviceh-kill-build_bug_ons.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/mlx5/device.h: kill BUILD_BUG_ON()s

these go splat for me


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mlx5/device.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/mlx5/device.h~include-linux-mlx5-deviceh-kill-build_bug_ons include/linux/mlx5/device.h
--- a/include/linux/mlx5/device.h~include-linux-mlx5-deviceh-kill-build_bug_ons
+++ a/include/linux/mlx5/device.h
@@ -93,8 +93,6 @@ __mlx5_mask(typ, fld))
 })
 
 #define MLX5_SET64(typ, p, fld, v) do { \
-	BUILD_BUG_ON(__mlx5_bit_sz(typ, fld) != 64); \
-	BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 64); \
 	*((__be64 *)(p) + __mlx5_64_off(typ, fld)) = cpu_to_be64(v); \
 } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix.patch
hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

