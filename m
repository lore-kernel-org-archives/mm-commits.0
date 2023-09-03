Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415E8C001DB
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 00:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbjICAVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 20:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbjICAVo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 20:21:44 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1757CDD
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 17:21:39 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-58fae4a5285so2590447b3.0
        for <mm-commits@vger.kernel.org>; Sat, 02 Sep 2023 17:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693700498; x=1694305298; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IvbM2/1gKFrSJJRvB5gBe+id3FplScF5CRiZcA3oVU8=;
        b=yGZl74ZtnufbIVRwP3e65h1Z+XvIO9QOB18OAkiwrI4MLYF8sk46/2TVFZ+uSE2UFu
         mFdKo7S8hnNqirWVElll+PLo4qbpiXx5Qu12UOpntpbwA42LxJFnpHvwf85vugPwNdcE
         bIkI4TswjN/3Zg5pGdHVNp3FethXepr0CY706orSWQ1AbS4ycuLLX8rg/0OxfwyKEi7k
         Mn4umVGJ4fPZcOsa590Mcphh9z4zqPuFUqwjydJCl8yvPG2fUvNcvs6FHf5c4bvoUJws
         wwVEPU/kLT/Bdg5F7kUwbftPzyv24MOHDwKz1PbzkvAOGecD4M7mxY6Ahxkq9XHNuJ38
         cuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693700498; x=1694305298;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IvbM2/1gKFrSJJRvB5gBe+id3FplScF5CRiZcA3oVU8=;
        b=MK2cdd//HN7yqCbzLtPzt4m4M5XVLVwG4Rng/985yMdSwHLfPUxT7VEID6tSYXqpDj
         Y3OhS6R+g4KlOYpudpQiyQIl7oYUkz5UYqm+GVuGQTGhXRClaD5N84BiWVhIXGADUqhN
         UCjsMGIv2iCI4TO3M6jY8bp/Jxy2x1JxvW+sL6iN/ja4fxYsmcd2Jvz5j3eQFV40OPFe
         vKPBwidcqCSOv3Ru2En/jQW5PtQpvOaGVnOTTGZoza1ZsAaFuTnG3X8SyP/TCXuoQq3v
         fEEdq7U9RnJYGS4ed7s84YmwYDFinjA+0KfyCZCkdfVp6sLh/GdMYrhKzVjD+E70AO2i
         /PrA==
X-Gm-Message-State: AOJu0YxyxctgmpFvK4i9I9alYGOrsFJUCL+R8h3YnVAaKH/pIjrDteuw
        2tJpsOMBPcRdGsg3pR4b5pJ1pg==
X-Google-Smtp-Source: AGHT+IFUXqDyrmnWSmiHTV5D4+jIyrzxgURlAYJNPTrgGiqAb6sEkk3LEFOqAocL8G/xqZ+QqnpN5w==
X-Received: by 2002:a0d:f206:0:b0:576:ffe3:b95 with SMTP id b6-20020a0df206000000b00576ffe30b95mr6112692ywf.40.1693700498346;
        Sat, 02 Sep 2023 17:21:38 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id ce10-20020a05690c098a00b00598d67585d7sm933746ywb.117.2023.09.02.17.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Sep 2023 17:21:37 -0700 (PDT)
Date:   Sat, 2 Sep 2023 17:21:28 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Andrew Morton <akpm@linux-foundation.org>
cc:     mm-commits@vger.kernel.org, mikhail.v.gavrilov@gmail.com,
        dave.hansen@linux.intel.com, bagasdotme@gmail.com, hughd@google.com
Subject: Re: + mm-pagewalk-fix-bootstopping-regression-from-extra-pte_unmap.patch
 added to mm-hotfixes-unstable branch
In-Reply-To: <20230902222558.78D3FC433C7@smtp.kernel.org>
Message-ID: <56c3a296-79f2-ef65-7a3d-cfc4aa78df1f@google.com>
References: <20230902222558.78D3FC433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 2 Sep 2023, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/pagewalk: fix bootstopping regression from extra pte_unmap()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-pagewalk-fix-bootstopping-regression-from-extra-pte_unmap.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-fix-bootstopping-regression-from-extra-pte_unmap.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Hugh Dickins <hughd@google.com>
> Subject: mm/pagewalk: fix bootstopping regression from extra pte_unmap()
> Date: Sat, 2 Sep 2023 08:29:30 -0700 (PDT)

Thanks, Andrew, but it is already
ee40d543e97d23d3392d8fb1ec9972eb4e9c7611
in Linus's tree - I'm sure we all felt it was best rushed in.
(Or maybe you want to keep a copy in mm.git until that's rebased, okay.)

Hugh
