From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_reporting-add-free-page-reporting-documentation.patch added to -mm
 tree
Date: Tue, 11 Feb 2020 16:20:07 -0800
Message-ID: <20200212002007.V-24SmzdG%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgBLAUK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 19:20:10 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com, lcapitulino@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org, mst@redhat.com, nitesh@redhat.com, osalvador@suse.de, pagupta@redhat.com, pbonzini@redhat.com, riel@surriel.com, vbabka@suse.cz, wei.w.wang@intel.com, willy@infradead.org, yang.zhang.wz@gmail.com


The patch titled
     Subject: mm/page_reporting: add free page reporting documentation
has been added to the -mm tree.  Its filename is
     mm-page_reporting-add-free-page-reporting-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_reporting-add-free-page-reporting-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_reporting-add-free-page-reporting-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: mm/page_reporting: add free page reporting documentation

Add documentation for free page reporting.  Currently the only consumer is
virtio-balloon, however it is possible that other drivers might make use
of this so it is best to add a bit of documetation explaining at a high
level how to use the API.

Link: http://lkml.kernel.org/r/20200211224730.29318.43815.stgit@localhost.localdomain
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Yang Zhang <yang.zhang.wz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/free_page_reporting.rst |   41 +++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- /dev/null
+++ a/Documentation/vm/free_page_reporting.rst
@@ -0,0 +1,41 @@
+.. _free_page_reporting:
+
+=====================
+Free Page Reporting
+=====================
+
+Free page reporting is an API by which a device can register to receive
+lists of pages that are currently unused by the system. This is useful in
+the case of virtualization where a guest is then able to use this data to
+notify the hypervisor that it is no longer using certain pages in memory.
+
+For the driver, typically a balloon driver, to use of this functionality
+it will allocate and initialize a page_reporting_dev_info structure. The
+field within the structure it will populate is the "report" function
+pointer used to process the scatterlist. It must also guarantee that it can
+handle at least PAGE_REPORTING_CAPACITY worth of scatterlist entries per
+call to the function. A call to page_reporting_register will register the
+page reporting interface with the reporting framework assuming no other
+page reporting devices are already registered.
+
+Once registered the page reporting API will begin reporting batches of
+pages to the driver. The API will start reporting pages 2 seconds after
+the interface is registered and will continue to do so 2 seconds after any
+page of a sufficiently high order is freed.
+
+Pages reported will be stored in the scatterlist passed to the reporting
+function with the final entry having the end bit set in entry nent - 1.
+While pages are being processed by the report function they will not be
+accessible to the allocator. Once the report function has been completed
+the pages will be returned to the free area from which they were obtained.
+
+Prior to removing a driver that is making use of free page reporting it
+is necessary to call page_reporting_unregister to have the
+page_reporting_dev_info structure that is currently in use by free page
+reporting removed. Doing this will prevent further reports from being
+issued via the interface. If another driver or the same driver is
+registered it is possible for it to resume where the previous driver had
+left off in terms of reporting free pages.
+
+Alexander Duyck, Dec 04, 2019
+
_

Patches currently in -mm which might be from alexander.h.duyck@linux.intel.com are

mm-adjust-shuffle-code-to-allow-for-future-coalescing.patch
mm-use-zone-and-order-instead-of-free-area-in-free_list-manipulators.patch
mm-add-function-__putback_isolated_page.patch
mm-introduce-reported-pages.patch
virtio-balloon-pull-page-poisoning-config-out-of-free-page-hinting.patch
virtio-balloon-add-support-for-providing-free-page-reports-to-host.patch
mm-page_reporting-rotate-reported-pages-to-the-tail-of-the-list.patch
mm-page_reporting-add-budget-limit-on-how-many-pages-can-be-reported-per-pass.patch
mm-page_reporting-add-free-page-reporting-documentation.patch
