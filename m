From: akpm@linux-foundation.org
Subject: + resource-add-release_mem_region_adjustable-fix-fix-fix-fix.patch added to -mm tree
Date: Thu, 11 Apr 2013 15:44:56 -0700
Message-ID: <20130411224456.D0F9A31C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:45003 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763192Ab3DKWo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 18:44:57 -0400
Received: by mail-yh0-f73.google.com with SMTP id 47so194920yhr.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 15:44:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: toshi.kani@hp.com, rientjes@google.com


The patch titled
     Subject: resource: update config option of release_mem_region_adjustable()
has been added to the -mm tree.  Its filename is
     resource-add-release_mem_region_adjustable-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: resource: update config option of release_mem_region_adjustable()

Change the config option of release_mem_region_adjustable() from
CONFIG_MEMORY_HOTPLUG to CONFIG_MEMORY_HOTREMOVE since this function
is only used for memory hot-delete.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    2 +-
 kernel/resource.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/ioport.h~resource-add-release_mem_region_adjustable-fix-fix-fix-fix include/linux/ioport.h
--- a/include/linux/ioport.h~resource-add-release_mem_region_adjustable-fix-fix-fix-fix
+++ a/include/linux/ioport.h
@@ -192,7 +192,7 @@ extern struct resource * __request_regio
 extern int __check_region(struct resource *, resource_size_t, resource_size_t);
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
-#ifdef CONFIG_MEMORY_HOTPLUG
+#ifdef CONFIG_MEMORY_HOTREMOVE
 extern int release_mem_region_adjustable(struct resource *, resource_size_t,
 				resource_size_t);
 #endif
diff -puN kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix-fix-fix kernel/resource.c
--- a/kernel/resource.c~resource-add-release_mem_region_adjustable-fix-fix-fix-fix
+++ a/kernel/resource.c
@@ -1021,7 +1021,7 @@ void __release_region(struct resource *p
 }
 EXPORT_SYMBOL(__release_region);
 
-#ifdef CONFIG_MEMORY_HOTPLUG
+#ifdef CONFIG_MEMORY_HOTREMOVE
 /**
  * release_mem_region_adjustable - release a previously reserved memory region
  * @parent: parent resource descriptor
@@ -1122,7 +1122,7 @@ int release_mem_region_adjustable(struct
 	kfree(new_res);
 	return ret;
 }
-#endif	/* CONFIG_MEMORY_HOTPLUG */
+#endif	/* CONFIG_MEMORY_HOTREMOVE */
 
 /*
  * Managed region resource
_

Patches currently in -mm which might be from toshi.kani@hp.com are

linux-next.patch
mm-walk_memory_range-fix-typo-in-comment.patch
resource-add-__adjust_resource-for-internal-use.patch
resource-add-release_mem_region_adjustable.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix-fix.patch
mm-change-__remove_pages-to-call-release_mem_region_adjustable.patch
mm-hotplug-avoid-compiling-memory-hotremove-functions-when-disabled.patch

