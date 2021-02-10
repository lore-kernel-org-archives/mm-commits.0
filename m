Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDABC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 10 Feb 2021 19:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 678C864E76
	for <mm-commits@archiver.kernel.org>; Wed, 10 Feb 2021 19:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhBJTSK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbhBJTSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2021 14:18:09 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3021C06174A
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:17:29 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id g9so2920195ilc.3
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d/zvyGkMXSWn1Irdy78f+YeinsP4PWGDw5bwcL7LGws=;
        b=IqE3mV57l/0g6jQ18NeRBbzGO4KaSmn3sGEsPuXDj33Yc2acsiVs7+7PCrBYM0b6Bg
         kZ3WJWUGQA/OQ7BbmXzrOW9EalIbBP6NXFclRakur1e/4IR1AQ8BmYCQ1Yk+bqW07ubT
         ZjElBazyB/RwuiTj6TLEfnpKbIWdEL1p2NmuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/zvyGkMXSWn1Irdy78f+YeinsP4PWGDw5bwcL7LGws=;
        b=bNKH5eU1N84YxxyzOYd3H763TMfxYtdQjFXsQdPkmkMzspR/cFYxhky8v0A6l1ymbr
         14XRXQj8hPjUYE1g8SZxRvE+YNLxw80g877verizHxHM9FP2qsgjJk+200av0cJkpZeH
         buxz9XuNakfqnr2YwXLgtdCKbisyCUrBwKBu3cfeHUJ3fDF220f9/TJpoUEKoRFovutB
         VypG1QuC3fM1rHs3GxAs/DDsgujNp1cOpGV+1B55ynwPABf7tA4oKmKYMAspGzGEOOU6
         UWw81nazf61FqR1pyjTBrk2iDyvIHn3Qq8R5DzYutITxg5aYwpm+cDui426L1iBNSpSP
         dPVA==
X-Gm-Message-State: AOAM5336bQTAnn4n3KZukKPHEjxC01pHE3/iXTJ8Cj6zXR5Z0YyIhr9Y
        NLilP99jge1LN0iq6UumDpbhIxUG2jV93w==
X-Google-Smtp-Source: ABdhPJwjroCIYMyjyXbGm6TDb9xxortanhdwWiF1SAY7dhHBKx0XdLq99rqXrZSvrB9f4gA16D2HZw==
X-Received: by 2002:a05:6e02:12c7:: with SMTP id i7mr2458863ilm.66.1612984648426;
        Wed, 10 Feb 2021 11:17:28 -0800 (PST)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com. [209.85.166.176])
        by smtp.gmail.com with ESMTPSA id s14sm1454483iln.16.2021.02.10.11.17.26
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:17:26 -0800 (PST)
Received: by mail-il1-f176.google.com with SMTP id w1so1731272ilm.12
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:17:26 -0800 (PST)
X-Received: by 2002:a05:6e02:d0:: with SMTP id r16mr2465155ilq.112.1612984646136;
 Wed, 10 Feb 2021 11:17:26 -0800 (PST)
MIME-Version: 1.0
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
 <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org> <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
 <YCPgzb1PhtvfUh9y@osiris>
In-Reply-To: <YCPgzb1PhtvfUh9y@osiris>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Feb 2021 11:17:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=wghVA-6aNQz3rwr5VHmJAHkUvGyzKFpsEN1HPB5SL+aQA@mail.gmail.com>
Message-ID: <CAHk-=wghVA-6aNQz3rwr5VHmJAHkUvGyzKFpsEN1HPB5SL+aQA@mail.gmail.com>
Subject: Re: [patch 09/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Hugh Dickins <hughd@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linux-MM <linux-mm@kvack.org>, Matt Turner <mattst88@gmail.com>,
        mm-commits@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Seth Forshee <seth.forshee@canonical.com>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Tuan Hoang1 <Tuan.Hoang1@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 10, 2021 at 5:39 AM Heiko Carstens <hca@linux.ibm.com> wrote:
>
> I couldn't spot any and also gave the patch below a try and my system
> still boots without any errors.
> So, as far as I can tell it _should_ be ok to change this.

So your patch (with the fix on top) looks sane to me.

I'm not entirely sure it is worth it, but the fact that we've had bugs
wrt this before does seem to imply that we should do this.

I'd remove the __kernel_ino_t type entirely, but I wonder if user
space might depend on it. I do find

   #ifndef __kernel_ino_t
   typedef __kernel_ulong_t __kernel_ino_t;
   #endif

in the GNU libc headers I have, but then I don't find any actual use
of that, so it looks like it may be jyst a "we copied things for other
reasons".

On the whole I think this would be the right thing to do, but I'm a
bit worried that it's more pain that it might be worth.

Heiko, I think I'll leave this decision entirely to you. If you think
it's worth it to avoid any possible future pain wrt this odd inode
number thing for s390, just add it to the s390 tree with my ack.
Because honestly, I think s390 is the only architecture that really
cares by now.

               Linus
