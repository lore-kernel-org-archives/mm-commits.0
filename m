Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87C1C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbiBVDsx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:48:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiBVDsv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:48:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6DA245BA
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:48:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39140B81851
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3DBC340E8;
        Tue, 22 Feb 2022 03:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645501704;
        bh=tBV0IeTVWdym9qEphH4IXiRDoQthAYRa3KIsb1SzZjI=;
        h=Date:To:From:Subject:From;
        b=e+goKx+uv10v1IDLeckKeEtd45gfNRH4Gr48urKQ1DTl+yigAFZ3aqXapHYNsVtji
         OGo3+cKJpo6iSo57zfxMNAzzpJYnlWpqKCnsxJGrZPcRxivCMrfLcDBWZ6bvPI4WAY
         1yPTBOgIY9hcfQjzI3ulim+4OQGJLVDhKpqAMTfU=
Date:   Mon, 21 Feb 2022 19:48:23 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        tglx@linutronix.de, naoya.horiguchi@nec.com, mingo@redhat.com,
        linmiaohe@huawei.com, hpa@zytor.com, dave.hansen@linux.intel.com,
        bp@alien8.de, luofei@unicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch added to -mm tree
Message-Id: <20220222034823.DB3DBC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: add in-use hugepage hwpoison filter judgement
has been added to the -mm tree.  Its filename is
     mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: luofei <luofei@unicloud.com>
Subject: mm/hwpoison: add in-use hugepage hwpoison filter judgement

After successfully obtaining the reference count of the huge page, it is
still necessary to call hwpoison_filter() to make a filter judgement,
otherwise the filter hugepage will be unmaped and the related process may
be killed.

Link: https://lkml.kernel.org/r/20220221021521.2329075-1-luofei@unicloud.com
Signed-off-by: luofei <luofei@unicloud.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memory-failure.c~mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement
+++ a/mm/memory-failure.c
@@ -1537,6 +1537,17 @@ static int memory_failure_hugetlb(unsign
 	lock_page(head);
 	page_flags = head->flags;
 
+	if (hwpoison_filter(p)) {
+		if (TestClearPageHWPoison(head))
+			num_poisoned_pages_dec();
+		put_page(p);
+		if (flags & MF_MCE_HANDLE)
+			res = -EHWPOISON;
+		else
+			res = 0;
+		goto out;
+	}
+
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
_

Patches currently in -mm which might be from luofei@unicloud.com are

mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch
mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch

