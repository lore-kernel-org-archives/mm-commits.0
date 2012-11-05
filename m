From: akpm@linux-foundation.org
Subject: [wrecked] acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch removed from -mm tree
Date: Mon, 05 Nov 2012 11:36:38 -0800
Message-ID: <20121105193639.2117B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33381 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2KETgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 14:36:42 -0500
Received: by mail-lb0-f202.google.com with SMTP id l12so401975lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 11:36:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acpi_memhotplug.c: remove memory info from list before freeing it
has been removed from the -mm tree.  Its filename was
     acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: acpi_memhotplug.c: remove memory info from list before freeing it

We free info, but we forget to remove it from the list.  It will cause
unexpected problems when we access the list next time.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -328,6 +328,7 @@ static int acpi_memory_disable_device(st
 			if (result)
 				return result;
 		}
+		list_del(&info->list);
 		kfree(info);
 	}
 
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

linux-next.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

