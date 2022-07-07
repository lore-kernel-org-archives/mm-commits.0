Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40B8C43334
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jul 2022 22:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbiGGWVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 18:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbiGGWVs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 18:21:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81725606A8
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 15:21:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 184ED1FDC6;
        Thu,  7 Jul 2022 22:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657232506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uDHDhG9NPw/neydqh2XZzbUopVNo8yTZQO8eLqTUy5k=;
        b=gcLnt7aEdp95tMhRJbkQzfKQ55e2zqiqWFuDG+dgOHbqIeW23SbCYsFS3oNqm2MW1NU3uz
        N59oSytdTuSXRc5/wQHwNcVDwZF1z2BC6zz/H2Ix9gTin1JYOgwKg1DhyOvwlubuBJOpCd
        h73ziB+ofzyRLo0uJ2FmekGfLLByp4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657232506;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uDHDhG9NPw/neydqh2XZzbUopVNo8yTZQO8eLqTUy5k=;
        b=B2/bKCecPH+mwobQhpEAm4G2czR8k1288JyGoeYJolHMa3LAmTs1237AHuCEjbjU8o40iE
        iirLfxUxN+KPGrBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D763C13461;
        Thu,  7 Jul 2022 22:21:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3X85M3lcx2KhYAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 07 Jul 2022 22:21:45 +0000
Message-ID: <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
Date:   Fri, 8 Jul 2022 00:21:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch added
 to mm-unstable branch
Content-Language: en-US
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>,
        Hugh Dickins <hughd@google.com>, dan.carpenter@oracle.com
References: <20220707200919.90C41C3411E@smtp.kernel.org>
 <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
 <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 7/8/22 00:09, Yu Zhao wrote:
> On Thu, Jul 7, 2022 at 3:58 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 7/7/22 22:09, Andrew Morton wrote:
>> > The patch titled
>> >      Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
>> > has been added to the -mm mm-unstable branch.  Its filename is
>> >      mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
>> >
>> > This patch will shortly appear at
>> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
>> >
>> > This patch will later appear in the mm-unstable branch at
>> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> >
>> > Before you just go and hit "reply", please:
>> >    a) Consider who else should be cc'ed
>> >    b) Prefer to cc a suitable mailing list as well
>> >    c) Ideally: find the original patch on the mailing list and do a
>> >       reply-to-all to that, adding suitable additional cc's
>> >
>> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>> >
>> > The -mm tree is included into linux-next via the mm-everything
>> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> > and is updated there every 2-3 working days
>> >
>> > ------------------------------------------------------
>> > From: Andrew Morton <akpm@linux-foundation.org>
>> > Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
>> > Date: Thu Jul  7 01:06:35 PM PDT 2022
>> >
>> > add missing local_unlock_irqrestore() on contention path
>>
>> Doh, that's true and something to fix, although patch 7 did remove the bug
>> later in the same series so that wouldn't explain the lkp report for patch
>> 7. The reason lkp test robot complained was AFAICS that it was testing v4,
>> as I just replied there.
> 
> Sorry I didn't bother to reply until now: it did test v5, at this
> commit, not the whole series.

I meant this report that appears to be for v4 (full series including patch 7):
https://lore.kernel.org/all/YsFk%2FqU+QtWun04h@xsang-OptiPlex-9020/
That reported a bug due to missing unpin that was previously reported for v4
and fixed in v5.

I'm not aware of a lkp report for v5 (found only Dan's) but yeah, hitting
the (similar but not identical) bug fixed by this -fix would indeed be
possible in v5 if patch 7 was not applied.
