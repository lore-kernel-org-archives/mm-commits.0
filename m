From: akpm@linux-foundation.org
Subject: [merged] isdn-capi-unregister-capictr-notifier-after-init-failure.patch removed from -mm tree
Date: Tue, 28 Dec 2010 12:19:42 -0800
Message-ID: <201012282020.oBSKKBVI015707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab0L1UUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Dec 2010 15:20:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, isdn@linux-pingi.de, jan.kiszka@web.de, mac@melware.de, mm-commits@vger.kernel.org


The patch titled
     isdn/capi: unregister capictr notifier after init failure
has been removed from the -mm tree.  Its filename was
     isdn-capi-unregister-capictr-notifier-after-init-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn/capi: unregister capictr notifier after init failure
From: Tejun Heo <tj@kernel.org>

capidrv_init() could leave capictr notifier dangling after init failure. 
Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Armin Schindler <mac@melware.de>
Cc: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capidrv.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/isdn/capi/capidrv.c~isdn-capi-unregister-capictr-notifier-after-init-failure drivers/isdn/capi/capidrv.c
--- a/drivers/isdn/capi/capidrv.c~isdn-capi-unregister-capictr-notifier-after-init-failure
+++ a/drivers/isdn/capi/capidrv.c
@@ -2297,6 +2297,7 @@ static int __init capidrv_init(void)
 
 	errcode = capi20_get_profile(0, &profile);
 	if (errcode != CAPI_NOERROR) {
+		unregister_capictr_notifier(&capictr_nb);
 		capi20_release(&global.ap);
 		return -EIO;
 	}
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
irq-use-per_cpu-kstat_irqs.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch
percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align.patch

