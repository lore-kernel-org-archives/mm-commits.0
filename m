Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC91C43217
	for <mm-commits@archiver.kernel.org>; Tue,  5 Apr 2022 12:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbiDEMUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 08:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357387AbiDELQW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 07:16:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3905F55A8
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 03:42:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E03091F390;
        Tue,  5 Apr 2022 10:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649155330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+H4P4bNulWWn09bZ5R2/U52bPwYuwRFND6EZfD1GhE=;
        b=EW1OXj+DiXGUoGgXyPfqYLsIw8yFr5j1qstt94IQ9cGpMGz7BJbvaCjyrdO3xNDk9YhHap
        alrsZWn3bLliFyXFLAbSq5CCv8eDFqpdRCYaaZJZXYm1qbF83PbgApI2GEE1Es63Au/Zob
        V6zTNMiWMukyez6Y8VqaffXCHMM6T1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649155330;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+H4P4bNulWWn09bZ5R2/U52bPwYuwRFND6EZfD1GhE=;
        b=QNjMilyY0GeJYMPkOfoKLJ5RHapW9KFXqloL5uRBpUa6fgq+SLaSRGVd0F+zbMZgIQCGE5
        ysDAcAJNx43t8/Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BD66F13A04;
        Tue,  5 Apr 2022 10:42:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BsqWLQIdTGKUWQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 05 Apr 2022 10:42:10 +0000
Message-ID: <b5d3b61a-02bc-0b46-95dc-bd99ec3d759a@suse.cz>
Date:   Tue, 5 Apr 2022 12:42:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: +
 mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch added
 to -mm tree
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        rppt@kernel.org, rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, ziy@nvidia.com
References: <20220404215048.01A9AC2BBE4@smtp.kernel.org>
 <a4256d36-6f6d-82d7-38a3-1af6f9b2457d@redhat.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <a4256d36-6f6d-82d7-38a3-1af6f9b2457d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 4/5/22 12:29, David Hildenbrand wrote:
>> +
>> +/*
>> + * This function checks whether a page is free && is the buddy
>> + * we can coalesce a page and its buddy if
>> + * (a) the buddy is not in a hole (check before calling!) &&
>> + * (b) the buddy is in the buddy system &&
>> + * (c) a page and its buddy have the same order &&
>> + * (d) a page and its buddy are in the same zone.
>> + *
>> + * For recording whether a page is in the buddy system, we set PageBuddy.
>> + * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
>> + *
>> + * For recording page's order, we use page_private(page).
>> + */
>> +static inline bool page_is_buddy(struct page *page, struct page *buddy,
>> +							unsigned int order)
> 
> Nit: Strange indentation of the last parameter. But it's already in the
> code you're moving, so ...
> 
>> +{
>> +	if (!page_is_guard(buddy) && !PageBuddy(buddy))
>> +		return false;
>> +
>> +	if (buddy_order(buddy) != order)
>> +		return false;
>> +
>> +	/*
>> +	 * zone check is done late to avoid uselessly calculating
>> +	 * zone/node ids for pages that could never merge.
> 
> I know, this is from existing code. But there really isn't a node check
> when relying on the zone id. I hope we are not missing a node check :)

AFAIK "zone_id" is in fact the combination of node+zone (or section+zone),
so it works as long as in config where it's a section
(NODE_NOT_IN_PAGE_FLAGS is defined) then there can't be multiple nodes in a
single section.

>> +	 */
>> +	if (page_zone_id(page) != page_zone_id(buddy))
>> +		return false;
>> +
>> +	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
>> +
>> +	return true;
>> +}
>> +
>> +/*
>>   * Locate the struct page for both the matching buddy in our
>>   * pair (buddy1) and the combined O(n+1) page they form (page).
>>   *
>> @@ -234,6 +295,35 @@ __find_buddy_pfn(unsigned long page_pfn,
>>  	return page_pfn ^ (1 << order);
>>  }
>>  
>> +/*
>> + * Find the buddy of @page and validate it.
>> + * @page: The input page
>> + * @pfn: The pfn of the page, it saves a call to page_to_pfn() when the
>> + *       function is used in the performance-critical __free_one_page().
>> + * @order: The order of the page
>> + * @buddy_pfn: The output pointer to the buddy pfn, it also saves a call to
>> + *             page_to_pfn().
>> + *
>> + * The found buddy can be a non PageBuddy, out of @page's zone, or its order is
>> + * not the same as @page. The validation is necessary before use it.
>> + *
>> + * Return: the found buddy page or NULL if not found.
>> + */
>> +static inline struct page *find_buddy_page_pfn(struct page *page,
>> +			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
>> +{
>> +	struct page *buddy;
>> +	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);
> 
> Nit: reverse christmas tree

Was ever reverse xmas tree part of mm/ style or whole Linux styel outside of
net?
