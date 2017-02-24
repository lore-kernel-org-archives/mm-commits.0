From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:26:34 -0800
Message-ID: <58b0b31a.SVSXOlQ10gTJDmNe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXW0f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:26:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin, done}
has been removed from the -mm tree.  Its filename was
     mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2.patch

This patch was dropped because it was folded into mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin, done}

Link: http://lkml.kernel.org/r/148728203365.38457.17804568297887708345.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/memremap.c~mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2 kernel/memremap.c
--- a/kernel/memremap.c~mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2
+++ a/kernel/memremap.c
@@ -246,6 +246,7 @@ static void devm_memremap_pages_release(
 	/* pages are dead and unused, undo the arch mapping */
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
+
 	lock_device_hotplug();
 	mem_hotplug_begin();
 	arch_remove_memory(align_start, align_size);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done.patch
mm-validate-device_hotplug-is-held-for-memory-hotplug.patch
mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch

