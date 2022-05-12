Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D8CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 21:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358755AbiELVet (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 17:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbiELVet (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 17:34:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C8924DC09
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 14:34:48 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so9008875pjb.3
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 14:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jt9NlBLwUnOqu1fcROK6uzGdhcYtT4/1vdEK6YtnE58=;
        b=pwEcbCR/IduE7yPE/YXiLXU8YQAuVL3rtErxQK2tebfj5lkfytYqL2uv8YaNpLvvlq
         jz/zbTkOn4hA9WDGL7PMFWS8vgf92kvJmlViRdGZPyeiOxPorf8X0qX+iK19cmPGQ5sI
         GV5UGJXauXNt+XAXArIgMsJBNRtLicuHX4yQlDuRHCSuYayWp67wvEdOMz7d4yZCyvCw
         GfgkSOU1hikHR2CoSsM8okJj/a+myTTlrN0GEqkpXM4HVbV9IvJGQXV44IGjgVl2p2R8
         k5L0VnZg2SOj6mQYUuD0e1IUY3eLlHbHizspJ+oFpxe5mvKqExh9Su0cZLkA8abUT3VS
         RYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jt9NlBLwUnOqu1fcROK6uzGdhcYtT4/1vdEK6YtnE58=;
        b=OIGl4PC+KW+r7/GkGieijIEc0izZMtGsnYopyl6StNKdf7i3XFzOxS+cD56/SSWTas
         m+HP4ekPHCaIC3rxP3/tP4dkT2qVanb1ZW0hPmi/C2THl8gT8NdtEibZubARW7OdXhOk
         VHDkdVVLtQKAhAEsWZbeCO6pDRWDCz9ZDQXiRCTOD0VUboi9cRVejdcqAiJIjqqKDstt
         e+CGheF2OlGZvpGjqNx1fB5pHOmmVa9OXoiBbYIGlsjt/dP6NbWM5l45/6wDD0VOFirb
         OU/E0LdLDoLWNa6DWpvjaQnNd7QWDaGfBpYTZ4aTehqBfKB/f28YLWRV/+/zN4S+aYrS
         lWLw==
X-Gm-Message-State: AOAM533XpPlvIeamTIRSH5VZhfezwpq5G14WrK0lyIcc/8MOR7GHGq6K
        1pLOM+rS+bTVNI+utCyZuno=
X-Google-Smtp-Source: ABdhPJwBq4UwqQFuT9ffvyyacSRhF6UPvv1NqfxaoL/2GZeI90Sn+I6FQ3s90/D6j+Dl/jXazQrDAg==
X-Received: by 2002:a17:902:b7cb:b0:15c:6650:a58a with SMTP id v11-20020a170902b7cb00b0015c6650a58amr1582296plz.63.1652391287912;
        Thu, 12 May 2022 14:34:47 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:872f:bbca:8e23:fae5])
        by smtp.gmail.com with ESMTPSA id x186-20020a6386c3000000b003c14af50634sm163227pgd.76.2022.05.12.14.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 14:34:47 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 12 May 2022 14:34:45 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        jhubbard@nvidia.com, david@redhat.com
Subject: Re: + mm-fix-is_pinnable_page-against-on-cma-page-v5.patch added to
 mm-unstable branch
Message-ID: <Yn19dQ27lveQBOAw@google.com>
References: <20220512204506.423D0C3411F@smtp.kernel.org>
 <Yn18AfcH26Rtry+/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn18AfcH26Rtry+/@google.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 12, 2022 at 02:28:33PM -0700, Minchan Kim wrote:
> On Thu, May 12, 2022 at 01:45:05PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-fix-is_pinnable_page-against-on-cma-page-v5.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-is_pinnable_page-against-on-cma-page-v5.patch
> > 
> > This patch will later appear in the mm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> > 
> > ------------------------------------------------------
> > From: Minchan Kim <minchan@kernel.org>
> > Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5
> > 
> >   * clarification why we need READ_ONCE - Paul
> >   * Add a comment about READ_ONCE - John
> > 
> > Link: https://lkml.kernel.org/r/20220512204143.3961150-1-minchan@kernel.org
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > Cc: "Paul E . McKenney" <paulmck@kernel.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  include/linux/mm.h |    9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > --- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page-v5
> > +++ a/include/linux/mm.h
> > @@ -1627,13 +1627,14 @@ static inline bool is_pinnable_page(stru
> >  {
> >  #ifdef CONFIG_CMA
> >  	/*
> > -	 * use volatile to use local variable mt instead of
> > -	 * refetching mt value.
> > +	 * Defend against future compiler LTO features, or code refactoring
> > +	 * that inlines the above function, by forcing a single read. Because,
> > +	 * this routine races with set_pageblock_migratetype(), and we want to
> > +	 * avoid reading zero, when actually one or the other flags was set.
> >  	 */
> > -	int __mt = get_pageblock_migratetype(page);
> 
> It makes build failure.
> 
> Could you pick this up instead?
> 
> https://lore.kernel.org/all/Yn10GkInyZNtqASa@google.com/

I really don't understand why it works or don't sometimes
At least, it works 

https://lore.kernel.org/lkml/Yn10GkInyZNtqASa@google.com/
> 
> Sorry for confusing.
