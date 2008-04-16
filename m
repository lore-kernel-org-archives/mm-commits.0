From: akpm@linux-foundation.org
Subject: + acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch added to -mm tree
Date: Tue, 15 Apr 2008 20:51:07 -0700
Message-ID: <200804160351.m3G3p7bG030806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754575AbYDPDvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 23:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, lenb@kernel.org, yakui.zhao@intel.com


The patch titled
     acpi: check a return value correctly in acpi_power_get_context()
has been added to the -mm tree.  Its filename is
     acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: check a return value correctly in acpi_power_get_context()
From: Li Zefan <lizf@cn.fujitsu.com>

We should check *resource != NULL rather than resource != NULL, which will be
always true.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Zhao Yakui <yakui.zhao@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/power.c~acpi-check-a-return-value-correctly-in-acpi_power_get_context drivers/acpi/power.c
--- a/drivers/acpi/power.c~acpi-check-a-return-value-correctly-in-acpi_power_get_context
+++ a/drivers/acpi/power.c
@@ -121,7 +121,7 @@ acpi_power_get_context(acpi_handle handl
 	}
 
 	*resource = acpi_driver_data(device);
-	if (!resource)
+	if (!*resource)
 		return -ENODEV;
 
 	return 0;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

memcg-fix-oops-in-oom-handling.patch
acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch
git-ia64.patch
git-net.patch
oom_kill-remove-unused-parameter-in-badness.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

