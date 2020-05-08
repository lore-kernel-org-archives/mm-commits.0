From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kexec_file-dont-place-kexec-images-on-ioresource_mem_driver_managed.patch
 added to -mm tree
Date: Fri, 08 May 2020 16:56:43 -0700
Message-ID: <20200508235643.RPICU8Zh9%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgEHX4o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:56:44 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebiederm@xmission.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com, richard.weiyang@gmail.com


The patch titled
     Subject: kexec_file: don't place kexec images on IORESOURCE_MEM_DRIVER_MANAGED
has been added to the -mm tree.  Its filename is
     kexec_file-dont-place-kexec-images-on-ioresource_mem_driver_managed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec_file-dont-place-kexec-images-on-ioresource_mem_driver_managed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec_file-dont-place-kexec-images-on-ioresource_mem_driver_managed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: kexec_file: don't place kexec images on IORESOURCE_MEM_DRIVER_MANAGED

Memory flagged with IORESOURCE_MEM_DRIVER_MANAGED is special - it won't be
part of the initial memmap of the kexec kernel and not all memory might be
accessible.  Don't place any kexec images onto it.

Link: http://lkml.kernel.org/r/20200508084217.9160-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/kexec_file.c~kexec_file-dont-place-kexec-images-on-ioresource_mem_driver_managed
+++ a/kernel/kexec_file.c
@@ -540,6 +540,11 @@ static int locate_mem_hole_callback(stru
 	unsigned long sz = end - start + 1;
 
 	/* Returning 0 will take to next memory range */
+
+	/* Don't use memory that will be detected and handled by a driver. */
+	if (res->flags & IORESOURCE_MEM_DRIVER_MANAGED)
+		return 0;
+
 	if (sz < kbuf->memsz)
 		return 0;
 
_

Patches currently in -mm which might be from david@redhat.com are

device-dax-dont-leak-kernel-memory-to-user-space-after-unloading-kmem.patch
drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
powerpc-pseries-hotplug-memory-stop-checking-is_mem_section_removable.patch
mm-memory_hotplug-remove-is_mem_section_removable.patch
mm-memory_hotplug-set-node_start_pfn-of-hotadded-pgdat-to-0.patch
mm-memory_hotplug-handle-memblocks-only-with-config_arch_keep_memblock.patch
mm-memory_hotplug-introduce-add_memory_driver_managed.patch
kexec_file-dont-place-kexec-images-on-ioresource_mem_driver_managed.patch
device-dax-add-memory-via-add_memory_driver_managed.patch
