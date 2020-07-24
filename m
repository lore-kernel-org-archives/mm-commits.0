Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230D5C433E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10862070E
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633926;
	bh=PqIo/Y+y3mtbDI5zt4wtGGVMNeYhnWvhRtpw0CK0yXg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=G8a5+ihCfZRx7b7WzACGDIfASSQ76VXAmhp7NsW1ar2G/cH7mVuxrhUe54mlHsalw
	 z4MoeWERE0sY75IaqAS5KWq2mwrq37UzwLDUFI6pfMxrnFInDrd2Yp/dYk/iusi4F2
	 SCQoSbPfNLswIEj9u0oONBFh1cG5KSZ4LNOJMTLU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGXXip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgGXXip (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A855A206E3;
        Fri, 24 Jul 2020 23:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633925;
        bh=PqIo/Y+y3mtbDI5zt4wtGGVMNeYhnWvhRtpw0CK0yXg=;
        h=Date:From:To:Subject:From;
        b=A8rD/yjjX8d3lvarfqPjpPPc6eskmYrWp2oEF4qCMU7GFCvAz9dlYQSO3wMYm3eRT
         Q1onf8nLi8hxozSgQ4o0Rr/T7m/HEYduBBCKzIaTsR6F2EE06EoBo631DHy8QyEcUZ
         IiMmblSe79gC1Z0ircxoAogfmgnjJIgVXTesc3cY=
Date:   Fri, 24 Jul 2020 16:38:44 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        chris@chris-wilson.co.uk, daniel@ffwll.ch,
        michael.j.ruhl@intel.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, stable@vger.kernel.org
Subject:  [merged] io-mapping-indicate-mapping-failure.patch
 removed from -mm tree
Message-ID: <20200724233844.KN5M21L8L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: io-mapping: indicate mapping failure
has been removed from the -mm tree.  Its filename was
     io-mapping-indicate-mapping-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Michael J. Ruhl" <michael.j.ruhl@intel.com>
Subject: io-mapping: indicate mapping failure

The !ATOMIC_IOMAP version of io_maping_init_wc will always return success,
even when the ioremap fails.

Since the ATOMIC_IOMAP version returns NULL when the init fails, and
callers check for a NULL return on error this is unexpected.

During a device probe, where the ioremap failed, a crash can look
like this:

BUG: unable to handle page fault for address: 0000000000210000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 Oops: 0002 [#1] PREEMPT SMP
 CPU: 0 PID: 177 Comm:
 RIP: 0010:fill_page_dma [i915]
  gen8_ppgtt_create [i915]
  i915_ppgtt_create [i915]
  intel_gt_init [i915]
  i915_gem_init [i915]
  i915_driver_probe [i915]
  pci_device_probe
  really_probe
  driver_probe_device

The remap failure occurred much earlier in the probe.  If it had
been propagated, the driver would have exited with an error.

Return NULL on ioremap failure.

[akpm@linux-foundation.org: detect ioremap_wc() errors earlier]
Link: http://lkml.kernel.org/r/20200721171936.81563-1-michael.j.ruhl@intel.com
Fixes: cafaf14a5d8f ("io-mapping: Always create a struct to hold metadata about the io-mapping")
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/io-mapping.h~io-mapping-indicate-mapping-failure
+++ a/include/linux/io-mapping.h
@@ -107,9 +107,12 @@ io_mapping_init_wc(struct io_mapping *io
 		   resource_size_t base,
 		   unsigned long size)
 {
+	iomap->iomem = ioremap_wc(base, size);
+	if (!iomap->iomem)
+		return NULL;
+
 	iomap->base = base;
 	iomap->size = size;
-	iomap->iomem = ioremap_wc(base, size);
 #if defined(pgprot_noncached_wc) /* archs can't agree on a name ... */
 	iomap->prot = pgprot_noncached_wc(PAGE_KERNEL);
 #elif defined(pgprot_writecombine)
_

Patches currently in -mm which might be from michael.j.ruhl@intel.com are


