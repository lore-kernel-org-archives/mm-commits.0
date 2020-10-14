Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77A2C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55E6C2224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709206;
	bh=2QVpfp6VFRTefu4VoKJJbYpIFhtMaYhj+q2FldJ+6dQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WaclLSx9jzPXux+RLaQZPMZUxfX08fEIf3ifMqXDCjw24pW68QvuD/fGmU9A6TI8A
	 DxOb4KUkW0fN+aj0XIC+LHqofKbqzeMLXTk+gcxoYaj1Ep6wEQEjVpaiAr9tVjD9qs
	 xP2AayCpcNK77nU16lwBQTtNt3qi2hpv5ZbGLSr0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgJNVAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVAF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C924F22248;
        Wed, 14 Oct 2020 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709205;
        bh=2QVpfp6VFRTefu4VoKJJbYpIFhtMaYhj+q2FldJ+6dQ=;
        h=Date:From:To:Subject:From;
        b=vvqbmaBOfRedehnR6CGrPkc/hEVrbFQLHaT/H5JP2cvgCOBMqPVwnO2zSmGpSiY0T
         acHZmdlU2lwGkaRWZTMKgp3uImhmDIB7rlejUArZL7v1JA5C88tAjtc1WccUxuTEHj
         KA6ikP9sg5epuIslXl28AZjixJEn9YcP1iCLNv54=
Date:   Wed, 14 Oct 2020 14:00:04 -0700
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?mm-memcontrol-use-the-preferred-form-for-passing-the-size-o?=
 =?US-ASCII?Q?f-a-structure-type.patch?= removed from -mm tree
Message-ID: <20201014210004.Wi9E_o-t2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use the preferred form for passing the size of a structure type
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: mm: memcontrol: use the preferred form for passing the size of a structure type

Use the preferred form for passing the size of a structure type.  The
alternative form where the structure type is spelled out hurts readability
and introduces an opportunity for a bug when the object type is changed
but the corresponding object identifier to which the sizeof operator is
applied is not.

Link: https://lkml.kernel.org/r/773e013ff2f07fe2a0b47153f14dea054c0c04f1.1596214831.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type
+++ a/mm/memcontrol.c
@@ -4264,7 +4264,7 @@ static int __mem_cgroup_usage_register_e
 	new->entries[size - 1].threshold = threshold;
 
 	/* Sort thresholds. Registering of new threshold isn't time-critical */
-	sort(new->entries, size, sizeof(struct mem_cgroup_threshold),
+	sort(new->entries, size, sizeof(*new->entries),
 			compare_thresholds, NULL);
 
 	/* Find current threshold */
_

Patches currently in -mm which might be from gustavoars@kernel.org are


