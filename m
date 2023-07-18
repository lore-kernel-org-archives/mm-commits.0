Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E65EEB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jul 2023 18:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjGRSJq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jul 2023 14:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjGRSJo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2023 14:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0AD11B
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 11:09:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF04C616AC
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 18:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEE6C433C7;
        Tue, 18 Jul 2023 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689703732;
        bh=w5A3SRG2O8Imyk4u5Mhao5BkfkzLoRkGnBw47ucNSKs=;
        h=Date:To:From:Subject:From;
        b=HS2n83o1g7ah1WLnQZE7EVh5HF5+2lFj+Qh1KScV4VlACaVP5c2rM9q6g2RLf6Stx
         dImHnWAZ5BPtRWHyhlBmyrI3Gxj36Hy8Q8jlzDkBTUwHT2KuYR19ruYTmoR+m/GM0L
         ovxzQ4YzAgCa23kBiPVyJ0Q9ZNR1HiEADLnKjxlA=
Date:   Tue, 18 Jul 2023 11:08:51 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch added to mm-unstable branch
Message-Id: <20230718180852.3CEE6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: add common function to get client data from page_ext
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: add common function to get client data from page_ext
Date: Tue, 18 Jul 2023 22:58:10 +0800

Patch series "add page_ext_data to get client data in page_ext".

Current clients get data from page_ext by adding offset which is auto
generated in page_ext core and exposes the data layout design inside
page_ext core.  This series adds a page_ext_data() to hide this from
clients.  


This patch (of 3):

Add common page_ext_data function to get client data.  This could hide
offset which is auto generated in page_ext core and expose the desgin of
page_ext data layout.

Link: https://lkml.kernel.org/r/20230718145812.1991717-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230718145812.1991717-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/page_ext.h~mm-page_ext-add-common-function-to-get-client-data-from-page_ext
+++ a/include/linux/page_ext.h
@@ -82,6 +82,12 @@ static inline void page_ext_init(void)
 extern struct page_ext *page_ext_get(struct page *page);
 extern void page_ext_put(struct page_ext *page_ext);
 
+static inline void *page_ext_data(struct page_ext *page_ext,
+				  struct page_ext_operations *ops)
+{
+	return (void *)(page_ext) + ops->offset;
+}
+
 static inline struct page_ext *page_ext_next(struct page_ext *curr)
 {
 	void *next = curr;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch
mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch
mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch
mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch
mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch

