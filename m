Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C83EC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA880611AB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhEEBse (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhEEBsd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2021 21:48:33 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEE3C061574
        for <mm-commits@vger.kernel.org>; Tue,  4 May 2021 18:47:37 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u20so393951lja.13
        for <mm-commits@vger.kernel.org>; Tue, 04 May 2021 18:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZDFGw5M0zO7Swoz17vtWD1W5jd2sW/cTS4nC8TzDc+A=;
        b=I/JVrnAOhO443jLBvlShEOeta+t47UW55TTNxHgwAVQ0ZWT/L8fRB1tDttS0ZcEgcH
         dtQ8cd7U6VBzs3kwY8fcEShxtE2fosoyLxa6NakHNTCwF5A5DyYtWkGCkaWI05XObjiR
         BGN2EjfIsRkce4dh8Thl7rZeQaMeh1iaIDLao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDFGw5M0zO7Swoz17vtWD1W5jd2sW/cTS4nC8TzDc+A=;
        b=n+z5/wItl22onpmhF6TU5BT4MljzTKqwBXd3SEjCDyStgH69netS/HDvMk0xH0Sr7K
         r8lLYaYbdqnDHk7DgY3LmDeuOw2irsjYPP+fQCO/WGjSgT1U7554keEscp5Ft6oFdNHv
         eUrrsooUoHegjah5wNQRlt7a72nGQDDiyvq9SNU5Y8B85i80CNE4OuGO2yowbaJiMSd9
         htyUIj+r0AaKYjotb0I4wWpsrWxiRZTf4EVWFcNoEKeBbu8M/JwTtmc0yDLo8FsxEDHF
         iavS7iLvlfjZN5xikVP5fxC8juf8iteHEjWt5oPnsSMx1iM8KO+Bs7NZqKGIoMEQM/Qp
         jiiA==
X-Gm-Message-State: AOAM530emqs+4tKFFR6c+rj/jHc+yJVfngJVa9d52wR69JO/VlwE/dG9
        1cAT7Qf/cWW5+ZcEnCJTvqor8D1yLoIJAtYzR7c=
X-Google-Smtp-Source: ABdhPJzzPVWLgy1OhJyo2NrDDKvSxDDPhhuHD1jwqMFdqC7KZ8as+J0eoDyCLDw7f8xgddikUPx+aA==
X-Received: by 2002:a2e:9f43:: with SMTP id v3mr5439860ljk.458.1620179256203;
        Tue, 04 May 2021 18:47:36 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id s15sm1860156ljd.113.2021.05.04.18.47.35
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 18:47:35 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id z9so277773lfu.8
        for <mm-commits@vger.kernel.org>; Tue, 04 May 2021 18:47:35 -0700 (PDT)
X-Received: by 2002:a19:7504:: with SMTP id y4mr18128669lfe.41.1620179255453;
 Tue, 04 May 2021 18:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 May 2021 18:47:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjzDtUVs9To0nMerMt-XDiP3JH2ee=1A9z+0onQaFD4KQ@mail.gmail.com>
Message-ID: <CAHk-=wjzDtUVs9To0nMerMt-XDiP3JH2ee=1A9z+0onQaFD4KQ@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 4, 2021 at 6:32 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> 143 patches

Hmm. Only 140 seem to have made it to the list, with 103, 106 and 107 missing.

Maybe just some mail delay? But at least right now

   https://lore.kernel.org/mm-commits/

doesn't show them (and thus 'b4' doesn't work).

I'll check again later.

             Linus
