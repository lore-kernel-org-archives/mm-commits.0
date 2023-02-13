Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F97C636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 22:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBMWTl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 17:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjBMWTk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 17:19:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA1C1BAFA
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 14:19:39 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v13so14898969eda.11
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 14:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DdMCs5H/JbVPnWmVGco7GaqG11iC0AcIT5fsrf+QDfI=;
        b=KFhLIbySr50Oa8sCR5/ttrXS+KaoYFaH6AeqV/8/irVu90nmkKYvpyt1TUBsRKxQc2
         iFw2sIJul+x6NLvT3VEF5EcS7gCvG9AeCpfAtltEgntiSmb4MN++sQrtO7ovQ57xEPoR
         +IZ/HqRpLpbx6wQzywccDeDlwK04i5gUsyZEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DdMCs5H/JbVPnWmVGco7GaqG11iC0AcIT5fsrf+QDfI=;
        b=TLx3g89i2V3gYs0hCA7ezyfj6yG79y4V2jSyzs38+rNSNoi5FByzo/BL8WMhSAzo2p
         WcYGTcTSGiy186x8aVbzilN0gpiZu3sr1EWo5+XQGhxqVKxJJgfne83f2f5jxwGTeDha
         /CcMTUNZCi5x0WQUX11ov1/rZcUlpUfqyVh+1LjGIJgvg62SYZ8eoPMxtXr3NT4XZdn7
         64A4Xq8AKpXzRXpRmR5wlw46+i6DMZpdXi0owQGrT2kYVOS+BhzK4EqK50l4rToG1eWS
         cYEfEFeG3vFLX4BFanmsPVdJNRytbKhdOFI9m9PnWdek2oj//7i34+pRJXsfKo/bKDQc
         YWlQ==
X-Gm-Message-State: AO0yUKWvuvL7iJmv3hnYaBlDL2vnRHr+wrvVTDu9DiPNKKD0xMq6TJPJ
        3UtJKmO6kFLtjXEjLSHnlZGmUTT8WJTH6KvnQA8=
X-Google-Smtp-Source: AK7set8zCyjcoSXiPmvNM46o2v3UQ13WurNAmcXLjuWBJ3Dmb95TPgev8VrliL2zeuSQ/KlJJOiWkw==
X-Received: by 2002:a50:bb62:0:b0:4a2:4ed3:c151 with SMTP id y89-20020a50bb62000000b004a24ed3c151mr219155ede.39.1676326777637;
        Mon, 13 Feb 2023 14:19:37 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id cq5-20020a056402220500b004acb2c8aeaesm5163338edb.85.2023.02.13.14.19.36
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 14:19:37 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id hx15so35430670ejc.11
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 14:19:36 -0800 (PST)
X-Received: by 2002:a17:907:984a:b0:88f:a9ec:dfd7 with SMTP id
 jj10-20020a170907984a00b0088fa9ecdfd7mr268381ejc.0.1676326776594; Mon, 13 Feb
 2023 14:19:36 -0800 (PST)
MIME-Version: 1.0
References: <20230213140812.db63c7146ebc396691594b73@linux-foundation.org>
In-Reply-To: <20230213140812.db63c7146ebc396691594b73@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Feb 2023 14:19:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiBrY+O-4=2mrbVyxR+hOqfdJ=Do6xoucfJ9_5az01L4Q@mail.gmail.com>
Message-ID: <CAHk-=wiBrY+O-4=2mrbVyxR+hOqfdJ=Do6xoucfJ9_5az01L4Q@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.2
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Feb 13, 2023 at 2:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Kuan-Ying Lee (1):
>       mm/gup: add folio to list when folio_isolate_lru() succeed

Ugh. I really hate fixes like this.

The problem came from mis-understanding the return value of
folio_isolate_lru(), and thinking that it was a boolean
success/failure thing.

It wasn't, it was an integer "success/errno" thing, and the sense of
the test was wrong. So the patch is

-       if (!folio_isolate_lru(folio))
+       if (folio_isolate_lru(folio))
                continue;

but at no point was the code *clarified*.

Wouldn't it have been much better to write the new code to be

        if (folio_isolate_lru(folio) < 0)
                continue;

to actually make it clear that this is a "negative error return check".

I've pulled this, but I really think that when somebody notices that
we had a silly bug because of a misunderstanding like this, it's not
just that the bug should be fixed, the code should also be *clarified*
at the same time.

                 Linus
