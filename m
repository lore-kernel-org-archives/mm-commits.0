Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B93C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 15 Jan 2021 23:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E00F239ED
	for <mm-commits@archiver.kernel.org>; Fri, 15 Jan 2021 23:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbhAOXdi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Jan 2021 18:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbhAOXdh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2021 18:33:37 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219A9C061757
        for <mm-commits@vger.kernel.org>; Fri, 15 Jan 2021 15:32:57 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id u25so15646086lfc.2
        for <mm-commits@vger.kernel.org>; Fri, 15 Jan 2021 15:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PeDwVtoZ/DIZ33+tDfPFE0OXzoxAXhUAdzcs9kleMpU=;
        b=AMUvRfknDB0NwcF6A7Xuh/qyrlRdrCwg8azMXfpTyiWlceVxemAjIIGntC0CyfB6hv
         BcmOdUvY2we1RrEyVhlvvxRnx38gkkLztoCgHOXg7M/l0cSxvK2l8ZbISJVscwngRdfU
         WWzLCiWul44+8mwvDMtIDSh+vDFfrLQ+jYK9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PeDwVtoZ/DIZ33+tDfPFE0OXzoxAXhUAdzcs9kleMpU=;
        b=Q742EoRP7eAcNra4LytzU+96ii3GXSUHiRUY5RM84V9l6xfEmRYSEEOUi7fzO2qOg8
         JRxAo14i4qwJEXWd0zmIRz/fANp4jjpj43SNI286Cq3vAHJrsI8aeYU/pjxIqINiYoa4
         UDzx9Fdp6IWyT2GVLf7MudN22NuTtwdFfsn0ventzdc/wxcwNUEqC+1wL7Tm22Dn8wVO
         t9e9SZwNiFHzDzSIK0ffn034zzQeGh4Dh6uGUbgFfkVPJI+E2chIPA03Tk+vojjIUgy3
         rYRc1dE1reASujfY8PJGzA4tlnRPg8mT44eGGZGffJ9RWNoPoVYpbFdAvAM5q0wvxX9s
         cnPg==
X-Gm-Message-State: AOAM532BUivvCSPdZwDXiOs3RwLfSD7SJergwGuPkH82WXQoXRvKGK7S
        79FDytYGNZmWkH8ILsAf+MIP6RPX46rrug==
X-Google-Smtp-Source: ABdhPJwTNHshpIJtbokl0qVJCLYjx7ZEBzFlfqyLEEXZKQ05uhGu4sgeHoBueThUq58/QLUQuA5gsw==
X-Received: by 2002:a05:6512:3253:: with SMTP id c19mr6362233lfr.631.1610753575211;
        Fri, 15 Jan 2021 15:32:55 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id e25sm1086957lfc.40.2021.01.15.15.32.54
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 15:32:54 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id s26so15604798lfc.8
        for <mm-commits@vger.kernel.org>; Fri, 15 Jan 2021 15:32:54 -0800 (PST)
X-Received: by 2002:ac2:420a:: with SMTP id y10mr4821582lfh.377.1610753574001;
 Fri, 15 Jan 2021 15:32:54 -0800 (PST)
MIME-Version: 1.0
References: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 15 Jan 2021 15:32:38 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjBMnu_Rmovea3mqN-RwefPCgpq-nrLC--aox7+S4gpzQ@mail.gmail.com>
Message-ID: <CAHk-=wjBMnu_Rmovea3mqN-RwefPCgpq-nrLC--aox7+S4gpzQ@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jan 12, 2021 at 3:48 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> 10 patches, based on e609571b5ffa3528bf85292de1ceaddac342bc1c.

Whee. I had completely dropped the ball on this - I had built my usual
"akpm" branch with the patches, but then had completely forgotten
about it after doing my basic build tests.

I tend to leave it for a while to see if people send belated ACK/NAK's
for the patches, but that "for a while" is typically "overnight", not
several days.

So if you ever notice that I haven't merged your patch submission, and
you haven't seen me comment on them, feel free to ping me to remind
me.

Because it might just have gotten lost in the shuffle for some random
reason. Admittedly it's rare - I think this is the first time I just
randomly noticed three days later that I'd never done the actual merge
of the patch-series).

               Linus
