Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8342AC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E73560F42
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhIBWvW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhIBWvW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Sep 2021 18:51:22 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE31C061575
        for <mm-commits@vger.kernel.org>; Thu,  2 Sep 2021 15:50:22 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id f2so6500739ljn.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 15:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FISTFKKG68XKmRRo0iqBBIeueiEstpYYd2qhaDE/qpE=;
        b=dfIzCNLT07v3R9U+MyjMBycMEvxO3vJKIcZqbzhJDkphFkb614uIglK7/rYXWGNin4
         dk1vNgx3A8EP+NRRwIfuQ9qIrdEsrNKpji2h1DHDS7BLx5vxFOmUvaZZBgPEt/uA082s
         Sug5vG3u8DxKLSGtQ33J95y3EaB0i5g2TNQC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FISTFKKG68XKmRRo0iqBBIeueiEstpYYd2qhaDE/qpE=;
        b=gIwc7bldV32fLNUCIxJiD5fo5De1hrEVTzS0GGDEOaqKKSdlo7oc1W4yycqbk9nVD5
         FgdUawJ3LzAP3rpj9rE4nEO4MJcQV6l42Ei9vIykjEewgkSHNuTxU0imHRlj8t/moTMW
         38Z+JgQRT8jR/v9UJ6WBLnT83B7nZmt5lU+9sR9GRHyCfTfnbwyOOFOC8A7k3bhHzSo7
         oIaV+qBh9nCf2ooTt0koXkzNDBXrguDwH5uspZ11MjFuwisKW5282T9IgeYJ92sPwzB2
         ZCGFxFZb3wdlQ0kgSIUjVyrkVoy/RB6p146+5WB11I8fEJCeKh9nW4FiWna9mJ6lSosE
         iQTw==
X-Gm-Message-State: AOAM531Zva6QcQkYdQ0lVBvlatvkQJlWYpvdE0b5UqXFKHCbPPTUuRoZ
        m+XA3mAkAFdJJ7bfV3UqJfAv0Z+XJSScOemP7dA=
X-Google-Smtp-Source: ABdhPJy58OmR5hhe1VC4ZD3X10yZB1+DWnPQ95q/mHZFJi2zOJ+JtXwhPHCTY0HG5vEXwo91DtV5+Q==
X-Received: by 2002:a05:651c:98c:: with SMTP id b12mr489753ljq.83.1630623020654;
        Thu, 02 Sep 2021 15:50:20 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id n25sm381068ljj.42.2021.09.02.15.50.19
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 15:50:19 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id t19so7684944lfe.13
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 15:50:19 -0700 (PDT)
X-Received: by 2002:a05:6512:3b7:: with SMTP id v23mr344546lfp.41.1630623019037;
 Thu, 02 Sep 2021 15:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210902215620._WXglfIJy%akpm@linux-foundation.org> <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
In-Reply-To: <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 15:50:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjC05YZycowZkmvjZACNEm3rUhLTneN+Vaz9Ebp1+++Gw@mail.gmail.com>
Message-ID: <CAHk-=wjC05YZycowZkmvjZACNEm3rUhLTneN+Vaz9Ebp1+++Gw@mail.gmail.com>
Subject: Re: [patch 119/212] lazy tlb: shoot lazies, a non-refcounting lazy
 tlb option
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 2, 2021 at 3:29 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> This pile is:
>
> Nacked-by: Andy Lutomirski <luto@kernel.org>

Can you specify exactly the range you want me to drop?

I assume it's the four patches 117-120, ie

  lazy tlb: introduce lazy mm refcount helper functions
  lazy tlb: allow lazy tlb mm refcounting to be configurable
  lazy tlb: shoot lazies, a non-refcounting lazy tlb option
  powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN

but I just want to double-check before I do surgery on that series.

           Linus
