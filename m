From: akpm@linux-foundation.org
Subject: [merged] fscache-add-missing-unlock.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:37:37 -0400
Message-ID: <201003261938.o2QJca4U016700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab0CZTik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:38:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fscache: add missing unlock
has been removed from the -mm tree.  Its filename was
     fscache-add-missing-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fscache: add missing unlock
From: Dan Carpenter <error27@gmail.com>

Sparse complained about this missing spin_unlock()

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/page.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fscache/page.c~fscache-add-missing-unlock fs/fscache/page.c
--- a/fs/fscache/page.c~fscache-add-missing-unlock
+++ a/fs/fscache/page.c
@@ -881,6 +881,7 @@ submit_failed:
 	goto nobufs;
 
 nobufs_unlock_obj:
+	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 nobufs:
 	spin_unlock(&cookie->lock);
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

