Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F0AC4741F
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 04:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE8E4207C4
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 04:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601093962;
	bh=CZGQ/IPtIHlW48+y+j6behOl57FkpS5nsvTS70xhlrI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=P+M1LXYnfY7jpZQXylzFsj+/9kkyHNJORaJJQSGwFgF2O79AI9F4MyudzPP2H4/og
	 S7FIXIVn8+PAoDdJKCzkWu1L5KFCPISWguJcVhLc2Zgznwb1iafC9omCR3F+OuMrGl
	 Kb3rgMyUvHKcNEfG8jZAjTKsnBOOoIIkOmiCT9t8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgIZETW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 26 Sep 2020 00:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgIZETW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 26 Sep 2020 00:19:22 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC50A20882;
        Sat, 26 Sep 2020 04:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601093962;
        bh=CZGQ/IPtIHlW48+y+j6behOl57FkpS5nsvTS70xhlrI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=F//Nz6di/fbaRVR5cs4WfZ0oo1+G6Bz+F8KkJguT8yC/C5Z5rHv2LInDPXTwthxR5
         B75tXbMi+w784JReE7nIDWd5oDAMMmSMjPy4/ZB6zZiht5F0jr6O/T5QAZupU/Ar+Y
         8HdbRwSZaC3clAo1MnP3JkafH5Bgea3vv6mBXAPo=
Date:   Fri, 25 Sep 2020 21:19:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hulkci@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yanaijie@huawei.com
Subject:  [patch 6/9] lib/memregion.c: include memregion.h
Message-ID: <20200926041921.kOd2RwU5v%akpm@linux-foundation.org>
In-Reply-To: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Subject: lib/memregion.c: include memregion.h

This addresses the following sparse warning:

lib/memregion.c:8:5: warning: symbol 'memregion_alloc' was not declared.
Should it be static?
lib/memregion.c:14:6: warning: symbol 'memregion_free' was not declared.
Should it be static?

Link: https://lkml.kernel.org/r/20200921142852.875312-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/memregion.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/memregion.c~lib-include-memregionh-in-memregionc
+++ a/lib/memregion.c
@@ -2,6 +2,7 @@
 /* identifiers for device / performance-differentiated memory regions */
 #include <linux/idr.h>
 #include <linux/types.h>
+#include <linux/memregion.h>
 
 static DEFINE_IDA(memregion_ids);
 
_
