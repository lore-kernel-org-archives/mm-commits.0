Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8209DC4332D
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66C4864FD9
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhCMFHk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhCMFHX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C71E564F87;
        Sat, 13 Mar 2021 05:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612043;
        bh=DAdzuv+DDliyMTDupt43ZegZpf6p0LEoTKsrBSuuGy4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Mnt+kMXnA/BdAJqZQgFYbjZR4jjynqn8OyeYv173XnTzSbunzCX8f76zxr/lBDV1g
         6DU6qgUd2dYSwoKXEs1oBYOGSnoBdiFuReV/oK/r457vDpvum0QSG9qXATu1ajGbTs
         /K0z2l2r7UI9KO7DhW7X6VA7Bg06QyV2s6XQIf7I=
Date:   Fri, 12 Mar 2021 21:07:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adobriyan@gmail.com, airlied@linux.ie,
        akpm@linux-foundation.org, daniel@ffwll.ch,
        david@gibson.dropbear.id.au, galpress@amazon.com, hch@lst.de,
        jack@suse.cz, jannh@google.com, jgg@ziepe.ca, kirill@shutemov.name,
        ktkhai@virtuozzo.com, linmiaohe@huawei.com,
        linux-graphics-maintainer@vmware.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, sroland@vmware.com,
        torvalds@linux-foundation.org, willy@infradead.org, wzam@amazon.com
Subject:  [patch 07/29] hugetlb: break earlier in
 add_reservation_in_range() when we can
Message-ID: <20210313050722.nUfetTcPM%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: hugetlb: break earlier in add_reservation_in_range() when we can

All the regions maintained in hugetlb reserved map is inclusive on "from"
but exclusive on "to".  We can break earlier even if rg->from==t because
it already means no possible intersection.

This does not need a Fixes in all cases because when it happens
(rg->from==t) we'll not break out of the loop while we should, however the
next thing we'd do is still add the last file_region we'd need and quit
the loop in the next round.  So this change is not a bugfix (since the old
code should still run okay iiuc), but we'd better still touch it up to
make it logically sane.

Link: https://lkml.kernel.org/r/20210217233547.93892-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Gal Pressman <galpress@amazon.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Roland Scheidegger <sroland@vmware.com>
Cc: VMware Graphics <linux-graphics-maintainer@vmware.com>
Cc: Wei Zhang <wzam@amazon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlg-break-earlier-in-add_reservation_in_range-when-we-can
+++ a/mm/hugetlb.c
@@ -387,7 +387,7 @@ static long add_reservation_in_range(str
 		/* When we find a region that starts beyond our range, we've
 		 * finished.
 		 */
-		if (rg->from > t)
+		if (rg->from >= t)
 			break;
 
 		/* Add an entry for last_accounted_offset -> rg->from, and
_
