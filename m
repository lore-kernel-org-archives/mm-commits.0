Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3913C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77C19235FD
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600796521;
	bh=iSrGFwbD0HB4o/Yjt/9oKlo3s33svIc+lLvOUc4uT8U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kIoMxKeRPCd2pPp6Jxi0q5nXtWXz2fdWy44xxlV+PhxtAICeKDOvbV75Sa4WOKSkY
	 UGEF4RQpPvYVpFWTF6XsWeeARPsqN3XlztE26HjU/X1DgJt36ceMbKkdfnUy/80uip
	 wIt7ocUasOKoaw61USe9OM7SeMXVmOi1/4NNT4Sw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIVRmB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVRmB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:42:01 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2420C2311C;
        Tue, 22 Sep 2020 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600796520;
        bh=iSrGFwbD0HB4o/Yjt/9oKlo3s33svIc+lLvOUc4uT8U=;
        h=Date:From:To:Subject:From;
        b=FKNOxs2nj0mZVUnSDABObF/LTuMMgzqw2XvlakJgSTPXruMzSwVET8YUT2Xaea+Lx
         +kAvMzhcv6EdQwcH7QCTYuDYLS/ySExq6HPhKI7HWi9NL2tdA14TJPmMhM5+ohS+G0
         p/W+Z3SiwsmxImA2v4Fu4Xp5sTbX3qldZ9PqptNI=
Date:   Tue, 22 Sep 2020 10:41:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hulkci@huawei.com, yanaijie@huawei.com
Subject:  + lib-include-memregionh-in-memregionc.patch added to -mm
 tree
Message-ID: <20200922174159.hJZbH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/memregion.c: include memregion.h
has been added to the -mm tree.  Its filename is
     lib-include-memregionh-in-memregionc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-include-memregionh-in-memregionc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-include-memregionh-in-memregionc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yanaijie@huawei.com are

lib-include-memregionh-in-memregionc.patch
device-dax-make-dev_dax_kmem_probe-static.patch

