From: akpm@linux-foundation.org
Subject: + include-linux-mlx5-deviceh-kill-build_bug_ons.patch added to
 -mm tree
Date: Tue, 16 Aug 2016 14:03:38 -0700
Message-ID: <57b37faa.V7wLvxUnTG/TG7ur%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbcHPVEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2016 17:04:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mlx5/device.h: kill BUILD_BUG_ON()s
has been added to the -mm tree.  Its filename is
     include-linux-mlx5-deviceh-kill-build_bug_ons.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-mlx5-deviceh-kill-build_bug_ons.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-mlx5-deviceh-kill-build_bug_ons.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch

