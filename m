From: akpm@linux-foundation.org
Subject: [merged] kcore-fix-test-for-end-of-list.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:37:25 -0400
Message-ID: <201003261938.o2QJcOYT016685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274Ab0CZTi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kcore: fix test for end of list
has been removed from the -mm tree.  Its filename was
     kcore-fix-test-for-end-of-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore: fix test for end of list
From: Dan Carpenter <error27@gmail.com>

"m" is never NULL here.  We need a different test for the end of list
condition.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~kcore-fix-test-for-end-of-list fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-fix-test-for-end-of-list
+++ a/fs/proc/kcore.c
@@ -490,7 +490,7 @@ read_kcore(struct file *file, char __use
 		}
 		read_unlock(&kclist_lock);
 
-		if (m == NULL) {
+		if (&m->list == &kclist_head) {
 			if (clear_user(buffer, tsz))
 				return -EFAULT;
 		} else if (is_vmalloc_or_module_addr((void *)start)) {
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
acpi_pad-processor_aggregator-name-too-long.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

