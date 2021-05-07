Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59ED1C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 07:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1995B613D6
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 07:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhEGHNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 May 2021 03:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhEGHNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2021 03:13:30 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADEFC061574
        for <mm-commits@vger.kernel.org>; Fri,  7 May 2021 00:12:29 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id c3so11368109lfs.7
        for <mm-commits@vger.kernel.org>; Fri, 07 May 2021 00:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vZU6CZhyeJkt24upSsaVh0Sfws7MZza4FtVyrq444RM=;
        b=Up1YaHxbYZwLL0nZA8XeLJy0/KBx+SrVCE+SEqvwZfE/8l6A203fwih7kJbOQWI6qA
         pW9e8mXYDVhIQ8z5QKGzH8zAu/BPEDbQ1/0XyU3NG8s4jdRT17JozMg1qiAUiCzx5wNi
         8w5IHRe1dHEoNyfGHAZW9whVlloqxgRCSbFQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vZU6CZhyeJkt24upSsaVh0Sfws7MZza4FtVyrq444RM=;
        b=iwqNw1Ud6coSEfV/xS+U/Gx6WCTBs7RtRmZcve+UDLVm1YJoaPn5Sj3lwhYjQhupCo
         qBSP3KdaavvMLwGhmlnANR3Jwm5DDO4JMLlmiC+1dOgGMo0SbnTKl7WQZpLv/aITH3X6
         47YSQvK8buduUsJJCkvidUXTM0eQu0IOX+8TDNYP9m10CAHiyg99DjsLpzQXktA+qV8t
         NntNqRx8kM2o3cAi/FOycXWhAaLUTfadFok0Tkzl1zQ2WIriPVT7EXjOnPW5/+7nYamx
         6CNzj3X1q3fdBJuIuP+zZ3dQwlZo/VK4UT9UGD+B7A7GQVVouni22a8VUhZf8f2kBNyP
         XO4Q==
X-Gm-Message-State: AOAM532wpgiLcPJ695uUX9TJdp2sGgxD6ruDwprJZ46baROj49s5BbLh
        z8fHEd91MeAc1UvriynwQ0cVAF7dhg+0WByojzs=
X-Google-Smtp-Source: ABdhPJxpeSSdWqpDatjQPLDgpHZ33rdHWkcaLCF2718d0TFjrtNVELgW3wNwZYtmNDHXltXE+/mvLw==
X-Received: by 2002:a19:ac4d:: with SMTP id r13mr5185788lfc.360.1620371547911;
        Fri, 07 May 2021 00:12:27 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id v16sm1254223lfi.131.2021.05.07.00.12.26
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 00:12:27 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id u25so10276321ljg.7
        for <mm-commits@vger.kernel.org>; Fri, 07 May 2021 00:12:26 -0700 (PDT)
X-Received: by 2002:a05:651c:3de:: with SMTP id f30mr6489888ljp.251.1620371546749;
 Fri, 07 May 2021 00:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 May 2021 00:12:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjHOZk_WdgsHQ2U+y5GGMWc+Psfc3jAzd4FJC9bQh7ApA@mail.gmail.com>
Message-ID: <CAHk-=wjHOZk_WdgsHQ2U+y5GGMWc+Psfc3jAzd4FJC9bQh7ApA@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 6, 2021 at 6:01 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I've been wobbly about the secretmem patches due to doubts about
> whether the feature is sufficiently useful to justify inclusion, but
> developers are now weighing in with helpful information and I've asked Mike
> for an extensively updated [0/n] changelog.  This will take a few days
> to play out so it is possible that I will prevail upon you for a post-rc1
> merge.

Oh, much too late for this release by now.

> If that's a problem, there's always 5.13-rc1.

5.13-rc1 is two days from now, it would be for 5.14-rc1.. How time -
and version numbers - fly.

             Linus
