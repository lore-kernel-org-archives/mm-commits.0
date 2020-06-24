From: akpm@linux-foundation.org
Subject: +
 mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 12:19:33 -0700
Message-ID: <20200624191933.3qRAD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405057AbgFXTTe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zeil@yandex-team.ru, tony.luck@intel.com, naoya.horiguchi@nec.com, mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com, aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com, osalvador@suse.de


The patch titled
     Subject: mm,hwpoison: un-export get_hwpoison_page and make it static
has been added to the -mm tree.  Its filename is
     mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: un-export get_hwpoison_page and make it static

Since get_hwpoison_page is only used in memory-failure code now, let us
un-export it and make it private to that code.

Link: http://lkml.kernel.org/r/20200624150137.7052-7-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 -
 mm/memory-failure.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-un-export-get_hwpoison_page-and-make-it-static
+++ a/include/linux/mm.h
@@ -2994,7 +2994,6 @@ extern int memory_failure(unsigned long
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
-extern int get_hwpoison_page(struct page *page);
 #define put_hwpoison_page(page)	put_page(page)
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
--- a/mm/memory-failure.c~mmhwpoison-un-export-get_hwpoison_page-and-make-it-static
+++ a/mm/memory-failure.c
@@ -925,7 +925,7 @@ static int page_action(struct page_state
  * Return: return 0 if failed to grab the refcount, otherwise true (some
  * non-zero value.)
  */
-int get_hwpoison_page(struct page *page)
+static int get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
@@ -954,7 +954,6 @@ int get_hwpoison_page(struct page *page)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
 /*
  * Do all that is necessary to remove user space mappings. Unmap
_

Patches currently in -mm which might be from osalvador@suse.de are

mmmadvise-refactor-madvise_inject_error.patch
mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
