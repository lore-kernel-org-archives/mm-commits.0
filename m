Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD44C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 08:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E6564ED6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 08:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhBXINK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:13:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:60392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234235AbhBXIMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 03:12:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C7517AD2B;
        Wed, 24 Feb 2021 08:11:58 +0000 (UTC)
MIME-Version: 1.0
Date:   Wed, 24 Feb 2021 09:11:58 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     akpm@linux-foundation.org
Cc:     mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject: Re: +
 hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch added to
 -mm tree
In-Reply-To: <20210224042858.x12k3SMNe%akpm@linux-foundation.org>
References: <20210224042858.x12k3SMNe%akpm@linux-foundation.org>
User-Agent: Roundcube Webmail
Message-ID: <9aa21b52622cbb9dd7bb8cb6be110f1c@suse.de>
X-Sender: osalvador@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2021-02-24 05:28, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: hugetlb: document the new location of page subpool 
> pointer
> has been added to the -mm tree.  Its filename is
>      
> hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch
> 
> This patch should soon appear at
> 
> https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch
> and later at
> 
> https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when
> testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Mike Kravetz <mike.kravetz@oracle.com>
> Subject: hugetlb: document the new location of page subpool pointer
> 
> Expand comments, no functional change.
> 
> Link: 
> https://lkml.kernel.org/r/20210224040439.351882-1-mike.kravetz@oracle.com
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

> ---
> 
>  include/linux/hugetlb.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> ---
> a/include/linux/hugetlb.h~hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2
> +++ a/include/linux/hugetlb.h
> @@ -476,6 +476,9 @@ unsigned long hugetlb_get_unmapped_area(
>   * huegtlb page specific state flags.  These flags are located in 
> page.private
>   * of the hugetlb head page.  Functions created via the below macros 
> should be
>   * used to manipulate these flags.
> + * Note: The hugetlb page subpool pointer previously located at 
> page.private
> + * was moved to page[1].private to make room for flags in the head 
> page.  See
> + * hugetlb_page_subpool().
>   *
>   * HPG_restore_reserve - Set when a hugetlb page consumes a 
> reservation at
>   *	allocation time.  Cleared when page is fully instantiated.  Free
> _
> 
> Patches currently in -mm which might be from mike.kravetz@oracle.com 
> are
> 
> hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch
> hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
> hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
> hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix.patch
> hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix-2.patch
> hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
> hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
> hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
> include-linux-hugetlbh-add-synchronization-information-for-new-hugetlb-specific-flags.patch
> mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
> hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

-- 
Oscar Salvador
SUSE L3
