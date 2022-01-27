Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F69C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 01:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiA0Bhh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 20:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiA0Bhh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 20:37:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F315CC06161C
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 17:37:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A481B81EE8
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 01:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6203C340E3;
        Thu, 27 Jan 2022 01:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643247453;
        bh=E0RYJ1mU8Ja7YcDn29GiLDal8iJ53lYNAr/M3tq/HXY=;
        h=Date:From:To:Subject:From;
        b=y1NwaE3gjsSpN7vbpgZj27Rg9wvCC/1Paj28cKnGMRrFpiKvNLrgP628iJRKyXOxK
         WfbULJJba/LIOjG4JPJrnp2yWYnddhRWez2MajGa4C0MSFNLa49lVtX1NCVht2pT18
         aJZ88Q0Ng1fbB89+LB8SfELWiF6imDt9LMRbCfXQ=
Date:   Wed, 26 Jan 2022 17:37:33 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songmuchun@bytedance.com
Subject:  + mm-highmem-remove-unnecessary-done-label.patch added to
 -mm tree
Message-ID: <20220127013733._U4XwhlVM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: remove unnecessary done label
has been added to the -mm tree.  Its filename is
     mm-highmem-remove-unnecessary-done-label.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-remove-unnecessary-done-label.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-remove-unnecessary-done-label.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/highmem: remove unnecessary done label

Remove unnecessary done label to simplify the code.

Link: https://lkml.kernel.org/r/20220126092542.64659-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/highmem.c~mm-highmem-remove-unnecessary-done-label
+++ a/mm/highmem.c
@@ -736,11 +736,11 @@ void *page_address(const struct page *pa
 		list_for_each_entry(pam, &pas->lh, list) {
 			if (pam->page == page) {
 				ret = pam->virtual;
-				goto done;
+				break;
 			}
 		}
 	}
-done:
+
 	spin_unlock_irqrestore(&pas->lock, flags);
 	return ret;
 }
@@ -773,13 +773,12 @@ void set_page_address(struct page *page,
 		list_for_each_entry(pam, &pas->lh, list) {
 			if (pam->page == page) {
 				list_del(&pam->list);
-				spin_unlock_irqrestore(&pas->lock, flags);
-				goto done;
+				break;
 			}
 		}
 		spin_unlock_irqrestore(&pas->lock, flags);
 	}
-done:
+
 	return;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

