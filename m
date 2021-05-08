Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F7BC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3AE6142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWzG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWzG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E8B60E0B;
        Sat,  8 May 2021 22:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514444;
        bh=H50mYannCtrOBMpAWDSQ/PV/b1YUrhNqMWFW5q1ef/4=;
        h=Date:From:To:Subject:From;
        b=PAzkQiWtIHQ5jc+IZ4gkpoYLDQjrIxjYpmv8BygyWPdbRlLd90dDzXLxPOZM1HUOn
         nQ4xS5k5j86pzjKN7qPRY48zIT2UE8EJ7yYaJFue36Zcjbm02Fqc1znng/H3YNGbwe
         WIMyZH/SX0uds/oJbn8Qkdmz0UB/lR3pVhr3+vYM=
Date:   Sat, 08 May 2021 15:54:03 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bhe@redhat.com, bp@alien8.de,
        brijesh.singh@amd.com, cai@lca.pw, dan.j.williams@intel.com,
        daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com,
        david@redhat.com, dyoung@redhat.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, keith.busch@intel.com,
        mchehab+huawei@kernel.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, tglx@linutronix.de,
        thomas.lendacky@amd.com, vgoyal@redhat.com
Subject:  [merged]
 =?US-ASCII?Q?kernel-resource-make-walk=5Fsystem=5Fram=5Fres-find-all-bu?=
 =?US-ASCII?Q?sy-ioresource=5Fsystem=5Fram-resources.patch?= removed from
 -mm tree
Message-ID: <20210508225403.IZK-ckzD9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: make walk_system_ram_res() find all busy IORESOURCE_SYSTEM_RAM resources
has been removed from the -mm tree.  Its filename was
     kernel-resource-make-walk_system_ram_res-find-all-busy-ioresource_system_ram-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: make walk_system_ram_res() find all busy IORESOURCE_SYSTEM_RAM resources

Patch series "kernel/resource: make walk_system_ram_res() and walk_mem_res() search the whole tree", v2.

Playing with kdump+virtio-mem I noticed that kexec_file_load() does not
consider System RAM added via dax/kmem and virtio-mem when preparing the
elf header for kdump.  Looking into the details, the logic used in
walk_system_ram_res() and walk_mem_res() seems to be outdated.

walk_system_ram_range() already does the right thing, let's change
walk_system_ram_res() and walk_mem_res(), and clean up.

Loading a kdump kernel via "kexec -p -s" ...  will result in the kdump
kernel to also dump dax/kmem and virtio-mem added System RAM now.

Note: kexec-tools on x86-64 also have to be updated to consider this
memory in the kexec_load() case when processing /proc/iomem.


This patch (of 3):

It used to be true that we can have system RAM (IORESOURCE_SYSTEM_RAM |
IORESOURCE_BUSY) only on the first level in the resource tree.  However,
this is no longer holds for driver-managed system RAM (i.e., added via
dax/kmem and virtio-mem), which gets added on lower levels, for example,
inside device containers.

We have two users of walk_system_ram_res(), which currently only
consideres the first level:

a) kernel/kexec_file.c:kexec_walk_resources() -- We properly skip
   IORESOURCE_SYSRAM_DRIVER_MANAGED resources via
   locate_mem_hole_callback(), so even after this change, we won't be
   placing kexec images onto dax/kmem and virtio-mem added memory.  No
   change.

b) arch/x86/kernel/crash.c:fill_up_crash_elf_data() -- we're currently
   not adding relevant ranges to the crash elf header, resulting in them
   not getting dumped via kdump.

This change fixes loading a crashkernel via kexec_file_load() and
including dax/kmem and virtio-mem added System RAM in the crashdump on
x86-64.  Note that e.g,, arm64 relies on memblock data and, therefore,
always considers all added System RAM already.

Let's find all IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY resources, making
the function behave like walk_system_ram_range().

Link: https://lkml.kernel.org/r/20210325115326.7826-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210325115326.7826-2-david@redhat.com
Fixes: ebf71552bb0e ("virtio-mem: Add parent resource for all added "System RAM"")
Fixes: c221c0b0308f ("device-dax: "Hotplug" persistent memory for use like normal RAM")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~kernel-resource-make-walk_system_ram_res-find-all-busy-ioresource_system_ram-resources
+++ a/kernel/resource.c
@@ -457,7 +457,7 @@ int walk_system_ram_res(u64 start, u64 e
 {
 	unsigned long flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
 
-	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, true,
+	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, false,
 				     arg, func);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are


