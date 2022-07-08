Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E4BC43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 09:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237583AbiGHJED (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 05:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbiGHJEC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 05:04:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4D51EC46
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 02:04:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ACFC521F4A;
        Fri,  8 Jul 2022 09:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657271040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRLIQyoCtOFVjH2OSqZq2e9YgRzkJjcwx1lVHV9roj8=;
        b=y26Q5Mm/febDRTosqbQ0J9hjEJn5SncaKrPM5ZgUtLchoxAh2kUMXZSGCR1e+JsCRpN1Ea
        +XSrpdNLMGhUcqErmucTz9y8Uf2Ng4iKtuwkt6+rWL80UruflLcjU1Jeb7VXuwm/7vysBM
        a/sHemSrSykRvF0qVqTlFZOGPQq0J7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657271040;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRLIQyoCtOFVjH2OSqZq2e9YgRzkJjcwx1lVHV9roj8=;
        b=ZqZKc70dn6jG5hRP8L3hgc/eGiK/DZKsDhpH/1U1xnnV5JUBCXeGHdOElUJNiaLx1uB7YJ
        RYZjpCdvD8VvGBBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F83D13B24;
        Fri,  8 Jul 2022 09:04:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RFZ/HgDzx2LNPgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 08 Jul 2022 09:04:00 +0000
Message-ID: <ca2c4c67-f87e-fb50-5920-c6a84924915b@suse.cz>
Date:   Fri, 8 Jul 2022 11:04:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch added
 to mm-unstable branch
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>,
        Hugh Dickins <hughd@google.com>
References: <20220707200919.90C41C3411E@smtp.kernel.org>
 <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
 <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
 <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz> <20220708074106.GI2316@kadam>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20220708074106.GI2316@kadam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 7/8/22 09:41, Dan Carpenter wrote:
> On Fri, Jul 08, 2022 at 12:21:45AM +0200, Vlastimil Babka wrote:
>> >> > ------------------------------------------------------
>> >> > From: Andrew Morton <akpm@linux-foundation.org>
>> >> > Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
>> >> > Date: Thu Jul  7 01:06:35 PM PDT 2022
>> >> >
>> >> > add missing local_unlock_irqrestore() on contention path
>> >>
>> >> Doh, that's true and something to fix, although patch 7 did remove the bug
>> >> later in the same series so that wouldn't explain the lkp report for patch
>> >> 7. The reason lkp test robot complained was AFAICS that it was testing v4,
>> >> as I just replied there.
>> > 
>> > Sorry I didn't bother to reply until now: it did test v5, at this
>> > commit, not the whole series.
>> 
>> I meant this report that appears to be for v4 (full series including patch 7):
>> https://lore.kernel.org/all/YsFk%2FqU+QtWun04h@xsang-OptiPlex-9020/ 
>> That reported a bug due to missing unpin that was previously reported for v4
>> and fixed in v5.
>> 
>> I'm not aware of a lkp report for v5 (found only Dan's) but yeah, hitting
>> the (similar but not identical) bug fixed by this -fix would indeed be
>> possible in v5 if patch 7 was not applied.
> 
> My report is the LKP report?

Oh, right, sorry, I missed that the mail from you contains also Reported-by:
kernel test robot <lkp@intel.com>

> Some of the Smatch warnings from LKP get sent to me and then I look them
> over and either delete them or hit forward.  I don't have visibility
> into the LKP process more than just looking over the warnings so I can't
> say how it picks which patches to test off the mailing list.

Thanks for the clarification!
Vlastimil

> regards,
> dan carpenter

