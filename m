Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C342C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 046626124D
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhKICe1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:34:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235194AbhKICe1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:34:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70234611ED;
        Tue,  9 Nov 2021 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425102;
        bh=Xv6gQC9t+kUvmdlciFzhl3cxYDsw3E+fLuVW/YOI9kE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ii55l+JmuLlAY/aLMy83bvlcKzQjV7WRmWKRD5yQ70D4hj1cvTkp94otB2pY55x7G
         biwzDsbTsjso6JfqYC/a+lMRs2hCZbY0LdLEv07r7hO3nVsRzwutDk2jQlJUtR2y2I
         zfhXhsYkQkqxsgjpBjFnAJNt4PF0Gpn8FMjeqsZ0=
Date:   Mon, 08 Nov 2021 18:31:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, linux-mm@kvack.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Subject:  [patch 06/87] x86/xen: print a warning when
 HVMOP_get_mem_type fails
Message-ID: <20211109023141.kg--Gyb9n%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: x86/xen: print a warning when HVMOP_get_mem_type fails

HVMOP_get_mem_type is not expected to fail, "This call failing is
indication of something going quite wrong and it would be good to know
about this." [1]

Let's add a pr_warn_once().

[1] https://lkml.kernel.org/r/3b935aa0-6d85-0bcd-100e-15098add3c4c@oracle.com

Link: https://lkml.kernel.org/r/20211005121430.30136-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
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

 arch/x86/xen/mmu_hvm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/mmu_hvm.c~x86-xen-print-a-warning-when-hvmop_get_mem_type-fails
+++ a/arch/x86/xen/mmu_hvm.c
@@ -22,8 +22,10 @@ static int xen_oldmem_pfn_is_ram(unsigne
 		.pfn = pfn,
 	};
 
-	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a))
+	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a)) {
+		pr_warn_once("Unexpected HVMOP_get_mem_type failure\n");
 		return -ENXIO;
+	}
 	return a.mem_type != HVMMEM_mmio_dm;
 }
 #endif
_
