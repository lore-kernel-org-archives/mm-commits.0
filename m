Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0615C636D3
	for <mm-commits@archiver.kernel.org>; Thu,  2 Feb 2023 23:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjBBX6B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 18:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbjBBX5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 18:57:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6C36CC97
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 15:57:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76812B827D6
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 23:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F526C433D2;
        Thu,  2 Feb 2023 23:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675382271;
        bh=7Sip9jePHXDhKTxR7sCSW2kwKod7rmgoeY186nwvTLc=;
        h=Date:To:From:Subject:From;
        b=Bly8ZTaTanewN5ZBm8iawnzIxqVXG/S/uFCOYumWYoH+vprg/nv2E8kTgsB+t9Xj+
         7PoE9yWipROGIZ4mpqMfdL5Abgk2utYOWkrt5tu1uaaYos6xqhAQADvL/tF3lSCxIF
         hCe4qchOGwU0ujA5cwjRHMyjZ1NidkfSFDfaSmBs=
Date:   Thu, 02 Feb 2023 15:57:50 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        sangyun.kim@snu.ac.kr, rppt@kernel.org, gwan-gyeong.mun@intel.com,
        christophe.leroy@csgroup.eu, casionwoo@gmail.com,
        42.hyeyoo@gmail.com, hn.min.lee@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-replace-bug_on-to-a-simple-if-statement.patch added to mm-unstable branch
Message-Id: <20230202235751.0F526C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: replace BUG_ON with a simple if statement
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-replace-bug_on-to-a-simple-if-statement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-replace-bug_on-to-a-simple-if-statement.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hyunmin Lee <hn.min.lee@gmail.com>
Subject: mm/vmalloc: replace BUG_ON with a simple if statement
Date: Wed, 1 Feb 2023 20:51:42 +0900

As per the coding standards, in the event of an abnormal condition that
should not occur under normal circumstances, the kernel should attempt
recovery and proceed with execution, rather than halting the machine.

Specifically, in the alloc_vmap_area() function, use a simple if()
instead of using BUG_ON() halting the machine.

Link: https://lkml.kernel.org/r/20230201115142.GA7772@min-iamroot
Co-Developed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Co-Developed-by: Jeungwoo Yoo <casionwoo@gmail.com>
Co-Developed-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Signed-off-by: Hyunmin Lee <hn.min.lee@gmail.com>
Signed-off-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Signed-off-by: Jeungwoo Yoo <casionwoo@gmail.com>
Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmalloc-replace-bug_on-to-a-simple-if-statement
+++ a/mm/vmalloc.c
@@ -1587,9 +1587,8 @@ static struct vmap_area *alloc_vmap_area
 	int purged = 0;
 	int ret;
 
-	BUG_ON(!size);
-	BUG_ON(offset_in_page(size));
-	BUG_ON(!is_power_of_2(align));
+	if (unlikely(!size || offset_in_page(size) || !is_power_of_2(align)))
+		return ERR_PTR(-EINVAL);
 
 	if (unlikely(!vmap_initialized))
 		return ERR_PTR(-EBUSY);
_

Patches currently in -mm which might be from hn.min.lee@gmail.com are

mm-vmalloc-replace-bug_on-to-a-simple-if-statement.patch

