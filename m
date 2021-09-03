Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869C7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 16:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E5C161051
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 16:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350064AbhICQgq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 12:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350057AbhICQgq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2021 12:36:46 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DFFC061575
        for <mm-commits@vger.kernel.org>; Fri,  3 Sep 2021 09:35:45 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id h1so10429186ljl.9
        for <mm-commits@vger.kernel.org>; Fri, 03 Sep 2021 09:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UrHzbO+aPJ2gt0TfLKDy/KoLK032o09R2ykCU8Cyn+8=;
        b=EusBIAnsGzxbAt5PyjtTSOJht0vfaNAWkkTaEOXc9uzPaNkRaJ4P5EHe7l1wf1A4nx
         cJl5Vsvy1k9EyMkvfG385z3kRQ/6GIk7e1TYwSHm8uRp6ftV/AXpy6rB/yhwItbHu0zk
         UEIvI+ErgnIGOQDmFh39Xfd6Vd9jLP00VjHbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UrHzbO+aPJ2gt0TfLKDy/KoLK032o09R2ykCU8Cyn+8=;
        b=Knw2LXUouGeYyDvHX3H7o6YGeG3QTVB6A9Ol2iUSWsSzbk8KdXK9lbbuKJdzXHIdwc
         ef4RPhNK9xusbf8fzYJf4dSv2m2ZJ5lCDzjw3CYwhU0SdZ4bbNxfOQQZ8Sb8xKIDZd0B
         fTt9dDODeg6m1t/PRQwXFngA7dysRD0FJuPgjEDjS4NhZsdZNK/vdxxCRqSWcbmdftKW
         UhkYvaZgHyTv+VNF7eGnfBq2+ufzBv8BHU9ZY8R8A8OcDnTRcn7LGpo8tZvNKBFyX0I2
         pekcEMqVINa5herebE7h+oZhHN4OWm2E9W+c80DYpbSwigh3zOOnTcNQVoTwTy6WfCs+
         wv2Q==
X-Gm-Message-State: AOAM531uXXMf/O2JfF09SfmM3MP3fGas3w96k8uDnRk1mR1ItxXiiOea
        TYhlECmeTItsydDru3h9aR1mSfd5mD8satXglo8=
X-Google-Smtp-Source: ABdhPJwY8hDCWILm8t84Wf5yldzVfafAuAaiBMz9q0xpbnzXmFMDu0VdQGUZr/EYxkTIl0J6Ci0cPg==
X-Received: by 2002:a2e:860e:: with SMTP id a14mr3676536lji.215.1630686943641;
        Fri, 03 Sep 2021 09:35:43 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id u14sm555372lfm.241.2021.09.03.09.35.42
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 09:35:42 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id k13so12876320lfv.2
        for <mm-commits@vger.kernel.org>; Fri, 03 Sep 2021 09:35:42 -0700 (PDT)
X-Received: by 2002:a05:6512:114c:: with SMTP id m12mr3488103lfg.150.1630686942198;
 Fri, 03 Sep 2021 09:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org> <20210902215342.RcyFEb0qQ%akpm@linux-foundation.org>
In-Reply-To: <20210902215342.RcyFEb0qQ%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 Sep 2021 09:35:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgQTRX=5SkCmS+zfmpqubGHGJvXX_HgnPG8JSpHKHBMeg@mail.gmail.com>
Message-ID: <CAHk-=wgQTRX=5SkCmS+zfmpqubGHGJvXX_HgnPG8JSpHKHBMeg@mail.gmail.com>
Subject: Re: [patch 071/212] mm: gup: fix potential pgmap refcnt leak in __gup_device_huge()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, Jan Kara <jack@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 2, 2021 at 2:53 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> +       int ret = 1;
..
> +                       ret = 0;
> +                       break;
..
> +                       ret = 0;
> +                       break;
..
> +       return ret;

Hmm. I think "ret" is unnecessary, and this could just have been

        return addr == end;

at the end to check that we did it all.

No?

                 Linus
