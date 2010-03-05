From: akpm@linux-foundation.org
Subject: [folded] uml-linec-avoid-null-pointer-dereference-simplify.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:21:24 -0800
Message-ID: <201003052121.o25LLOAp028342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab0CEVV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:21:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.beregalov@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml-linec-avoid-null-pointer-dereference-simplify
has been removed from the -mm tree.  Its filename was
     uml-linec-avoid-null-pointer-dereference-simplify.patch

This patch was dropped because it was folded into uml-linec-avoid-null-pointer-dereference.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml-linec-avoid-null-pointer-dereference-simplify
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/um/drivers/line.c~uml-linec-avoid-null-pointer-dereference-simplify arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-linec-avoid-null-pointer-dereference-simplify
+++ a/arch/um/drivers/line.c
@@ -20,10 +20,8 @@ static irqreturn_t line_interrupt(int ir
 	struct line *line = chan->line;
 	struct tty_struct *tty;
 
-	if (line) {
-		tty = line->tty;
-		chan_interrupt(&line->chan_list, &line->task, tty, irq);
-	}
+	if (line)
+		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

