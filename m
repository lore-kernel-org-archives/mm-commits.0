Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4E6C43467
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A88216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881400;
	bh=tjl7nv5HXHaY35amY58MwSGh23tJcimhpnZwWnkOjeY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=X/FTcFUzROHD3sm/RjaWxAR2ubYhhH4Pa8E3aCr021tpLc8raxNA/reRHisCRAUjd
	 pf1KZIGWOV39uyAckGx9DN0pKyH01EZtUrs7qqzfOxIzerkXM7s84qkkuFMdiXP5GF
	 a4wOl93+yLdBlBVszPUFF1IIf8irbhPpQmUpM4Jc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392731AbgJPUuA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392725AbgJPUuA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:50:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2A4921655;
        Fri, 16 Oct 2020 20:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881399;
        bh=tjl7nv5HXHaY35amY58MwSGh23tJcimhpnZwWnkOjeY=;
        h=Date:From:To:Subject:From;
        b=PUaB1GRNzU9PURd0pb17wsZhdYifhWDpWM7faDiowH4bHe6hBoKpzvkEOudcQLT1H
         ZJoL4O6xEOdrmJHBDC4UG5xtyO9RHyXLauwUt/jRLQ0I4W56g+3SWK7aSA8YFdIfKm
         OjJqXvy7XhevQ2ps0ntGXX8/GL/NrmyA+r1jpL6k=
Date:   Fri, 16 Oct 2020 13:49:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bgolaszewski@baylibre.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-util-update-the-kerneldoc-for-kstrdup_const.patch removed from -mm tree
Message-ID: <20201016204958.6wCRqphC4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util.c: update the kerneldoc for kstrdup_const()
has been removed from the -mm tree.  Its filename was
     mm-util-update-the-kerneldoc-for-kstrdup_const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: mm/util.c: update the kerneldoc for kstrdup_const()

Memory allocated with kstrdup_const() must not be passed to regular
krealloc() as it is not aware of the possibility of the chunk residing in
.rodata.  Since there are no potential users of krealloc_const() at the
moment, let's just update the doc to make it explicit.

Link: http://lkml.kernel.org/r/20200817173927.23389-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-util-update-the-kerneldoc-for-kstrdup_const
+++ a/mm/util.c
@@ -69,7 +69,8 @@ EXPORT_SYMBOL(kstrdup);
  * @s: the string to duplicate
  * @gfp: the GFP mask used in the kmalloc() call when allocating memory
  *
- * Note: Strings allocated by kstrdup_const should be freed by kfree_const.
+ * Note: Strings allocated by kstrdup_const should be freed by kfree_const and
+ * must not be passed to krealloc().
  *
  * Return: source string if it is in .rodata section otherwise
  * fallback to kstrdup.
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are


