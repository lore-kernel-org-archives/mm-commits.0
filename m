Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3593AC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 17:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3CC64F1F
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 17:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhBZR4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 12:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhBZR41 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2021 12:56:27 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D4BC061574
        for <mm-commits@vger.kernel.org>; Fri, 26 Feb 2021 09:55:47 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id h4so11384995ljl.0
        for <mm-commits@vger.kernel.org>; Fri, 26 Feb 2021 09:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bi/M4WPuCcLtUoXWMq2ombpa2lu5IzNZ8ddS8Z/E04M=;
        b=FWaAhqE551i43fLrVXk0qpQ/cYZSzi3+vVRX3/WQR9KysW1b5D9mx/8XjPhy+vlS9w
         POqyHD3iZnB76d7LcHtG7xVi+IgEu4+O7zxlKeVIK2LrigOEREAc9SmVrIUslSr/7NAZ
         yp25VffJebxOIfn450pzgUBJe25lyeTczEgO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bi/M4WPuCcLtUoXWMq2ombpa2lu5IzNZ8ddS8Z/E04M=;
        b=EgiflU2e3tWaqZwkoKlAakX+JCUN+JHP9Fw6GiLD0/Udp6yhmHH80KcsBVkSoxmRCQ
         CZi12AqjKD7gnK1uyx4f5V8nrbp2nobyYqjkNXkezqn/T5SKqrNj4abeSkxdfwJ0YpG/
         YYu6VYJ4z4qTbNccb04EpMyEfr02HT2mTJ8gXwSUVHTkuGoBFIdS6fbpG6vZznPbwyqb
         MgkU3eK8yw1BEPi9OnONgN5Qr9YA4+fgutNSCe69KE+dqnrIkmzzzYfx1jYR4GfGLEp1
         QVU+sH8v9A0qFr6/JASTsuZozNi0B4ZCOfcfOszjt4oWBy4csMjlppKJfRJ13CC6DRLH
         eSyg==
X-Gm-Message-State: AOAM533vUG7/75QIN9kP7YQfRyJZFhvAA6H3at0nfTskZXQWzxGnQN6k
        m1FB3k2+P4vFzF1vZlohJCcwvD/dQWkgJg==
X-Google-Smtp-Source: ABdhPJwop93uJ+Df+nr/5znYqdDREjn5EP6LwRFEzQtecBIMyrUszVx9+acTUh3RfIAadDz81j2FAA==
X-Received: by 2002:a2e:94c8:: with SMTP id r8mr2343511ljh.332.1614362145306;
        Fri, 26 Feb 2021 09:55:45 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id 144sm1450521lfd.247.2021.02.26.09.55.44
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 09:55:44 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id b1so4294890lfb.7
        for <mm-commits@vger.kernel.org>; Fri, 26 Feb 2021 09:55:44 -0800 (PST)
X-Received: by 2002:ac2:41d5:: with SMTP id d21mr1853626lfi.487.1614362143872;
 Fri, 26 Feb 2021 09:55:43 -0800 (PST)
MIME-Version: 1.0
References: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 26 Feb 2021 09:55:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=whe0oboEyaUk-p8-wFWWCNDKWwy5vZbCEzm2ZNJTVLY-Q@mail.gmail.com>
Message-ID: <CAHk-=whe0oboEyaUk-p8-wFWWCNDKWwy5vZbCEzm2ZNJTVLY-Q@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Feb 25, 2021 at 5:14 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - The rest of MM.
>
>   Includes kfence - another runtime memory validator.  Not as
>   thorough as KASAN, but it has unmeasurable overhead and is intended
>   to be usable in production builds.
>
> - Everything else

Just to clarify: you have nothing else really pending?

I'm hoping to just do -rc1 this weekend after all - despite my late
start due to loss of power for several days.

I'll allow late stragglers with good reason through, but the fewer of
those there are, the better, of course.

Thanks,
                   Linus
