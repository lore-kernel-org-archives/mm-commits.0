Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54186C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41241610D2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347815AbhIBVyr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347877AbhIBVyi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 986D9610CE;
        Thu,  2 Sep 2021 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619619;
        bh=DTWTG9gVWp/29o4HzhhVP89+snAjpOzavGc7cJ3XeDM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IC+WlbhFzb+/Dhm5gaRPu0vCgilVZI82+y0C7aESs2jmryFL/CIzR+QSHNZIhxRyb
         lGGMdRT9VPc7dQYwZCBRmvNSbMV1VN9cp4O99coevUWEp8gOIr82C/sdwfgjcG5R++
         OfgugHm4iksC+NRRGJfRi0mYwZAKXL9qph6oerRA=
Date:   Thu, 02 Sep 2021 14:53:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        imbrenda@linux.ibm.com, jack@suse.cz, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 070/212] mm: gup: remove useless BUG_ON in
 __get_user_pages()
Message-ID: <20210902215339.7BPbOm3ul%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
