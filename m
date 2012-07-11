From: akpm@linux-foundation.org
Subject: + acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:55:25 -0700
Message-ID: <20120711215526.9F13C5C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:39462 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab2GKVz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:55:29 -0400
Received: by weyr1 with SMTP id r1so86022wey.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:55:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, konrad.wilk@oracle.com, len.brown@intel.com, lenb@kernel.org, rientjes@google.com


The patch titled
     Subject: acpi_memhotplug.c: remove memory info from list before freeing it
has been added to the -mm tree.  Its filename is
     acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: acpi_memhotplug.c: remove memory info from list before freeing it

Patches currently in -mm which might be from wency@cn.fujitsu.com are

mm-memory_hotplugc-release-memory-resources-if-hotadd_new_pgdat-fails.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

