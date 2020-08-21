Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C4FC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8185A207DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598052270;
	bh=4wA37LPfi7XvKo78ym46xcKQaAY0E4THFjaUSSc8yiM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=n3cs5izA5D/vW6X9MtnpWrKgxKt2Dc1hxzrpN4I4ZM8hsY+BNYgJu0iw1uPEIA3OI
	 BRgl3ccII+GpWYiEgPo0/9ZNKNcM9Vm1YWM2nL9j+0WC3HIpPBVuYSfTD064cy/nAn
	 q4CGIdNlsdC3NpjhcI5FA7rXixslnuGH5c4cNhAM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHUXYa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHUXY3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:24:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7105C207C3;
        Fri, 21 Aug 2020 23:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598052268;
        bh=4wA37LPfi7XvKo78ym46xcKQaAY0E4THFjaUSSc8yiM=;
        h=Date:From:To:Subject:From;
        b=R7/9D6DubGR4RCBJgtRobKcEKVPMaBF1HMAULUKt6yZ9xkx9s7FBk0imJUSEICZjt
         7gQY88ZHaFi9X3nzEerAoyNpUr6+hyzEdxIGd3OIlAmuiX1cplrsgOKP2m/l+qlicy
         wqUnAPnNv77saqc8og8LF7cDY8mLMlTItzsG6FNI=
Date:   Fri, 21 Aug 2020 16:24:27 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        ira.weiny@intel.com, jgg@mellanox.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, luto@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rafael@kernel.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        rppt@linux.ibm.com, tglx@linutronix.de, thomas.lendacky@amd.com,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  + dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
 added to -mm tree
Message-ID: <20200821232427.MWvTzGc0l%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax/hmem: introduce dax_hmem.region_idle parameter
has been added to the -mm tree.  Its filename is
     dax-hmem-introduce-dax_hmemregion_idle-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dax-hmem-introduce-dax_hmemregion_idle-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: dax/hmem: introduce dax_hmem.region_idle parameter

Introduce a new module parameter for dax_hmem which initializes all region
devices as free, rather than allocating a pagemap for the region by
default.

All hmem devices created with dax_hmem.region_idle=1 will have full
available size for creating dynamic dax devices.

Link: https://lkml.kernel.org/r/159643106460.4062302.5868522341307530091.stgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-4-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/hmem/hmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dax/hmem/hmem.c~dax-hmem-introduce-dax_hmemregion_idle-parameter
+++ a/drivers/dax/hmem/hmem.c
@@ -5,6 +5,9 @@
 #include <linux/pfn_t.h>
 #include "../bus.h"
 
+static bool region_idle;
+module_param_named(region_idle, region_idle, bool, 0644);
+
 static int dax_hmem_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -30,7 +33,7 @@ static int dax_hmem_probe(struct platfor
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
 		.id = -1,
-		.size = resource_size(res),
+		.size = region_idle ? 0 : resource_size(res),
 	};
 	dev_dax = devm_create_dev_dax(&data);
 	if (IS_ERR(dev_dax))
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

device-dax-make-align-a-per-device-property.patch
device-dax-add-an-align-attribute.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

