Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DABC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242427AbhKXWNB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbhKXWNA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Nov 2021 17:13:00 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A047EC061574
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 14:09:50 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id q25so8337549oiw.0
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 14:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1myEKnMfoQBKxq5UKBKkKOY+cGa8Yz6i2GBLIOr5bo=;
        b=Kp6qVtcf9TEjgMMwMKdmlAG5kMvBoDPr+9kXxy7xFfU8MOCWm/KvyeTWEAcW0Jj+ra
         3KT31PG7DIdJBQJS3uRwr/dm55gwHz/+1Pj9cbonO0lCP6Z6HDz+MLFGsXTHued+cZMN
         JLjnkaxz84P6WtPnHBQkQ6EKgF2oyMABy6YvYYM3WJKerv/ZZRwxyFfaBHoel7Q2bYeu
         DT8E/mQs/I3jcFNMg33gN9gf5Kkg1OqAJEeJU72vWl61GHDnNIWo0OQa89zommoPsuZp
         C+Zgg0HTDPOg95Z5tUTtWfbi291bo/Qhc8TXFkH+o0t1/XQ4E97ysLApiWPJMhC4yG8o
         YNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1myEKnMfoQBKxq5UKBKkKOY+cGa8Yz6i2GBLIOr5bo=;
        b=VuqsnJG1Lzuc0RG+5Sgx6JG5okt1Ngs+fMH5J0pdHS8P8MKJQsc5g5KTIBFcvwZGcB
         vn+vQIT/oeTAEIvq2BfKpjcjn1mfXeoFUw+U/yHUdC0HCqqr1Uqm8UGOZpddmzL/JsvV
         CF0PTNCe0sKPaToi0RdBTqo53Zbj6iF2ALQg7m5hFqEnuQ0yp0mVBXUUmM4+18R38hfc
         8YCgneBT5lo+KQYDjlWDJdIxCd3Zw1R2vFzNzS1/UxLh4iO2q3EvcLuCSPAtcqj8pAlw
         Ut8OJUb6zkd/EkPF5op47bhApYnCgr5gS1mYJTT8997gvk3zfKIawO2lM5IjZqH+8PnE
         gOCQ==
X-Gm-Message-State: AOAM533pLPti/oFOFlQtjHGB3kt3ZWPpcrzsg53TStXtwIw4fmVT7sdy
        yq9YyiUR/lB2wava38hfiYdKkuyNaDB3zl6pPVSkEw==
X-Google-Smtp-Source: ABdhPJz+IQouh0ZmyBtfl3lUFiMGPY5R3YAhKwMtNV4W7lrrlRzmy9ZeXnqGzhP4RND38LFWaJCgB2QoiH+LLztsaIs=
X-Received: by 2002:a05:6808:118c:: with SMTP id j12mr9807014oil.65.1637791789757;
 Wed, 24 Nov 2021 14:09:49 -0800 (PST)
MIME-Version: 1.0
References: <20211124212054.GQBSK_Ilb%akpm@linux-foundation.org>
 <CANpmjNPnepsX=pt3FYkpUmSU3ZU2VSCraOyNKfUXveLhR+b15g@mail.gmail.com> <nycvar.YFH.7.76.2111242242090.16505@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.2111242242090.16505@cbobk.fhfr.pm>
From:   Marco Elver <elver@google.com>
Date:   Wed, 24 Nov 2021 23:09:38 +0100
Message-ID: <CANpmjNPJea+ZeyUsHgwMJ_fch240J3j5zHazjWVR+ZPioyHZKA@mail.gmail.com>
Subject: Re: + kasan-distinguish-kasan-report-from-generic-bug.patch added to
 -mm tree
To:     Jiri Kosina <jikos@kernel.org>
Cc:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        dvyukov@google.com, glider@google.com, jirislaby@kernel.org,
        mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 24 Nov 2021 at 22:44, Jiri Kosina <jikos@kernel.org> wrote:
> On Wed, 24 Nov 2021, Marco Elver wrote:
>
> > Oh dear, I don't think we were ready -- this patch would cause all
> > kinds of issues:
> > https://lkml.kernel.org/r/CANpmjNOHN7SWu-pKGr9EBb3=in2AWiGmqNb6sYwhebGtRk+1uQ@mail.gmail.com
>
> Yeah, I wasn't expecting it to be queued right away after you've raised
> your concerns indeed :)
>
> I still hate the fact that it's pretending that real BUG() is happening,
> while it's in fact not, in passion (yes, it did bite me :) ), with
> passion.

Well, unfortunately the term "BUG" is overloaded in the kernel, which
is probably part of the problem. I think we just have to live with
that.

The other thing is, you have a lot more to complain about: git grep 'pr_.*BUG:'
;-)
Most of them don't panic either (and aren't BUG()s).

> How many known tools are there that are relying on this format?

I don't know. Off the top of my head, various bots (syzbot, Intel test
robot?), also internal CI pipelines; some personal scripts (although
they look for "BUG:"); probably many more.

The reality is that this format is "the interface" now with which
tools extract errors from dmesg. Changing it is akin to changing an
API.

Would you be happier if we documented everything in one file? Though
given git grep 'pr.*BUG:', this is probably a huge task. But maybe we
just have to list the ones that panic by default or can be made to
panic with a flag?
