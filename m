Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFECCC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C3D6187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhKKCxs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234526AbhKKCxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C064061872;
        Thu, 11 Nov 2021 02:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599053;
        bh=F0GB1OcH4ng6KwtWRdeEB3OeOj9yU7xiAKuekDoYaYc=;
        h=Date:From:To:Subject:From;
        b=gqkbpkYlQ6juzZxiYsY0iavF/kRMzzOc9szVTCBjjRmUJnhMo3zh68ccquadFUwI8
         DGXAskhxxWtzFWBxmAPukQ87lfaDPaZIXI5u/d2kPrwiwoPsQ1b1Ne3YKpc0pT6u4Z
         rfqPPiN5fKNZ0KHzGNR8CsgauaTgvVf/6PHB+Ebw=
Date:   Wed, 10 Nov 2021 18:50:52 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, boris.ostrovsky@oracle.com, bp@alien8.de,
        david@redhat.com, dyoung@redhat.com, hpa@zytor.com,
        jasowang@redhat.com, jgross@suse.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de, vgoyal@redhat.com
Subject:  [merged] x86-xen-simplify-xen_oldmem_pfn_is_ram.patch
 removed from -mm tree
Message-ID: <20211111025052.aog2NX8SN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/xen: simplify xen_oldmem_pfn_is_ram()
has been removed from the -mm tree.  Its filename was
     x86-xen-simplify-xen_oldmem_pfn_is_ram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/xen: simplify xen_oldmem_pfn_is_ram()

Let's simplify return handling.

Link: https://lkml.kernel.org/r/20211005121430.30136-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu_hvm.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/arch/x86/xen/mmu_hvm.c~x86-xen-simplify-xen_oldmem_pfn_is_ram
+++ a/arch/x86/xen/mmu_hvm.c
@@ -21,23 +21,10 @@ static int xen_oldmem_pfn_is_ram(unsigne
 		.domid = DOMID_SELF,
 		.pfn = pfn,
 	};
-	int ram;
 
 	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a))
 		return -ENXIO;
-
-	switch (a.mem_type) {
-	case HVMMEM_mmio_dm:
-		ram = 0;
-		break;
-	case HVMMEM_ram_rw:
-	case HVMMEM_ram_ro:
-	default:
-		ram = 1;
-		break;
-	}
-
-	return ram;
+	return a.mem_type != HVMMEM_mmio_dm;
 }
 #endif
 
_

Patches currently in -mm which might be from david@redhat.com are


