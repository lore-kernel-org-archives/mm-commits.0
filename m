Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9CBC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08E4E6143B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEHWzJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWzJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9822C61402;
        Sat,  8 May 2021 22:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514447;
        bh=R2e+HlcPxtWWQKQDuI1s8BjY4DOgj/i4RTuDMfq/IXw=;
        h=Date:From:To:Subject:From;
        b=XdTZorTy5aDd0qJMhR9siSvN06sxq+o8FtElrXl27qsaUsw9tFDzbRJ4FLkumXW7d
         Mbmto2Ts73ACo2LT+wYm3N8WB7JlO/ExSP1f5T79PHQQpQjt0Q9JueNG1Cewifp3u7
         sIK4YvAWK+6+IqJYgJRZWNElFa5CaZVKSTfyeG8o=
Date:   Sat, 08 May 2021 15:54:06 -0700
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
 =?US-ASCII?Q?kernel-resource-make-walk=5Fmem=5Fres-find-all-busy-ioreso?=
 =?US-ASCII?Q?urce=5Fmem-resources.patch?= removed from -mm tree
Message-ID: <20210508225406.I3RvZ99UT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: make walk_mem_res() find all busy IORESOURCE_MEM resources
has been removed from the -mm tree.  Its filename was
     kernel-resource-make-walk_mem_res-find-all-busy-ioresource_mem-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: kernel/resource: make walk_mem_res() find all busy IORESOURCE_MEM resources

It used to be true that we can have system RAM (IORESOURCE_SYSTEM_RAM |
IORESOURCE_BUSY) only on the first level in the resource tree.  However,
this is no longer holds for driver-managed system RAM (i.e., added via
dax/kmem and virtio-mem), which gets added on lower levels, for example,
inside device containers.

IORESOURCE_SYSTEM_RAM is defined as IORESOURCE_MEM | IORESOURCE_SYSRAM and
just a special type of IORESOURCE_MEM.

The function walk_mem_res() only considers the first level and is used in
arch/x86/mm/ioremap.c:__ioremap_check_mem() only.  We currently fail to
identify System RAM added by dax/kmem and virtio-mem as
"IORES_MAP_SYSTEM_RAM", for example, allowing for remapping of such
"normal RAM" in __ioremap_caller().

Let's find all IORESOURCE_MEM | IORESOURCE_BUSY resources, making the
function behave similar to walk_system_ram_res().

Link: https://lkml.kernel.org/r/20210325115326.7826-3-david@redhat.com
Fixes: ebf71552bb0e ("virtio-mem: Add parent resource for all added "System RAM"")
Fixes: c221c0b0308f ("device-dax: "Hotplug" persistent memory for use like normal RAM")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~kernel-resource-make-walk_mem_res-find-all-busy-ioresource_mem-resources
+++ a/kernel/resource.c
@@ -470,7 +470,7 @@ int walk_mem_res(u64 start, u64 end, voi
 {
 	unsigned long flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 
-	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, true,
+	return __walk_iomem_res_desc(start, end, flags, IORES_DESC_NONE, false,
 				     arg, func);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are


