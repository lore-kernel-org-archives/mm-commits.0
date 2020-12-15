Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7965BC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354E222D0B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgLOWtR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgLOWtM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 17:49:12 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4794C061793
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 14:48:31 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id u18so43562182lfd.9
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 14:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6SRWuFo92SM064QyV0W13yR71kbBhAobGQxQ9l5tQV0=;
        b=IwokctP9iac7BgaORL9Wl2HAGv8ftuxP51ZoQbpCD5Zay1eYecNU4vUPMmtxGDC7VO
         lP5x8kkCTqJBcuxHpUSXTiPFzC4yMjyzIRIAu4IzSNSKriMmVxLrPcEpYm+/eiEJlRgp
         f+npEKCzzkUS8XhDnsGTGEfIh+B+uncpjKGlk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6SRWuFo92SM064QyV0W13yR71kbBhAobGQxQ9l5tQV0=;
        b=QlB15X+o2CTaY/f2grds5pSPMYtIxmUKfE7RXTXrI3hityJc0dE9bhCpzlZ8w9mWSg
         Pql1vpr6Y0/u8LdPi0P5Bsva6DOPLKRaOrrgE/BkBFw8cPeidAEabymRZTTfunbB0FZx
         x6PfSi3u+83nfuvLOX3ZDH+rMQJZkewv7fm+BI4ODrbM47nWXGHIyicln1siEgX7DrFK
         q0ZxQ8c+7p1WrFnXKb/J6O+/27XSaPWibURc6gNqNMj/Cs10GHam3H627g9Wu7PIgPdd
         X4VJdV6GGXge8MZ/+lTfm9rvVN9Ys4p9BSWXahx2oA/frjCgn8NkAGPNhG8jQBmDIbEL
         o/5w==
X-Gm-Message-State: AOAM532ZBP+xOa2tdKsBKMG46Qio6oHXylWkBpHCOVhTQ6+i2hNDmMgy
        28rSQgxtlKY3jTbM2X+kPrT1ZbXinpA+RQ==
X-Google-Smtp-Source: ABdhPJyD84h0Ht5J8waLCu34nn0XEKqRC0J+Y98DOva2n3ko2fV8GlXFkvnQ6V1yMtulmtNBJ1JC8w==
X-Received: by 2002:a19:5ca:: with SMTP id 193mr12835818lff.375.1608072510106;
        Tue, 15 Dec 2020 14:48:30 -0800 (PST)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id q15sm13311ljh.136.2020.12.15.14.48.29
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 14:48:29 -0800 (PST)
Received: by mail-lf1-f43.google.com with SMTP id o19so17943172lfo.1
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 14:48:29 -0800 (PST)
X-Received: by 2002:a05:6512:3048:: with SMTP id b8mr12547465lfb.421.1608072508910;
 Tue, 15 Dec 2020 14:48:28 -0800 (PST)
MIME-Version: 1.0
References: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
In-Reply-To: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Dec 2020 14:48:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi2-u8+m2k=dt-=L8sjHC=nR-Z7Db9igZDCjnkis1G9gA@mail.gmail.com>
Message-ID: <CAHk-=wi2-u8+m2k=dt-=L8sjHC=nR-Z7Db9igZDCjnkis1G9gA@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 12:32 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> - more MM work: a memcg scalability improvememt
>
> 19 patches, based on 148842c98a24e508aecb929718818fbf4c2a6ff3.

With your re-send, I get all patches, but they don't actually apply cleanly.

Is that base correct?

I get

  error: patch failed: mm/huge_memory.c:2750
  error: mm/huge_memory.c: patch does not apply
  Patch failed at 0004 mm/thp: narrow lru locking

for that patch "[patch 04/19] mm/thp: narrow lru locking", and that's
definitely true: the patch fragment has

@@ -2750,7 +2751,7 @@ int split_huge_page_to_list(struct page
                                __dec_lruvec_page_state(head, NR_FILE_THPS);
                }

-               __split_huge_page(page, list, end, flags);
+               __split_huge_page(page, list, end);
                ret = 0;
        } else {
                if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {

but that __dec_lruvec_page_state() conversion was done by your
previous commit series.

So I have the feeling that what you actually mean by "base" isn't
actually really the base for that series at all..

I will try to apply it on top of my merge of your previous series instead.

              Linus
