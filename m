Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D72AC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 07:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1472023370
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 07:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgLPHCf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 02:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgLPHCf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2020 02:02:35 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BEDC0613D6
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 23:01:54 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id a12so45725541lfl.6
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 23:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Efy7xGOEJeAUIqpTtciaKkWLNptuk1Ubb2q7twIrRWo=;
        b=h4yQH6nCVLgQ6IDhqEP8gBB8ErFS6BuhVvABoo6Pi2Z+G6PyuJPmpVA59VZ89War7k
         PuoYuqD8djL5J5e/GV7ctm/modYCRbowDCy0YPss4RfpuFVafiC1FKwffRMyHl3ke9/J
         p/eJGwBRUVuTpgA47vGilj/5NZYTJUsDeePi0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Efy7xGOEJeAUIqpTtciaKkWLNptuk1Ubb2q7twIrRWo=;
        b=ckR/sgJQe+bzXsBhQV2P493J/yMkxkxpF7zZAZ14EWRgu4GWkR7kRidpMOsJotL4sn
         2uaKAmn+N/5aa/nt8WyI/Im7Iy8xBWnQm40Sl02l/hB1sJAgBIHV0NLSsOdD5kmKGJgu
         Hv6lnmQjE26Lfe7vxg/PTjWuN69wr43Pj1dsKvTrc0sAWabYrrxCCjlvJZsyDHtAqyOT
         XnpuGug7I2xOLJKpUT+7PyKJ49Xpdt4y9/vDzMKPWM+Et9oBCgNFjjbxQnGbLXTRaPj2
         13ZrysARt3vYEQ9BmcEjQt3Lpo0a0LV5cUBGxbdi+jLAupfH70RF9qgMAo4wVQBZnyuS
         Fe6w==
X-Gm-Message-State: AOAM530xHQLKALRzgFTcaBcs03y0YBQpczWEJ9vis1QQUXiAQx2ylwVJ
        JnGp5k/dX16pFesqKAnWL4rwq9SXT2fljw==
X-Google-Smtp-Source: ABdhPJxm3G6hUC/MTi/Geu6OBjWFRuQvvcNqLgldv93C9nZo8maJDW8bACDSWjeU12UV38sd/tT8Mg==
X-Received: by 2002:a19:c018:: with SMTP id q24mr8164525lff.631.1608102113106;
        Tue, 15 Dec 2020 23:01:53 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id w10sm114762lfe.107.2020.12.15.23.01.51
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 23:01:52 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id o17so42782586lfg.4
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 23:01:51 -0800 (PST)
X-Received: by 2002:a2e:6f17:: with SMTP id k23mr14132450ljc.411.1608102111454;
 Tue, 15 Dec 2020 23:01:51 -0800 (PST)
MIME-Version: 1.0
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
 <20201216044316.LYocMD9yH%akpm@linux-foundation.org> <CAHk-=wgkA+jbWhDTdOTYAjhYZgBt1jZmxtAMrQUFHmaZGMOV+Q@mail.gmail.com>
 <CABVgOSk3bwm_E_dhS=G7qsBHd4oXHZkpYeNOx=CtLQUapy0GTQ@mail.gmail.com>
In-Reply-To: <CABVgOSk3bwm_E_dhS=G7qsBHd4oXHZkpYeNOx=CtLQUapy0GTQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Dec 2020 23:01:35 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi5mVOpsb23DHmE9NNLjudj1uCpHBTUQUF0UouraMf7ng@mail.gmail.com>
Message-ID: <CAHk-=wi5mVOpsb23DHmE9NNLjudj1uCpHBTUQUF0UouraMf7ng@mail.gmail.com>
Subject: Re: [patch 18/95] lib/list_kunit: follow new file name convention for
 KUnit tests
To:     David Gow <davidgow@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Mark Brown <broonie@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        "Vaittinen, Matti" <matti.vaittinen@fi.rohmeurope.com>,
        mm-commits@vger.kernel.org, Vitor Massaru Iha <vitor@massaru.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 10:53 PM David Gow <davidgow@google.com> wrote:
>
> I know the original patchset did have an issue (with one of the other
> patches) that Andrew fixed while merging, so maybe it snuck through
> while that was happening.

Yeah, I suspect it happened when Andrew was shuffling things around.

And it's probably partly due to the fact that the patches themselves
are _really_ hard to actually read, because all the real changes are
hidden by the huge patches to remove and add files.

When you have 1600 lines of patch, it's really easy to get "patch
blind" and miss the small patch fragments that change the Makefile or
Kconfig file etc.

Back in the days when we worked almost exclusively with patches (ie
before BK and git), we had very high barriers for renaming files
partly for this exact reason.  Renames as patches are just _so_ hard
to read. It's almost completely impossible to see if it's a pure
rename of if something else also changed, when you have one big hunk
that completely removes one file, and another big hunk that completely
adds a new one.

Of course, patch conflicts when there are changes to the files also
then make renames a huge pain in that situation.

With git, we've been *much* more open to file renames, because git
itself handles at least the usual simple cases of merge conflicts
automatically for us, and follows renames etc. And the git diff
extension to actually show renames as renames in a diff make it a
*lot* easier to see what a rename patch actually does.

But as long as renames are treated as patches, I'm going to go back to
the old rules that were "we never rename a file unless there is some
absolutely massive critical reason to do so".

                Linus
