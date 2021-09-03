Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8F4C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4379760E9B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350048AbhICU5e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350079AbhICU5X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 712D260184;
        Fri,  3 Sep 2021 20:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702582;
        bh=tn7AMT/Sm26dmDFVDMeNbiFV5n5yl2bGpRDxuLFWCyA=;
        h=Date:From:To:Subject:From;
        b=MaZb9osZ0FvS3n2tqCyLCJArxYppdTDy4LGk/8x2ydAbANaXbg7RSXYSkDXJi/41d
         SZSGUz9GtK7IHQmYmafRTRToVkDpiGND4XFeNbrJHU4inZbAaU5OBRci1Gk0sQgauB
         eSX4nRK4k+sjZfuAP5CmZ7yLi2Fz637ACavIb1uo=
Date:   Fri, 03 Sep 2021 13:56:22 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, imbrenda@linux.ibm.com, jack@suse.cz,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-gup-remove-useless-bug_on-in-__get_user_pages.patch removed from -mm
 tree
Message-ID: <20210903205622.lpBx2PUSh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: remove useless BUG_ON in __get_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-useless-bug_on-in-__get_user_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: gup: remove useless BUG_ON in __get_user_pages()

Indeed, this BUG_ON couldn't catch anything useful.  We are sure ret == 0
here because we would already bail out if ret != 0 and ret is untouched
till here.

Link: https://lkml.kernel.org/r/20210807093620.21347-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/gup.c~mm-gup-remove-useless-bug_on-in-__get_user_pages
+++ a/mm/gup.c
@@ -1149,7 +1149,6 @@ static long __get_user_pages(struct mm_s
 					 * We must stop here.
 					 */
 					BUG_ON(gup_flags & FOLL_NOWAIT);
-					BUG_ON(ret != 0);
 					goto out;
 				}
 				continue;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

