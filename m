From: akpm@linux-foundation.org
Subject: [merged] memcontrol-fix-potential-null-deref.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:35:46 -0400
Message-ID: <201003261936.o2QJajIg016549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab0CZTgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcontrol: fix potential null deref
has been removed from the -mm tree.  Its filename was
     memcontrol-fix-potential-null-deref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcontrol: fix potential null deref
From: Dan Carpenter <error27@gmail.com>

There was a potential null deref introduced in c62b1a3b31b5 ("memcg: use
generic percpu instead of private implementation").

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcontrol-fix-potential-null-deref mm/memcontrol.c
--- a/mm/memcontrol.c~memcontrol-fix-potential-null-deref
+++ a/mm/memcontrol.c
@@ -3691,8 +3691,10 @@ static struct mem_cgroup *mem_cgroup_all
 	else
 		mem = vmalloc(size);
 
-	if (mem)
-		memset(mem, 0, size);
+	if (!mem)
+		return NULL;
+
+	memset(mem, 0, size);
 	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
 	if (!mem->stat) {
 		if (size < PAGE_SIZE)
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

