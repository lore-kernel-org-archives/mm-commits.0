Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C3EC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jul 2022 22:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbiGGWKX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 18:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGGWKW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 18:10:22 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D2E2714D
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 15:10:21 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id t127so5783640vsb.8
        for <mm-commits@vger.kernel.org>; Thu, 07 Jul 2022 15:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X3YZubpaw8cjBSea/RsBeMHGQgMCw70kasBgs91t2KM=;
        b=bXSEKlV3cPJAEc1RlwIiiek9079bhQh8yWyoOrbJ7h9od4hUIe+9J79HJY6lDIui7O
         2dZAsmH2sAmPpCgf8d3dKdUJsZCkeV2agy9Iu+UEQDEgQF3o+vbUnMHFv/NDjokgkV+a
         b2Zdcjd6e9eWHQowRGGedtIv+S2XV159veveBt0WYKh6iYyzq8VL8WQsvSfm397FGIcE
         gVWiNI+XUtpwE4gWtd2lApJTOVoww+/uXsa1ruhRODlvs4TIgpIdp9rAexDjDo1H0iAM
         1ZEDUbBMO5mL0MG8v0KsUj8JfI9hludxn40xlSEN6CsdMcwYXMgaZeog6LH5snfpIkgX
         rGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X3YZubpaw8cjBSea/RsBeMHGQgMCw70kasBgs91t2KM=;
        b=afhqrkpOXT40d1EBnMANdpMgOV3Erf42MWSKJxhJwFEumzbpP6+Hqf5YojjroxKFXf
         zPTEVu1dtu9iGXSZmUlhuR2yapSnfNgKz5V20rM+1uVLwMt34pIGLKa2iBJdurhpVoM7
         zaerZbzdGLEiJDH//hb4l8B/5kceF+6gBFcR9Z2pIPSkLkI8w7mCwy7aLBjQDSUrQ+22
         olDgtGNl6Iy0yamdl7Of10q/f9KBWefxjMPx4zIVs2AGHw87KkkWG+ye8unsXsy92pcT
         dA6XGHZUcfC2lrSPxomDhZrkYw0spdAUDVbWHpvaCf6V2Ht8OdgnuYqgn5ZvH1RxiQZg
         PNsw==
X-Gm-Message-State: AJIora88RCHSNxEKRL5Qhx+ZLHDscaTAM9FUiAkFWxRZlHynV6gn8aQf
        u6RUc+s36pwj5ILNW4de0hbwYVM9sZEFp3ada+7Mxg==
X-Google-Smtp-Source: AGRyM1sSefOjFdeqPwsfwqMo3oy0hqfcVUYBh1LR77aEhIaYAq8TNH2Z3r54oAJbrvRATXYE/Wf/7KgiI6A+R9fimoA=
X-Received: by 2002:a67:d51b:0:b0:356:f1db:560b with SMTP id
 l27-20020a67d51b000000b00356f1db560bmr11633238vsj.15.1657231820719; Thu, 07
 Jul 2022 15:10:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220707200919.90C41C3411E@smtp.kernel.org> <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
In-Reply-To: <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 7 Jul 2022 16:09:44 -0600
Message-ID: <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch added
 to mm-unstable branch
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>,
        Hugh Dickins <hughd@google.com>, dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 7, 2022 at 3:58 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 7/7/22 22:09, Andrew Morton wrote:
> > The patch titled
> >      Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
> >
> > This patch will later appear in the mm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >
> > ------------------------------------------------------
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> > Date: Thu Jul  7 01:06:35 PM PDT 2022
> >
> > add missing local_unlock_irqrestore() on contention path
>
> Doh, that's true and something to fix, although patch 7 did remove the bug
> later in the same series so that wouldn't explain the lkp report for patch
> 7. The reason lkp test robot complained was AFAICS that it was testing v4,
> as I just replied there.

Sorry I didn't bother to reply until now: it did test v5, at this
commit, not the whole series.
