From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 048/127] kexec_file: don't place kexec images on
 IORESOURCE_MEM_DRIVER_MANAGED
Date: Thu, 04 Jun 2020 16:48:44 -0700
Message-ID: <20200604234844.W8bo93R35%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXsq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:46 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebiederm@xmission.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org

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
