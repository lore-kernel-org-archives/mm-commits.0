Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFACC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 17:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86BD061279
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 17:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhKHRcz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 12:32:55 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:37460 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhKHRcy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2021 12:32:54 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F2BF5212C2;
        Mon,  8 Nov 2021 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636392609; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OWI1nCB7f0aN2OQYFqbQwRLdzXnDoryx+hXcS9XW2CE=;
        b=VV/AGa5yhetUwyFekQOe6s7lStbdNKSb4soF7dI8m8BeY+AzvIf1dlwSSZQ3hH/2+mFBgh
        4Bs+xGmRREAVfnof0NA5F2N33DaH69/XF5KDHZcWGv0MAvE6AJsTxQI09TXuQv873DNW3/
        34F0LSzNXU/3vGlBx8ZtDI0hEQFOXyM=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C1519A3B88;
        Mon,  8 Nov 2021 17:30:08 +0000 (UTC)
Date:   Mon, 8 Nov 2021 18:30:05 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [patch 099/262] mm/vmalloc: be more explicit about supported gfp
 flags
Message-ID: <YYleneQXV/Jz619B@dhcp22.suse.cz>
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105203950.AJ1Cnteeh%akpm@linux-foundation.org>
 <YYjs7UT15WIF23DJ@dhcp22.suse.cz>
 <CAHk-=wjov5-baOgf+r7bOh=P_YCHuxBcyf_b=or990RTxz5QAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjov5-baOgf+r7bOh=P_YCHuxBcyf_b=or990RTxz5QAw@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon 08-11-21 09:15:04, Linus Torvalds wrote:
> On Mon, Nov 8, 2021 at 1:25 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > As already pointed out
> > http://lkml.kernel.org/r/YXE+hcodJ7zxeYA7@dhcp22.suse.cz this patch
> > cannot be applied without other patches from the same series.
> 
> Hmm. I've taken it already.
> 
> Not a huge deal, since it's a comment change - and the code will
> presumably eventually match the updated comment.

I plan to send the rest after the merge window.
 
> I guess it's a new thing that instead of stale comments, we have
> future-proof ones ;)

I just hope nobody gets confused about which are not supported yet. E.g.
GFP_NOFAIL, GFP_NO{FS,IO}. In both cases the direct use could lead to
bugs.
-- 
Michal Hocko
SUSE Labs
