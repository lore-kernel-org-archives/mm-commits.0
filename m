From: akpm@linux-foundation.org
Subject: [merged] pps-pps_kc_hardpps_lock-can-be-static.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:18 -0700
Message-ID: <20130507175018.7F38E31C48B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:39402 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab3EGRuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:19 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so86283ggl.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: pps_kc_hardpps_lock can be static
has been removed from the -mm tree.  Its filename was
     pps-pps_kc_hardpps_lock-can-be-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: pps: pps_kc_hardpps_lock can be static

drivers/pps/kc.c:37:1: sparse: symbol 'pps_kc_hardpps_lock' was not declared. Should it be static?
drivers/pps/kc.c:39:19: sparse: symbol 'pps_kc_hardpps_dev' was not declared. Should it be static?
drivers/pps/kc.c:40:5: sparse: symbol 'pps_kc_hardpps_mode' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pps/kc.c~pps-pps_kc_hardpps_lock-can-be-static drivers/pps/kc.c
--- a/drivers/pps/kc.c~pps-pps_kc_hardpps_lock-can-be-static
+++ a/drivers/pps/kc.c
@@ -34,10 +34,10 @@
  */
 
 /* state variables to bind kernel consumer */
-DEFINE_SPINLOCK(pps_kc_hardpps_lock);
+static DEFINE_SPINLOCK(pps_kc_hardpps_lock);
 /* PPS API (RFC 2783): current source and mode for kernel consumer */
-struct pps_device *pps_kc_hardpps_dev;	/* unique pointer to device */
-int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
+static struct pps_device *pps_kc_hardpps_dev;	/* unique pointer to device */
+static int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
 
 /* pps_kc_bind - control PPS kernel consumer binding
  * @pps: the PPS source
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
fat-additions-to-support-fat_fallocate-fix.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

