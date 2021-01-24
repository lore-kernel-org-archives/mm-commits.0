Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC96DC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 18:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5AD322CF6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 18:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbhAXSgr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Jan 2021 13:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbhAXSgn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Jan 2021 13:36:43 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A82EC061574
        for <mm-commits@vger.kernel.org>; Sun, 24 Jan 2021 10:36:02 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id q8so14577738lfm.10
        for <mm-commits@vger.kernel.org>; Sun, 24 Jan 2021 10:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tHvmvm8LfHj3VWe0O1lgUCfuyanyS5i+ivU3PE49c4=;
        b=bKqf8Rh488wt+m4JpGDauueNTTicFPfb/kBoQI0TImDJDMvp4ZFYLBKOLhpdp6xYdM
         d3KW+1+bStbBDAIOgTlKOdqEqm5gKTIsG7lEMM8T57hNTB+NUZvowiUYNZsvcHv8s5vo
         1rlX0exebqE6omdYhEzkRtcKDbRP25kR3clPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tHvmvm8LfHj3VWe0O1lgUCfuyanyS5i+ivU3PE49c4=;
        b=fqyTy6I1uKCEVEwL8KYt0lQRZtDBRifgitystJEGs1BhpTiV7KllrDk51c8x1sxdk/
         bIRECKW36tlaT/2GcR2xASykCP2HaOr6hnU3A9wb4NSjyWSMhct8PGhCay7xoDQExQRl
         ykWdbzvAAh2LGp/seMJIKys2or1hct3WWK6s+nczxutNPbKZDh7klxq5soTPDaO3hpUj
         0VhhKdlQh+GDNcTTfZvUB7W3sQt+epfmHMW2c22HjRQGa25+Cq8H6uGRcdB2Avtuv1xd
         zcBXNjTI3UG/77dd8zRxKropnP7/szmgoy+pUroncBYlcs3fCO4rcFouw2qWfhhd3BFD
         pRrQ==
X-Gm-Message-State: AOAM531JY0fu4esfkX6TsmCfWM8DgBeB/QmJ4nBqO9Z+d8yYAXr7ElJb
        TUKBpkwPedzlbjx8eKkZZj22Rc7ra6S3pQ==
X-Google-Smtp-Source: ABdhPJwicPqBcs2UCBDovZHIzJfolVgdxBQPaJWWFuMA4Li8He8R0qPddHjbZY2tY4/2NHcAHLq9Xw==
X-Received: by 2002:ac2:5b1b:: with SMTP id v27mr281576lfn.260.1611513360372;
        Sun, 24 Jan 2021 10:36:00 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id g12sm1498660lfc.269.2021.01.24.10.35.59
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 10:35:59 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id q12so14574405lfo.12
        for <mm-commits@vger.kernel.org>; Sun, 24 Jan 2021 10:35:59 -0800 (PST)
X-Received: by 2002:a05:6512:a8c:: with SMTP id m12mr105242lfu.253.1611513358889;
 Sun, 24 Jan 2021 10:35:58 -0800 (PST)
MIME-Version: 1.0
References: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
 <20210124050119.34lm1Gw1Q%akpm@linux-foundation.org> <CALvZod7vf=NF40xSFqtugaZUaVx7X75LS10dpF6Q8LR=R=JhDA@mail.gmail.com>
In-Reply-To: <CALvZod7vf=NF40xSFqtugaZUaVx7X75LS10dpF6Q8LR=R=JhDA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 24 Jan 2021 10:35:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgdgR-kLmOGsRdc63zXcr6-h3gfizYVGHNdAr5Fu0UkkA@mail.gmail.com>
Message-ID: <CAHk-=wgdgR-kLmOGsRdc63zXcr6-h3gfizYVGHNdAr5Fu0UkkA@mail.gmail.com>
Subject: Re: [patch 06/19] mm: memcontrol: prevent starvation when writing memory.high
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        mm-commits@vger.kernel.org, stable <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Jan 24, 2021 at 10:02 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> Johannes requested to replace this patch with
> https://lore.kernel.org/linux-mm/20210122184341.292461-1-hannes@cmpxchg.org/

I've dropped it (not replaced it - will wait for Andrew to
comment/send) from my queue.

          Linus
