Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F13ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 21:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJaVSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 17:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJaVR6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 17:17:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEF0140B9
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 14:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1250DB81A65
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 21:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D82C433C1;
        Mon, 31 Oct 2022 21:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667251052;
        bh=0hIZJFGUJhK3exndRLzy/4Z3Fkn2nTLpSZd8D0YjHi0=;
        h=Date:To:From:Subject:From;
        b=HC7VRgY+qVG2c2+OrKleMlrMdImX+aRqVtFWQKCn7q4DM7/V8vaNM+eoHKhdIAC/d
         Mk6MnY6M0stL0Jj+5SmL7dOFwqZ4+HToQCRfm56vZJU2z+iYusb7OtR+Qen4edtK2y
         IObixiW0AaFFwLxPtWWg2oTneeati9/w+3Sreah0=
Date:   Mon, 31 Oct 2022 14:17:31 -0700
To:     mm-commits@vger.kernel.org, xueshuai@linux.alibaba.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        dan.j.williams@intel.com, tony.luck@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4.patch added to mm-unstable branch
Message-Id: <20221031211732.B3D82C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4.patch

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
From: Tony Luck <tony.luck@intel.com>
Subject: mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4
Date: Mon, 31 Oct 2022 13:10:28 -0700

add call to kmsan_unpoison_memory(), per Miaohe Lin

Link: https://lkml.kernel.org/r/20221031201029.102123-2-tony.luck@intel.com
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Message-Id: <20221021200120.175753-2-tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/highmem.h~mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4
+++ a/include/linux/highmem.h
@@ -329,6 +329,8 @@ static inline int copy_mc_user_highpage(
 	vfrom = kmap_local_page(from);
 	vto = kmap_local_page(to);
 	ret = copy_mc_to_kernel(vto, vfrom, PAGE_SIZE);
+	if (!ret)
+		kmsan_unpoison_memory(page_address(to), PAGE_SIZE);
 	kunmap_local(vto);
 	kunmap_local(vfrom);
 
_

Patches currently in -mm which might be from tony.luck@intel.com are

mm-hwpoison-try-to-recover-from-copy-on-write-faults.patch
mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4.patch
mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline.patch

