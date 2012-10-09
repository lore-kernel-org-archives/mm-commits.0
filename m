From: akpm@linux-foundation.org
Subject: + arch-powerpc-platforms-pseries-hotplug-memoryc-section-removal-cleanups.patch added to -mm tree
Date: Tue, 09 Oct 2012 14:39:48 -0700
Message-ID: <20121009213949.EFB14200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45382 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab2JIVjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 17:39:52 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so371070eek.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 14:39:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, benh@kernel.crashing.org


The patch titled
     Subject: arch/powerpc/platforms/pseries/hotplug-memory.c: section removal cleanups
has been added to the -mm tree.  Its filename is
     arch-powerpc-platforms-pseries-hotplug-memoryc-section-removal-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 		ret = __remove_pages(zone, start_pfn,  PAGES_PER_SECTION);
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
arch-powerpc-platforms-pseries-hotplug-memoryc-section-removal-cleanups.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

