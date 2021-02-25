Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A39C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 01:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35DCD64E85
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 01:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbhBYBwr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 20:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbhBYBwr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2021 20:52:47 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169C5C061574
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 17:52:07 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id j19so6081338lfr.12
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 17:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nuEwacw9WQYf7hqKeQHh+UiK1mAkKdfy2q7SV6e4fgo=;
        b=USn4m91gCrg/tHu49UfSsfjmTB5sGx2Y/Mtg72X4FUydasLo+OTlGYtBumcw24QK52
         iaMJjwti2qOaGaWqVhmk1vsoV8PXgnL9GlhOEYhf9s50YfZeyNHcr7vKVxBD/iz89qtj
         PyQOxUTIsPB0qvjfHbOnJlGUmyDQIXUMsHtlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nuEwacw9WQYf7hqKeQHh+UiK1mAkKdfy2q7SV6e4fgo=;
        b=BBZz6KozapikMUyP9NiH20Rrjndb6FIZOhSSmSE92LrYElWaDSN9W3MD9n0CXYMTbT
         0v9psM9iugr/+VzZb+G4WChBmtUxGZl9ExA23v2XSx9imSyzHYrztv2GIE9Tyjk7vR4W
         Zill7T0DF8ZllhVUKPcm0+Jhj6I3y0PWRfTbXK/xA8osgU+7I7v12BWOuHjWpxVmboJW
         hHx+cD9RROI/bS7yl1GC60+DZrZiArP/FeUGcmx08ZHoztePqXkNEHiUXMBHZLh5IPbf
         GqxmOTdyMhR0y8ekNxc+hgit1qrImLLhqDpcM82Zv0DROlp5Iw6CypHlZPEwKlya72t6
         yntQ==
X-Gm-Message-State: AOAM533b+rvzwFUChPPrVL/e8K0obUb/KgSyXT1sRgKmiZYaqBwzn88t
        5Hf5MiQ3ZyYY4oaMkFGI9ule3NIsUpcm7w==
X-Google-Smtp-Source: ABdhPJwRbzqSq62vcxbcV8S2VPN9KgtRwtKvKc2AdvW7M2mHhmmsd/lmFDDe5s6MjRgDZ2SKcoUHmw==
X-Received: by 2002:ac2:5184:: with SMTP id u4mr460764lfi.487.1614217924338;
        Wed, 24 Feb 2021 17:52:04 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id p9sm526188ljn.16.2021.02.24.17.52.03
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 17:52:03 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id u4so6173273lfs.0
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 17:52:03 -0800 (PST)
X-Received: by 2002:a19:8186:: with SMTP id c128mr459588lfd.377.1614217922822;
 Wed, 24 Feb 2021 17:52:02 -0800 (PST)
MIME-Version: 1.0
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <20210224200055.U7Xz47kX5%akpm@linux-foundation.org> <20210224203708.4489755a@oasis.local.home>
In-Reply-To: <20210224203708.4489755a@oasis.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 24 Feb 2021 17:51:46 -0800
X-Gmail-Original-Message-ID: <CAHk-=whoqLWCcUXOBfWsEu49jLRJFkwnCRq6dyjg_M=dO1FhcQ@mail.gmail.com>
Message-ID: <CAHk-=whoqLWCcUXOBfWsEu49jLRJFkwnCRq6dyjg_M=dO1FhcQ@mail.gmail.com>
Subject: Re: [patch 014/173] mm, tracing: record slab name for kmem_cache_free()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, jian.w.wen@oracle.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 24, 2021 at 5:37 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Please do not apply this patch as is, it is very buggy!

Sadly, it's already there and pushed out.  I try to wait a few hours
(sometimes overnight) with Andrew's series before pushing things out
in order to catch comments like this, but this one came too late.

I can obviously revert, but if the fix is the two-liner you outlined,
perhaps that is better? Mind sending it as a patch (or just putting it
in your tracing tree)? Or Jacob? A tested patch along the lines that
Steven outlined?

               Linus
