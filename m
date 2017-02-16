From: akpm@linux-foundation.org
Subject: +
 mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2.patch added to -mm tree
Date: Thu, 16 Feb 2017 15:50:50 -0800
Message-ID: <58a63ada.GLGErYMcqbrn4cgD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933692AbdBPXuv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2017 18:50:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin, done}
has been added to the -mm tree.  Its filename is
     mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-devm_memremap_pages-hold-device_hotplug-lock-over-mem_hotplug_begin-done-v2.patch
mm-validate-device_hotplug-is-held-for-memory-hotplug.patch
mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch

