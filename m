Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4816AC4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083D320936
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601086669;
	bh=nOVVrRQuW8cuwi1A1zUBMkSDljMCeCmd5HmToJuTJnc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fcXfE9s5QQCeFFm9rpW+C6gymk59muys/9OQM1mGTY1TN5SLTP4a4UBVi59v/pHiQ
	 a2pXlwhU1ffKrxA3VbSm8Ka1PJwxvSBzJnauTufZULb1FaLlA6OQ/ovS2IemEKmwYr
	 Y5q4mqi5syFrJ8oUPU2YfQf11QmEb41LNdYHm3dc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgIZCRs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:17:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgIZCRs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:17:48 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0618620866;
        Sat, 26 Sep 2020 02:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601086668;
        bh=nOVVrRQuW8cuwi1A1zUBMkSDljMCeCmd5HmToJuTJnc=;
        h=Date:From:To:Subject:From;
        b=wBylraD3p3VhDeJaE5UwJBz8DwngLz5NydKXl9hDsshggkx6dLRYnvpeim0pK/+3g
         U1itTud76lWi9HwHJdOTEYCkn2o0iBIKKhWRGEM/PBRFQ7Qa3sWOdoIVtPt7DakIJK
         ZQR5btTf+fA+VkaAGdPfFwGbV9wGMP79XBbx/X6s=
Date:   Fri, 25 Sep 2020 19:17:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        dan.j.williams@intel.com, joao.m.martins@oracle.com
Subject:  [folded-merged]
 device-dax-add-dis-contiguous-resource-support-fix.patch removed from -mm
 tree
Message-ID: <20200926021747.-xfm5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-add-dis-contiguous-resource-support-fix
has been removed from the -mm tree.  Its filename was
     device-dax-add-dis-contiguous-resource-support-fix.patch

This patch was dropped because it was folded into device-dax-add-dis-contiguous-resource-support.patch

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax-add-dis-contiguous-resource-support-fix

kfree only with nr_range == 0, while also avoiding the leakage of @ranges
(from krealloc success case with nr_ranges > 0) without the null deref
that this introduces.

Link: https://lkml.kernel.org/r/6d57acf7-63cf-168d-f68e-67d88832f10f@oracle.com
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-dis-contiguous-resource-support-fix
+++ a/drivers/dax/bus.c
@@ -607,13 +607,16 @@ static int alloc_dev_dax_range(struct de
 		return -ENOMEM;
 
 	alloc = __request_region(res, start, size, dev_name(dev), 0);
-	if (!alloc && !dev_dax->nr_range) {
+	if (!alloc) {
 		/*
-		 * If we adjusted an existing @ranges leave it alone,
-		 * but if this was an empty set of ranges nothing else
+		 * If this was an empty set of ranges nothing else
 		 * will release @ranges, so do it now.
 		 */
-		kfree(ranges);
+		if (!dev_dax->nr_range) {
+			kfree(ranges);
+			ranges = NULL;
+		}
+		dev_dax->ranges = ranges;
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch
device-dax-make-align-a-per-device-property.patch
device-dax-add-an-align-attribute-fixpatch.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

