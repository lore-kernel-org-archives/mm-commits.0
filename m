Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B959C07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 01:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69EE5613C2
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 01:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhGJBIb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 21:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGJBIa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 21:08:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 956FF613BF;
        Sat, 10 Jul 2021 01:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625879145;
        bh=4SvgqXr51NfSIDc6c5xhCjN2AaBm7Gx4ZkK7jbGdlWw=;
        h=Date:From:To:Subject:From;
        b=ShbhXaSmcY2aqcwK5mrTwSwANczn8rcm5d3wG+8UDl2GxAEeRda6JB4TlgTTKc/5y
         KvHD9Sgp6LOZAO2fHCpOVCaKEjDSc6mVxSiV01i+gvtQDCUHJIRNv46ZHR7w/OOKiQ
         A9/BqRqeVg6RbcGs0R/e6ma59YXrLoOALvYAf/hI=
Date:   Fri, 09 Jul 2021 18:05:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangwensheng4@huawei.com,
        rui.xiang@huawei.com, osalvador@suse.de, k-hagio-ab@nec.com,
        david@redhat.com, dan.j.williams@intel.com, naoya.horiguchi@nec.com
Subject:  + mm-sparse-set-section_nid_shift-to-6.patch added to -mm
 tree
Message-ID: <20210710010540.MKIS1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: set SECTION_NID_SHIFT to 6
has been added to the -mm tree.  Its filename is
     mm-sparse-set-section_nid_shift-to-6.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-set-section_nid_shift-to-6.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-set-section_nid_shift-to-6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/sparse: set SECTION_NID_SHIFT to 6

Currently SECTION_NID_SHIFT is set to 3, which is incorrect because bit 3
and 4 can be overlapped by sub-field for early NID, and can be
unexpectedly set on NUMA systems.  There are a few non-critical issues
related to this:

- Having SECTION_TAINT_ZONE_DEVICE set for wrong sections forces
  pfn_to_online_page() through the slow path, but doesn't actually break
  the kernel.

- A kdump generation tool like makedumpfile uses this field to calculate
  the physical address to read.  So wrong bits can make the tool access to
  wrong address and fail to create kdump.  This can be avoided by the
  tool, so it's not critical.

To fix it, set SECTION_NID_SHIFT to 6 which is the minimum number of
available bits of section flag field.

Link: https://lkml.kernel.org/r/20210707045548.810271-1-naoya.horiguchi@linux.dev
Fixes: 1f90a3477df3 ("mm: teach pfn_to_online_page() about ZONE_DEVICE section collisions")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Kazuhito Hagio <k-hagio-ab@nec.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wang Wensheng <wangwensheng4@huawei.com>
Cc: Rui Xiang <rui.xiang@huawei.com>
Cc: Kazu <k-hagio-ab@nec.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-sparse-set-section_nid_shift-to-6
+++ a/include/linux/mmzone.h
@@ -1364,7 +1364,7 @@ extern size_t mem_section_usage_size(voi
 #define SECTION_TAINT_ZONE_DEVICE	(1UL<<4)
 #define SECTION_MAP_LAST_BIT		(1UL<<5)
 #define SECTION_MAP_MASK		(~(SECTION_MAP_LAST_BIT-1))
-#define SECTION_NID_SHIFT		3
+#define SECTION_NID_SHIFT		6
 
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-sparse-set-section_nid_shift-to-6.patch

