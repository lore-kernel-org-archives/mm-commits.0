Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7ECBC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE12D61168
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 18:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346764AbhIHSjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 14:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbhIHSjY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 14:39:24 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27408C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 11:38:16 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id k13so6764687lfv.2
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=40kX6ALi5H/i1jZ+0bBNutAUbv1GhtRu7nONMHCvjlE=;
        b=VHPuad7+1hEYlx53CSpOcq9QDjSGL2whUm3DSn5BWvDDQb3cz6F1yY3nYbscrroilN
         2h4+d5l/jorNOjq66BOfFmpmCycAprLXtr5h+5Cl+yDd4ddafeIYJZmZc/Mu10P7a9Va
         I4l5UdYZen7/MMAwp1tjkarBS34zyjCJTUWlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=40kX6ALi5H/i1jZ+0bBNutAUbv1GhtRu7nONMHCvjlE=;
        b=p0w2Jpgj4NkQqEzhHcognqFvSfMhL/DbikvzgO7Bi3LMrtaQbhk47RbSr6u/co4Ply
         MWkJncck3HKY7+Gw57fDDF5E5arraQdgSUQVqhLUiJALO/Hfv376RzTsJqWaQXL0U2SC
         NkoeU1Wsrf8AceTFqLnIJUFmcJK8zfOM11xLcwiG/PNzYlWX6YzICB7hX8siSp8J4E3b
         lN81wjliAjynj9XnNiZOi7jRTvHcRXI/pFvh1kQ5ApvdtHxnIhh2luOeLornCPU60K3y
         9r8iDSkpwc2zdQ+twWqa64Nur/nvzz7apbo496Z8mFgb2c7VTHZFPxfAWU3FBWZCnuCy
         r1jw==
X-Gm-Message-State: AOAM532sw7dGKGg/y5jmJ4k6FWGcEENbK7GIOiDry5Yii5I+shzuuWhG
        7k/D+NTzYVta44aqQVmcsMTNy3mtawATPFiJVQA=
X-Google-Smtp-Source: ABdhPJz9K33KDXq6pasLFKbteVt2mQu6/GIMahRaCZl8xlxcHDQWcTwUuCYvyGQL8OZ+5bUTAVZWaw==
X-Received: by 2002:a05:6512:3a82:: with SMTP id q2mr3690616lfu.582.1631126293930;
        Wed, 08 Sep 2021 11:38:13 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id k16sm260545lfj.231.2021.09.08.11.38.11
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 11:38:12 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id m4so5066681ljq.8
        for <mm-commits@vger.kernel.org>; Wed, 08 Sep 2021 11:38:11 -0700 (PDT)
X-Received: by 2002:a05:651c:158f:: with SMTP id h15mr4085392ljq.249.1631126290952;
 Wed, 08 Sep 2021 11:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org> <20210908025901.gV9fu4cei%akpm@linux-foundation.org>
In-Reply-To: <20210908025901.gV9fu4cei%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Sep 2021 11:37:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
Message-ID: <CAHk-=wg-978nkW_zKigwRQSW4qAcn47q3gG5x45dOe6dh2dmUg@mail.gmail.com>
Subject: Re: [patch 108/147] bitops: move find_bit_*_le functions from le.h to find.h
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     aklimov@redhat.com, Alexander Lobakin <alobakin@pm.me>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dennis Zhou <dennis@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Will Deacon <will@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yury Norov <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 7, 2021 at 7:59 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Yury Norov <yury.norov@gmail.com>
> Subject: bitops: move find_bit_*_le functions from le.h to find.h
>
> It's convenient to have all find_bit declarations in one place.

What what what?

The subject line says "move".

The body of the commit message doesn't imply anything else.

But the patch doesn't "move" anything at all:

>  include/asm-generic/bitops/find.h |  193 ----------------------------
>  include/asm-generic/bitops/le.h   |   64 ---------
>  2 files changed, 257 deletions(-)

What's going on?

Dropped just because I refuse to have anything to do with patches that
lie about what they are actually doing.

                Linus
