Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB4AC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 18:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C543120786
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 18:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598466658;
	bh=AYSj4fgkZQMn1s1z/TbskbYLHiTtwoAK952bx8iM77Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aahJfVORTJl2HSFEuB5nbz8ggz+7ARJJnuLM5lAtMMwENSfgUzhqtkkzaYeD/qvwW
	 52aAII4CRK2tU8LIhH79dC3kLNxTXh3QBKo/rh0/c/v3LnVb8wyquFORbOVVlRFVSj
	 4fv2ZudVjRxwMTLdgdIp+veOa4iHnpfjRA0EMvjc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgHZSa5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Aug 2020 14:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgHZSaz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 Aug 2020 14:30:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB25320737;
        Wed, 26 Aug 2020 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598466652;
        bh=AYSj4fgkZQMn1s1z/TbskbYLHiTtwoAK952bx8iM77Q=;
        h=Date:From:To:Subject:From;
        b=0ozsalkwmgqxoVQ50WEivyeD21t3UPxk0oP41PR96oonyhr/etayU1bYav50QU5YW
         M0iqEj12i+I7H5ZQy/4ZuBtq5EZMK+UtFfIVzJs1QmKY9/gigz6ubbgvvKW3ZunWCC
         WzovuQFfWBJXvGcF5N4rudYRGlYNCFmlPXt5LjEs=
Date:   Wed, 26 Aug 2020 11:30:51 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, joao.m.martins@oracle.com,
        mm-commits@vger.kernel.org, vishal.l.verma@intel.com
Subject:  +
 device-dax-add-dis-contiguous-resource-support-fix.patch added to -mm tree
Message-ID: <20200826183051.j8_N-GfPY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-add-dis-contiguous-resource-support-fix
has been added to the -mm tree.  Its filename is
     device-dax-add-dis-contiguous-resource-support-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-add-dis-contiguous-resource-support-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-add-dis-contiguous-resource-support-fix.patch

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

device-dax-add-dis-contiguous-resource-support-fix.patch
device-dax-make-align-a-per-device-property.patch
device-dax-add-an-align-attribute.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

