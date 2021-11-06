Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3598EC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 21:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C0DB61214
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 21:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhKFVQS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:16:18 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34118 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbhKFVQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 Nov 2021 17:16:17 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0C0761FD3B;
        Sat,  6 Nov 2021 21:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636233215; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvNa/BzcZtA+GjD5ywXYtZAaY5L8MN9Hcn7VzuEbm0w=;
        b=kTbQCkD0/suCBa9r09/ajOEAts9DybokSof0ET4RmJT4bjwcgRizV2T/OoGGFYPG/4IoIE
        BUwKBIfNoJGkpoI0faQ1EAO54qbdaSjS14dxjTODCi3PNOuYNJSU348uyaHq0Mv98uUQwJ
        MNGzRuWW0gNx2gXTqEZx0Hxe+N0e4YQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636233215;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvNa/BzcZtA+GjD5ywXYtZAaY5L8MN9Hcn7VzuEbm0w=;
        b=WUx34g0s6Qem0nhsNKt5XsC5OknnuravxNDW7zLmNXhOu3JUYZfo2HelmzXqjdvQFgeIKd
        c7eoIGog7ZdB20DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C0C5113AB3;
        Sat,  6 Nov 2021 21:13:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3y8FLv7vhmHsRAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Sat, 06 Nov 2021 21:13:34 +0000
Message-ID: <e08fa92e-31bc-c340-fd31-d4535d922aed@suse.cz>
Date:   Sat, 6 Nov 2021 22:13:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [patch 149/262] mm/vmscan: throttle reclaim until some writeback
 completes if congested
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Rik van Riel <riel@surriel.com>,
        Theodore Ts'o <tytso@mit.edu>
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105204225.iIh99P9cn%akpm@linux-foundation.org>
 <YYWb5jTLkNRUI6ea@casper.infradead.org>
 <CAHk-=wi=D7f9H=3cxcZm16-iCRJY5EBaJ4kTjp+UjpD4dsNKPw@mail.gmail.com>
 <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CAHk-=wgDdPxNWvQ8n=LW5bQeuq2WvP=5pnCZe2aubodfNR1JBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 11/6/21 22:12, Linus Torvalds wrote:
> On Sat, Nov 6, 2021 at 1:49 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> This workflow can result in more conflicts for me than what Andrew
>> used to do ("send against current linus tip"), but it means that when
>> conflicts happen, they get all the merge resolution help that git
>> gives you, and hopefully what gets tested (over the months that it can
>> be in -mm) is closer to what gets sent to me.
> 
> .. and resolving the conflicts (none of which looked bad), I think
> that part of the resolution ends up doing very similar things to your
> fixup patch.

If this needed resolution, didn't the resolution exist in -next already?

> So it looks all good.
> 
> Famous last words.
> 
>                 Linus
> 

