Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396ABC4361B
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 09:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD13238E3
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 09:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLQJV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgLQJV4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2020 04:21:56 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1059CC061794
        for <mm-commits@vger.kernel.org>; Thu, 17 Dec 2020 01:21:16 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id a9so55564823lfh.2
        for <mm-commits@vger.kernel.org>; Thu, 17 Dec 2020 01:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RwEh0M4XyY2hiOmYBDj8f0F+ID8sJomDM2BqOgzIZ9k=;
        b=uBZ8T2nrpEWIdU8PlV1qYuUHOxEDPAmdJb5LDet6JO6Cz3ERDAf67rs5hBq83fBM5N
         igGk52whuX60s4CmRMpgTcPZRuDs2ZtbeP/rg94Gbj2CXW/hnGBYucnIi0WVhYx/Jyf9
         kzuSdq0zMCj/nKKROWtCoxkl4g9S8fMqeW7XEKUMi24kzemDBDryvQbDzboQHrpeZvRW
         IzGYQFUcGU4BesoJtR+FuKBHma62SCtIoj9//XSuFvDruaYt3DBuH+1uXvESgzdC4++e
         J99vF46bMaqjBr6kz2WSMf5F3skwtyNx75lpjyWwsSmgoP6yV3/dG+xKtLhOlW0Wn4VK
         8I2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RwEh0M4XyY2hiOmYBDj8f0F+ID8sJomDM2BqOgzIZ9k=;
        b=hBQe6NcaYWxy3QT2/WBWe0rJN3DKjjYc/5PmBJxtKp55U5JfOczpHpp+O54oEZfd8F
         Fz6e521fPrMpI7vngl0YUx6YUMHwcoGz+ebFpgKU7q/RL3X+sWWisBy6fizeyZLj6sAJ
         pRXrbDJJ33+EyWKKIvCb3d6lJHHNEBB6uYB2xK4XWHQxWHNBMzyDpdJNL0LQWDdLjHqc
         G/ZcNyeVrH1UQ3WycWYV1odfS0zs9g5K7OoYTWepgGfmG5icpWI7W1hr5OMqfBrQkfgW
         3FYsDAoYhKfCQ12CEnNQ6v0prOUJAVePv1fjk3NHfXpFxlOrn2YnpJVQPOKJblVnHttb
         VPDg==
X-Gm-Message-State: AOAM532jpzVauBCbqcbU3jmfsLyMvESXQf3BbiB8YWnM07Oo/TYTMcXA
        NSnIBpo4C/HfqiL3bAXFHGeAb1cn9edaxHTT9d4ynw==
X-Google-Smtp-Source: ABdhPJzMq3Tt4wcGf7njgjSinoEyB+6xUM0htdK8AamwRCPUhE3CSyC/igc7pTw7fwbGC3nWhOEuVNPpFClSIxEYJec=
X-Received: by 2002:a2e:8608:: with SMTP id a8mr16720171lji.89.1608196872037;
 Thu, 17 Dec 2020 01:21:12 -0800 (PST)
MIME-Version: 1.0
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
 <20201216044316.LYocMD9yH%akpm@linux-foundation.org> <CAHk-=wgkA+jbWhDTdOTYAjhYZgBt1jZmxtAMrQUFHmaZGMOV+Q@mail.gmail.com>
 <CABVgOSk3bwm_E_dhS=G7qsBHd4oXHZkpYeNOx=CtLQUapy0GTQ@mail.gmail.com> <20201216104142.GY4077@smile.fi.intel.com>
In-Reply-To: <20201216104142.GY4077@smile.fi.intel.com>
From:   David Gow <davidgow@google.com>
Date:   Thu, 17 Dec 2020 17:21:00 +0800
Message-ID: <CABVgOS=6Kt9owiH0dJZ7b7_hC4LUb=DpOfNmYrmEYg1HGpcYPA@mail.gmail.com>
Subject: Re: [patch 18/95] lib/list_kunit: follow new file name convention for
 KUnit tests
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Mark Brown <broonie@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        "Vaittinen, Matti" <matti.vaittinen@fi.rohmeurope.com>,
        mm-commits@vger.kernel.org, Vitor Massaru Iha <vitor@massaru.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Dec 16, 2020 at 6:41 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Wed, Dec 16, 2020 at 02:53:10PM +0800, David Gow wrote:
> > On Wed, Dec 16, 2020 at 2:02 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
>
> ...
>
> > > Don't send me any more rename patches until your tools can actually do renames.
>
> > My other thought is that this sort of patchset really makes more sense
> > to push through the kselftest/kunit branch anyway, as all of the
> > changes were really more KUnit related than anything else. Does it
> > make sense to re-submit this that way?
>
> I think it makes sense because this is driven by rules set up by kselftest/kunit.
> My main concern here is to have cmdline_kunit in the tree (it is a new file).
> Renaming is up to you, I just wanted to be consistent with names and KUnit
> documentation.

It looks like the cmdline_kunit changes have been merged now, so it's
a relief that those weren't held up: I agree that they're the more
important changes.

I do think renaming things to match the new convention is a good idea
(so thanks again for doing that), but it's not exactly an urgent fix.
My preference is that these get added to one of the kunit branches in
the kselftest repo, so they can be picked up when convenient. This
should just be the first three patches in this series:
https://lore.kernel.org/linux-kselftest/20201112180732.75589-1-andriy.shevchenko@linux.intel.com/

I'd expect those to still apply pretty cleanly, but I haven't actually
checked yet.

Cheers,
-- David
