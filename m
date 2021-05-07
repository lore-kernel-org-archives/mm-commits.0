Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F16FC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 02:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0357F61157
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 02:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhEGCZy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 22:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbhEGCZy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2021 22:25:54 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9245C061574
        for <mm-commits@vger.kernel.org>; Thu,  6 May 2021 19:24:54 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2so10688944lft.4
        for <mm-commits@vger.kernel.org>; Thu, 06 May 2021 19:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0OkFpp3Tpm3CAdH//vkbEPOvgMuJGJC1iISmLvW+Rbc=;
        b=QP6NoIQh0vOG4cXH4h84nqiB/yQHy0e/v9/r7M7dZmAJ51A/oYPyfk4ZU+obfOPXQ6
         NWD3DLA1YTziKlS21/VSsG0cd9+6NUgzmqL4drba3HDDUxgpTBq1PVmkrk8v8H4V1ulB
         Cl3IeRQuC06e9OEbTtFkwg5XT5J4dXt0F68+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0OkFpp3Tpm3CAdH//vkbEPOvgMuJGJC1iISmLvW+Rbc=;
        b=fOG/He0EHf0XFNhaS417PK/g/RXP8M4uTe58uUCN7izBx+VsKrR1SYX0ihZ6bN12Dn
         C9rNGekZc4z2um9qBm1rRPuxP6CfSQyDgOsfzSTO8mhYdsPOt/v06r/ckiqk6ZlUi4QP
         5oXxGR6bz5jsTXPUYbODUB3Sz2ugp7ACG2dvM8El2NUbXivmBJyGwnclzhq6VzzVlSlP
         Q/Wbz0gwXjN/J0jcIHXsFOjTsYlx+pvQwqxmKwiVhUYEQehK2sbOIpj+pePzx1UPAqtd
         ZTAuZSIcG13PTblFRcyOu7ul++25Xf9LCU2V+uC0g42GIIvTm6v8WAM5xUlf7sQ/smYz
         llDA==
X-Gm-Message-State: AOAM5338HiGyS3z/04x6pKXNxVElZSUUJF/AtmRtv751nH46bmAVkei2
        QELLWHELIX8S1IQPBZ/DaTH3EHti0lSrcRCY
X-Google-Smtp-Source: ABdhPJzxZjJ93N6phNT1qpdaWhTbiKkrLbr+260n22QvJfFQDDpyvKMQFMX4P6hu/DFIp6C3Ex1+KA==
X-Received: by 2002:a05:6512:2312:: with SMTP id o18mr4890240lfu.159.1620354293229;
        Thu, 06 May 2021 19:24:53 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id u16sm1107760lfl.83.2021.05.06.19.24.52
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 19:24:52 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id u25so9620488ljg.7
        for <mm-commits@vger.kernel.org>; Thu, 06 May 2021 19:24:52 -0700 (PDT)
X-Received: by 2002:a05:651c:3de:: with SMTP id f30mr5755440ljp.251.1620354292233;
 Thu, 06 May 2021 19:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org> <20210507010213.V8MhqooKS%akpm@linux-foundation.org>
In-Reply-To: <20210507010213.V8MhqooKS%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 6 May 2021 19:24:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjKQZczi-J0rEUoPS+=Q6gCSpr3UmWzh-L8Qs9WGGUHuA@mail.gmail.com>
Message-ID: <CAHk-=wjKQZczi-J0rEUoPS+=Q6gCSpr3UmWzh-L8Qs9WGGUHuA@mail.gmail.com>
Subject: Re: [patch 04/91] proc: save LOC in __xlate_proc_name()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 6, 2021 at 6:02 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Subject: proc: save LOC in __xlate_proc_name()
..
> +       while ((next = strchr(cp, '/'))) {

Please don't do this.

Yes, gcc suggests that double parentheses syntax around an assignment
to avoid warnings.

gcc is wrong, and is being completely stupid.

The proper way to avoid the "assignment in conditional" warning is to
(surprise, surprise) USE A CONDITIONAL.

So that

          while ((next = strchr(cp, '/'))) {

is the crazy rantings of a misguided compiler. No sane human should
ever care about some odd double parenthesis syntax. We're not writing
LISP, for chrissake.

The proper way to write this is

          while ((next = strchr(cp, '/')) != NULL) {

which makes sense to not just a machine, but to a human, and avoids
the whole "assignment used as a conditional" warning very naturally.

See? Now it uses a conditional as a conditional. Doesn't that make a
whole lot more sense than the crazy ramblings of a broken machine
mind?

I fixed it up manually, I just wanted to rant against this kind of
"mindlessly take advice from the compiler without thinking about it".

                   Linus
