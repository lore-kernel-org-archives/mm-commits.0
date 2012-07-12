From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:05 -0700
Message-ID: <20120712193705.B74AF100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233Ab2GLThG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:06 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so16661vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: release memory resources if hotadd_new_pgdat() fails
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: mm/memory_hotplug.c: release memory resources if hotadd_new_pgdat() fails

We should goto error to release memory resource if hotadd_new_pgdat()
failed.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails
+++ a/mm/memory_hotplug.c
@@ -618,7 +618,7 @@ int __ref add_memory(int nid, u64 start,
 		pgdat = hotadd_new_pgdat(nid, start);
 		ret = -ENOMEM;
 		if (!pgdat)
-			goto out;
+			goto error;
 		new_pgdat = 1;
 	}
 
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

