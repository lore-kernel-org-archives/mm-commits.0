From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory_hotplug-disable-the-functionality-for-32b.patch
 added to -mm tree
Date: Thu, 04 Jun 2020 12:59:13 -0700
Message-ID: <20200604195913.KsECDwHeH%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgFDT7P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 15:59:15 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, david@redhat.com, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, osalvador@suse.de, richardw.yang@linux.intel.com, robin.murphy@arm.com, vamshi.k.sthambamkadi@gmail.com


The patch titled
     Subject: mm/memory_hotplug: disable the functionality for 32b
has been added to the -mm tree.  Its filename is
     memory_hotplug-disable-the-functionality-for-32b.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory_hotplug-disable-the-functionality-for-32b.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory_hotplug-disable-the-functionality-for-32b.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm/memory_hotplug: disable the functionality for 32b

Memory hotlug is broken for 32b systems at least since c6f03e2903c9 ("mm,
memory_hotplug: remove zone restrictions") which has considerably reworked
how can be memory associated with movable/kernel zones.  The same is not
really trivial to achieve in 32b where only lowmem is the kernel zone. 
While we can tweak this immediate problem around there are likely other
land mines hidden at other places.

It is also quite dubious that there is a real usecase for the memory
hotplug on 32b in the first place.  Low memory is just too small to be
hotplugable (for hot add) and generally unusable for hotremove.  Adding
more memory to highmem is also dubious because it would increase the low
mem or vmalloc space pressure for memmaps.

Restrict the functionality to 64b systems.  This will help future
development to focus on usecases that have real life application.  We can
remove this restriction in future in presence of a real life usecase of
course but until then make it explicit that hotplug on 32b is broken and
requires a non trivial amount of work to fix.

Robin said:

: 32-bit Arm doesn't support memory hotplug, and as far as I'm aware there's
: little likelihood of it ever wanting to.  FWIW it looks like SuperH is the
: only pure-32-bit architecture to have hotplug support at all.

Link: http://lkml.kernel.org/r/20200218100532.GA4151@dhcp22.suse.cz
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206401
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~memory_hotplug-disable-the-functionality-for-32b
+++ a/mm/Kconfig
@@ -155,6 +155,7 @@ config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on 64BIT || BROKEN
 	select NUMA_KEEP_MEMINFO if NUMA
 
 config MEMORY_HOTPLUG_SPARSE
_

Patches currently in -mm which might be from mhocko@kernel.org are

memory_hotplug-disable-the-functionality-for-32b.patch
