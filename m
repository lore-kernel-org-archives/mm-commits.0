From: akpm@linux-foundation.org
Subject: [merged] arch-powerpc-platforms-pseries-hotplug-memoryc-section-removal-cleanups.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:58:56 -0700
Message-ID: <20121011205857.21DC720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63341 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2JKU67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:58:59 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so143202wib.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:58:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/platforms/pseries/hotplug-memory.c: section removal cleanups
has been removed from the -mm tree.  Its filename was
     arch-powerpc-platforms-pseries-hotplug-memoryc-section-removal-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: arch/powerpc/platforms/pseries/hotplug-memory.c: section removal cleanups

Followups to d760afd4d25 ("memory-hotplug: suppress "Trying to free
nonexistent resource <XXXXXXXXXXXXXXXX-YYYYYYYYYYYYYYYY>" warning").

- use unsigned long type, as overflows are conceivable

- rename `i' to the less-misleading and more informative `section'

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/pseries/hotplug-memory.c~arch-powerpc-platforms-pseries-hotplug-memoryc-section-removal-cleanups arch/powerpc/platforms/pseries/hotplug-memory.c
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~arch-powerpc-platforms-pseries-hotplug-memoryc-section-removal-cleanups
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -77,8 +77,9 @@ static int pseries_remove_memblock(unsig
 {
 	unsigned long start, start_pfn;
 	struct zone *zone;
-	int i, ret;
-	int sections_to_remove;
+	int ret;
+	unsigned long section;
+	unsigned long sections_to_remove;
 
 	start_pfn = base >> PAGE_SHIFT;
 
@@ -99,8 +100,8 @@ static int pseries_remove_memblock(unsig
 	 * while writing to it. So we have to defer it to here.
 	 */
 	sections_to_remove = (memblock_size >> PAGE_SHIFT) / PAGES_PER_SECTION;
-	for (i = 0; i < sections_to_remove; i++) {
-		unsigned long pfn = start_pfn + i * PAGES_PER_SECTION;
+	for (section = 0; section < sections_to_remove; section++) {
+		unsigned long pfn = start_pfn + section * PAGES_PER_SECTION;
 		ret = __remove_pages(zone, pfn, PAGES_PER_SECTION);
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

