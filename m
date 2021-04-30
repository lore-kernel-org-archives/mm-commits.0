Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEBAC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 17:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD9E56145A
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 17:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhD3RLi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 13:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3RLh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Apr 2021 13:11:37 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65851C06174A
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 10:10:49 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id d15so30418714ljo.12
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 10:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h6zKQB1hU6LeihLyKF2xdhUvd0KNnL3qqh0QwJ6Trt4=;
        b=LeOtzSW5fZaPbs53Z0TqcsoXAReZVIBU4t7zpUrN9nX+AyDCaeIh+p4dQCuL6cyuf8
         NVicztGFHkaYpcFOyedauIP5sr7I5K2fos0rHlM3dRsA3jjzCk2mHX8TowPeXAub16SZ
         C/2VKlKae3qzRJgudoRkgxMZH9dPByWGpcnQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h6zKQB1hU6LeihLyKF2xdhUvd0KNnL3qqh0QwJ6Trt4=;
        b=nErTYthQj89Qml4wkIKSTNDXfmWI/8lZLp42re521HQitxMS18yIdsJvC3Vk+H71JP
         5aISMXPlJmrM/NqZ010n/cLrO/mgcl1flwyEbw9mAg3MMytOIATVecIWF/M5X2kRmkUo
         oOTTh+OXhC45eC79ZBtsf0/G1SHCkirRDHNdmFhZAREYqrxqiXPPzZjompmCaJMWstWJ
         GiZSEFVnBLOC2A39Xo756QkfDvAsCU3OSwT9fUl7jBRqvb1so+dUQ8ui3yjgbtxYmaed
         m4fqxdfU8Sf8wsWbn6mW/MHLmwDj5IOYfy26trR5TU6Q4pQ1wav91wlxNUaVWnB2j0wo
         mvGQ==
X-Gm-Message-State: AOAM531a0RHjRd4PLLXF2pLjJ+M5BguifHl+MzP34HfzzB52DhwlYb+f
        pAR6m3Qc75uP+MWx7CaFsk37CT3WkKfCECq6
X-Google-Smtp-Source: ABdhPJzPuSW8jFGBAPvlzYxstay1H/tv1C89XSEr0e8UA3leXJGFYL4Nnxt0gx8mGRU6wGjKM/mZTA==
X-Received: by 2002:a2e:9649:: with SMTP id z9mr4450987ljh.24.1619802647712;
        Fri, 30 Apr 2021 10:10:47 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id m22sm336543lfh.63.2021.04.30.10.10.46
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 10:10:46 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id 4so51254780lfp.11
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 10:10:46 -0700 (PDT)
X-Received: by 2002:ac2:5f97:: with SMTP id r23mr3864576lfe.377.1619802646506;
 Fri, 30 Apr 2021 10:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org> <20210430060213.LF6PpC21W%akpm@linux-foundation.org>
In-Reply-To: <20210430060213.LF6PpC21W%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Apr 2021 10:10:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=whRft5yDin-p1EtAEvJrHQ8SedOJEoUWpKxNNYOH8Fe8Q@mail.gmail.com>
Message-ID: <CAHk-=whRft5yDin-p1EtAEvJrHQ8SedOJEoUWpKxNNYOH8Fe8Q@mail.gmail.com>
Subject: Re: [patch 176/178] mm/page_alloc: redundant definition variables of
 pfn in for loop
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     huxiang@uniontech.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Apr 29, 2021 at 11:02 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> This variable pfn is defined repeatedly, so it can be deleted.

I'd actually much prefer this patch to be done exactly the other way:
avoid the variable name shadowing not by removing the second
declaration, but by actually making *both* declarations local to the
loops.

The lifetime of those 'pfn' variables really is just the inner body of
the loop, not the whole function.

Now, a good compiler will notice that the uses are entirely disjoint,
and not care about how the programmer used the same variable for two
different cases, but it's good practice to just minimize the scope of
a variable.

So I'm dropping this, but I would apply a patch that did something
like this instead

   void free_unref_page_list(struct list_head *list)
   {
        struct page *page, *next;
  -     unsigned long flags, pfn;
  +     unsigned long flags;
        int batch_count = 0;

        /* Prepare pages for freeing */
        list_for_each_entry_safe(page, next, list, lru) {
  -             pfn = page_to_pfn(page);
  +             unsigned long pfn = page_to_pfn(page);
                if (!free_unref_page_prepare(page, pfn))
                        list_del(&page->lru);
                set_page_private(page, pfn);

(UNTESTED, and intentionally whitespace-damaged, you get the idea).

        Linus
