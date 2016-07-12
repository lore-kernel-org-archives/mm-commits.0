From: akpm@linux-foundation.org
Subject: +
 drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug.patch
 added to -mm tree
Date: Tue, 12 Jul 2016 14:46:04 -0700
Message-ID: <5785651c.d2JFDzyQUJLxRsYu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbcGLVqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 17:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, j.anaszewski@samsung.com, mika.westerberg@linux.intel.com, tony.makkiel@daqri.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp3952.c: work around gcc-4.4.4 union initializer bug
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug.patch

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
Subject: drivers/leds/leds-lp3952.c: work around gcc-4.4.4 union initializer bug

drivers/leds/leds-lp3952.c: In function 'lp3952_set_pattern_gen_cmd':
drivers/leds/leds-lp3952.c:156: error: unknown field 'r' specified in initializer
drivers/leds/leds-lp3952.c:156: warning: missing braces around initializer
drivers/leds/leds-lp3952.c:156: warning: (near initialization for 'line.<anonymous>')
drivers/leds/leds-lp3952.c:157: error: unknown field 'g' specified in initializer
drivers/leds/leds-lp3952.c:157: warning: excess elements in struct initializer
drivers/leds/leds-lp3952.c:157: warning: (near initialization for 'line')
drivers/leds/leds-lp3952.c:158: error: unknown field 'b' specified in initializer
drivers/leds/leds-lp3952.c:158: warning: excess elements in struct initializer
drivers/leds/leds-lp3952.c:158: warning: (near initialization for 'line')
drivers/leds/leds-lp3952.c:159: error: unknown field 'cet' specified in initializer
drivers/leds/leds-lp3952.c:159: warning: excess elements in struct initializer
drivers/leds/leds-lp3952.c:159: warning: (near initialization for 'line')
drivers/leds/leds-lp3952.c:160: error: unknown field 'tt' specified in initializer
drivers/leds/leds-lp3952.c:161: warning: excess elements in struct initializer
drivers/leds/leds-lp3952.c:161: warning: (near initialization for 'line')

Fixes: 1574a45ad7467d6a8c6 ("leds: LED driver for TI LP3952 6-Channel Color LED")
Cc: Tony Makkiel <tony.makkiel@daqri.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp3952.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-lp3952.c~drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug drivers/leds/leds-lp3952.c
--- a/drivers/leds/leds-lp3952.c~drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug
+++ a/drivers/leds/leds-lp3952.c
@@ -153,11 +153,15 @@ static int lp3952_set_pattern_gen_cmd(st
 {
 	int ret;
 	struct ptrn_gen_cmd line = {
-		.r = r,
-		.g = g,
-		.b = b,
-		.cet = cet,
-		.tt = tt
+		{
+			{
+				.tt = tt,
+				.b = b,
+				.cet = cet,
+				.g = g,
+				.r = r,
+			},
+		},
 	};
 
 	if (cmd_index >= LP3952_CMD_REG_COUNT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

