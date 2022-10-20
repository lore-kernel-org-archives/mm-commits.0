Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5F2C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 17:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJTRmp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 13:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiJTRmo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 13:42:44 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A831E3ED8
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 10:42:43 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id f14so169445qvo.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 10:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aC0xfu1B6fNyRi+1a2HnBL+x9wtUXIlU+HXHRKa4l7k=;
        b=Tm1MXKnUw1VmVXhBYAslQYVYO9XkI9B0equhCEe2+4qqf2dyeJSPfCIFoOg/W5W2k5
         M8asFhc9A90rqAqHhu3BLnAWM9VJXmxyoyc+6UuJ3g5GOwiHxozmDuVLu6Ap38EQ59Yi
         R3qGIE/ZwrslbiK7DUV5hDTbmAWFjUEOzgDGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aC0xfu1B6fNyRi+1a2HnBL+x9wtUXIlU+HXHRKa4l7k=;
        b=Q6Y4KpjwXl+v9TD/RG6hJNjUwoOlVu/JVX3b9CjYkdAErmuAj4KrMDhLB7vy6hI15H
         VGd10HNcxcNjkyq/xqfpl105DJou+UaifCaI+UWHUMoONZgkZtO4C1GLF1FmuTjmtueb
         OPP/BoiNXcmJ37CuO/EjdjlUmJYGINa/uYtMh4UxeKYxAjDT1p0/ncLJWFD4CzsViqaO
         wWCEeE/C53TVStv91hU9HiD0zBdnBWC/kbhrt0g6tpxDlT1gq6no1QP24QpXiBWMpxQQ
         CqNeNJF1m4QNCV6DveLkWGP3FueJxKUglVMT/HvFS15rCw4QG8eU7/+snQspVO8rjCwg
         7qsg==
X-Gm-Message-State: ACrzQf3uk8rsU7uADksYyi8l1y9gc9VOC9JboYU5Fut30MhyG7JmC5Wu
        0g23jgWDI0dxP8+VlZSCg80qp4JiCV8ofQ==
X-Google-Smtp-Source: AMsMyM7R+KRz7xcVyetYEBPnWDTIT0MsYnf2i3JeEeUrDnNVmI9O9+h6wz6UYd4hrKZY3s2m12OZgQ==
X-Received: by 2002:ad4:5dc8:0:b0:4b3:cf2b:b169 with SMTP id m8-20020ad45dc8000000b004b3cf2bb169mr12403334qvh.114.1666287762939;
        Thu, 20 Oct 2022 10:42:42 -0700 (PDT)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id r17-20020ac87951000000b0039cb9ef50b5sm6396752qtt.26.2022.10.20.10.42.41
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 10:42:41 -0700 (PDT)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-360871745b0so699657b3.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 10:42:41 -0700 (PDT)
X-Received: by 2002:a81:11d0:0:b0:35b:dd9f:5358 with SMTP id
 199-20020a8111d0000000b0035bdd9f5358mr12443561ywr.401.1666287761185; Thu, 20
 Oct 2022 10:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org> <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
 <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com> <CAHmME9qBZqTd0D_gr8nE+DUzCrC0fxZNZK=7u+21jbgtFgAJBg@mail.gmail.com>
In-Reply-To: <CAHmME9qBZqTd0D_gr8nE+DUzCrC0fxZNZK=7u+21jbgtFgAJBg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 20 Oct 2022 10:42:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjZDC9o8iwF+bU91Hx40HjGOpMui+VoFCDJkaGCu=rG4A@mail.gmail.com>
Message-ID: <CAHk-=wjZDC9o8iwF+bU91Hx40HjGOpMui+VoFCDJkaGCu=rG4A@mail.gmail.com>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct p4_event_bind::cntr
 signed array
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 20, 2022 at 10:33 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Or sometimes with objdump, I've had more success by keeping debug
> symbols, and then trimming offsets from jmps.

objdump is what I'm using, and it actually seems ok on individual object files.

Now I just need to script the "do all the object files" and see how
massive the end result is.

                Linus
