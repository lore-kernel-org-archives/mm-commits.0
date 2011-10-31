From: akpm@linux-foundation.org
Subject: [folded] drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:53:10 -0700
Message-ID: <201110312353.p9VNrApK012233@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1JaXxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:53:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linus.walleij@linaro.org, naga.radheshy@stericsson.com, richard.purdie@linuxfoundation.org, srinidhi.kasagar@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch

This patch was dropped because it was folded into drivers-leds-leds-lp5521c-check-if-reset-is-successful.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix

fix up code comment

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Naga Radhesh <naga.radheshy@stericsson.com>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Cc: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix
+++ a/drivers/leds/leds-lp5521.c
@@ -687,11 +687,10 @@ static int __devinit lp5521_probe(struct
 				     */
 
 	/*
-	 * Make sure that the chip is reset by reading back
-	 * r channel current reg. This is a dummy read, otherwise
-	 * in some platforms, access to R G B channel program
-	 * execution mode to 'Run' in LP5521_REG_ENABLE register
-	 * will not have any affect - strange!
+	 * Make sure that the chip is reset by reading back the r channel
+	 * current reg. This is dummy read is required on some platforms -
+	 * otherwise further access to the R G B channels in the
+	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
 	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization.patch
mm-neaten-warn_alloc_failed.patch
debug-pagealloc-add-support-for-highmem-pages.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch
treewide-use-__printf-not-__attribute__formatprintf.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

