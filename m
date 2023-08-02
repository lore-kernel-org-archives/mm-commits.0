Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B84C00528
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 07:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbjHBH7z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 03:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbjHBH7f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 03:59:35 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3989B1FEF
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 00:56:51 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RG47M0f3Rz4f3k6J
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 15:56:47 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
        by APP4 (Coremail) with SMTP id gCh0CgDXjLA7DMpknFSEPQ--.47479S2;
        Wed, 02 Aug 2023 15:56:45 +0800 (CST)
Subject: Re: +
 mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.p
 atch added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, willy@infradead.org,
        shikemeng@huawei.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com
References: <20230801191357.F0A8BC433C7@smtp.kernel.org>
From:   Kemeng Shi <shikemeng@huaweicloud.com>
Message-ID: <2912c26f-7a7f-f08d-4e54-50eb793c2cb3@huaweicloud.com>
Date:   Wed, 2 Aug 2023 15:56:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20230801191357.F0A8BC433C7@smtp.kernel.org>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: gCh0CgDXjLA7DMpknFSEPQ--.47479S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JF1UtF45XrW5Zr4rWF4xCrg_yoWxtry3pF
        y3uF1aqr4kWay3Zr17Jr4v9F18Aw4fJFWUWw1UGr18Z3Z0ya4IkFnayrn7ZrZ0gry3ZrW2
        9r4qgF92kFsrZa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew, sorry for bother. As Baolin menthioned in [1], no real issue will be triggered
after change in commit 9fcd6d2e052ee ("mm, compaction: skip compound pages by order in free
scanner"), this patch is not needed indeed. But other patches seems fine, is it OK for you
to drop this one or should I send a v2 series with this dropped.
Thanks!

[1] https://lore.kernel.org/all/f77676a5-e30b-d49d-54db-b85f1ad0f65b@linux.alibaba.com/

on 8/2/2023 3:13 AM, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/compaction: allow blockpfn outside of pageblock for high order buddy page
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Kemeng Shi <shikemeng@huaweicloud.com>
> Subject: mm/compaction: allow blockpfn outside of pageblock for high order buddy page
> Date: Sun, 30 Jul 2023 01:43:50 +0800
> 
> Patch series "Fixes and cleanups to compaction".
> 
> This series contains random fixes and cleanups to free page isolation in
> compaction.  This is based on another compact series[1].  More details can
> be found in respective patches.
> 
> 
> This patch (of 5):
> 
> Commit 9fcd6d2e052ee ("mm, compaction: skip compound pages by order in
> free scanner") skiped compound pages to save iterations and limit blockpfn
> to reach outside of page block in case of bogus compound_order.  While
> this also limit pfnblock outside page block in case a buddy page with
> order higher than page block is found.  After this,
> isolate_freepages_range will fail unexpectedly as it will fail to isolate
> the page block which was isolated successfully by high order buddy page in
> previous page block and abort the free page isolation.
> 
> Fix this by allow blockpfn outside of pageblock in case of high order
> buddy page.
> 
> Link: https://lkml.kernel.org/r/20230729174354.2239980-1-shikemeng@huaweicloud.com
> Link: https://lkml.kernel.org/r/20230729174354.2239980-2-shikemeng@huaweicloud.com
> Fixes: 9fcd6d2e052ee ("mm, compaction: skip compound pages by order in free scanner")
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Kemeng Shi <shikemeng@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/compaction.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> --- a/mm/compaction.c~mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page
> +++ a/mm/compaction.c
> @@ -678,8 +678,10 @@ isolate_fail:
>  	/*
>  	 * There is a tiny chance that we have read bogus compound_order(),
>  	 * so be careful to not go outside of the pageblock.
> +	 * Allow blockpfn outside pageblock in normal case that we isolate
> +	 * buddy page with order more than pageblock order.
>  	 */
> -	if (unlikely(blockpfn > end_pfn))
> +	if (unlikely(blockpfn > end_pfn) && total_isolated <= pageblock_nr_pages)
>  		blockpfn = end_pfn;
>  
>  	trace_mm_compaction_isolate_freepages(*start_pfn, blockpfn,
> @@ -1441,7 +1443,7 @@ fast_isolate_around(struct compact_contr
>  	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
>  
>  	/* Skip this pageblock in the future as it's full or nearly full */
> -	if (start_pfn == end_pfn)
> +	if (start_pfn >= end_pfn)
>  		set_pageblock_skip(page);
>  
>  	return;
> @@ -1713,7 +1715,7 @@ static void isolate_freepages(struct com
>  					block_end_pfn, freelist, stride, false);
>  
>  		/* Update the skip hint if the full pageblock was scanned */
> -		if (isolate_start_pfn == block_end_pfn)
> +		if (isolate_start_pfn >= block_end_pfn)
>  			update_pageblock_skip(cc, page, block_start_pfn);
>  
>  		/* Are enough freepages isolated? */
> _
> 
> Patches currently in -mm which might be from shikemeng@huaweicloud.com are
> 
> mm-correct-stale-comment-of-function-check_pte.patch
> mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
> mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
> mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
> mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
> mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
> mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
> mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
> mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch
> mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch
> mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch
> mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch
> mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
> mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
> mm-page_ext-use-page_ext_data-helper-in-page_owner.patch
> mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch
> mm-page_poison-remove-unused-page_exth-from-page_poison.patch
> mm-vmstat-remove-unused-page_exth-from-vmstat.patch
> mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch
> mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.patch
> mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip.patch
> mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch
> mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block.patch
> 
> 

-- 
Best wishes
Kemeng Shi

