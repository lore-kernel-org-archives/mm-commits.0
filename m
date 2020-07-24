Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D23C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B12320663
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564148;
	bh=NfcVzZsDSUdBwlXb4Eumd6XWzb9rfmO/+Viibn8g2Jc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Dcyugb9cKV445atX9HK6UNE2v/lCapnsIWZApdtmh8zPcMFoZ8u161w8lcsQhAv6P
	 +eT0jC36ujZVOsMgSh9UL5vzJwusPmGXHn8SJzWnlWr+7wdy7mh8W/7SR3nd5OWchO
	 BNEVeS7H/Wxk3qNuNMX421Q5zsG6izuVS0NKasDs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgGXEPr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXEPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4D92064C;
        Fri, 24 Jul 2020 04:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564147;
        bh=NfcVzZsDSUdBwlXb4Eumd6XWzb9rfmO/+Viibn8g2Jc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GiEBunXJLNGPAfSP7Fzp24CAt+RETbBRSHJbH4T1znflv1iejBO3BSoN8G8JYKsMs
         q8qnEmARlUkO0ipNqVDmtxIHxiz4L53vn1r4Hj18wBrb/oG9qoT4QBTwMhd+wIA6qs
         YAqIbOB26TWII9TOwkOBn0fBzxaBG0OqqJUTuA58=
Date:   Thu, 23 Jul 2020 21:15:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        chris@chris-wilson.co.uk, daniel@ffwll.ch, linux-mm@kvack.org,
        michael.j.ruhl@intel.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 13/15] io-mapping: indicate mapping failure
Message-ID: <20200724041546.M6QtVvJ-q%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
