From: akpm@linux-foundation.org
Subject: [folded] gru-support-for-asynchronous-gru-instructions-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:57:16 -0700
Message-ID: <200906172257.n5HMvGQh016771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbZFQW5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru-support-for-asynchronous-gru-instructions-fix
has been removed from the -mm tree.  Its filename was
     gru-support-for-asynchronous-gru-instructions-fix.patch

This patch was dropped because it was folded into gru-support-for-asynchronous-gru-instructions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru-support-for-asynchronous-gru-instructions-fix
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allmodconfig:

drivers/misc/sgi-gru/grufault.c: In function 'gru_intr':
drivers/misc/sgi-gru/grufault.c:475: error: 'chiplet' undeclared (first use in this function)
drivers/misc/sgi-gru/grufault.c:475: error: (Each undeclared identifier is reported only once
drivers/misc/sgi-gru/grufault.c:475: error: for each function it appears in.)


and what's this?

drivers/misc/sgi-gru/grufault.c: In function 'gru_try_dropin':
drivers/misc/sgi-gru/grufault.c:281: warning: 'ps' may be used uninitialized in this function
drivers/misc/sgi-gru/grufault.c:280: warning: 'paddr' may be used uninitialized in this function

Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-support-for-asynchronous-gru-instructions-fix drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-support-for-asynchronous-gru-instructions-fix
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -468,10 +468,6 @@ irqreturn_t gru_intr(int irq, void *dev_
 		return IRQ_NONE;
 	}
 	get_clear_fault_map(gru, &imap, &dmap);
-	gru_dbg(grudev,
-		"chiplet %d, gid %d, imap %016lx %016lx, dmap %016lx %016lx\n",
-		chiplet, gru->gs_gid, imap.fault_bits[0], imap.fault_bits[1],
-		dmap.fault_bits[0], dmap.fault_bits[1]);
 
 	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
 		complete(gru->gs_blade->bs_async_wq);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-edac_device_alloc_index.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

