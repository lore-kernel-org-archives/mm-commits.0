Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93BEC07E95
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jul 2021 00:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A606142B
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jul 2021 00:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGCASq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 20:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhGCASq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 20:18:46 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BA4C061762
        for <mm-commits@vger.kernel.org>; Fri,  2 Jul 2021 17:16:12 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bu19so21087631lfb.9
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 17:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ypia1paC7/e079c6nL0ylVkOMwmDg83pa8q/R7dq2Ew=;
        b=cVhJPMc73/8yFbDGuuTQughSRD0S1HGVxBPmDEIVv7fIg06KE6tum4Ml2e6bomB9lf
         TorRWlavkLnFE1uBLDpbK3Wl33hb+h3w2ZK7exoAUXWmZCILXtNzl+yV4u2R6fSFZX4q
         z+iwi+/UsfnCHdwCxNcKE+1A4JO8kPUQGRoMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ypia1paC7/e079c6nL0ylVkOMwmDg83pa8q/R7dq2Ew=;
        b=p9kRTwfoNVcfhNt3rK3j8WVbGYGws2IxvWvLW07esLoihdLiarXRl59kpPgmHU25Hw
         Mb+WpnmgJDV1LU1pryyRWY8UtSJ8A12KBI7vMc5z6eWIYVnw2GjPzkzCRgK74/2OkQSp
         QLDQVO9ABwMEhPZWlU/b6jJmwO6EFe8+0BvYdYrIDqo7oVDZgxmcxVjMBJw0SGE7KOKR
         cZx+NdTiVyw8re5GhO+C62kMmZWHipjS6kUTopo9t2BT/EwIF3ZmLK0FY0mt3QGxsb8n
         mTJ8fMdgwWTApKYgmVMUOGHEThQN8hjpO/ZxG5looZzSMaeM08oPoouVzIEv42WhMf68
         3Wrw==
X-Gm-Message-State: AOAM530SmjpQsHpc9aTcGNg5RrEoIHaq9ATwOoChYsca4s59ymdeLLGF
        wdTdyW/lrxbWpjfQ80brwV7Ed+l1tfClBMnvTl8=
X-Google-Smtp-Source: ABdhPJyt+oKnid/xCef6jawVFFIou3KgXWPBiqbdCy/+sRR9gLWoeBMEtqt1F4oUt2CLJ2/XEAGNpQ==
X-Received: by 2002:a19:484b:: with SMTP id v72mr290843lfa.118.1625271369861;
        Fri, 02 Jul 2021 17:16:09 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id d5sm404994lfl.8.2021.07.02.17.16.09
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 17:16:09 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id e3so7165276ljo.6
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 17:16:09 -0700 (PDT)
X-Received: by 2002:a19:7d04:: with SMTP id y4mr1557652lfc.201.1625271358691;
 Fri, 02 Jul 2021 17:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015444.ZOZaFPX0b%akpm@linux-foundation.org> <202107021047.CC57ED634@keescook>
 <CAHk-=wiGcrds=Q7+utqPE7irvcsGfEY_qvp1+T7x67xdHbuSEA@mail.gmail.com>
 <87pmw0ih4e.fsf@disp2133> <202107021626.913478E@keescook>
In-Reply-To: <202107021626.913478E@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jul 2021 17:15:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi+-7LiS_seHErerr-J_MmTv6uY07kOoYkgHwGnPNdbqQ@mail.gmail.com>
Message-ID: <CAHk-=wi+-7LiS_seHErerr-J_MmTv6uY07kOoYkgHwGnPNdbqQ@mail.gmail.com>
Subject: Re: [patch 142/192] procfs: allow reading fdinfo with PTRACE_MODE_READ
To:     Kees Cook <keescook@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>,
        Alexey Gladkov <gladkov.alexey@gmail.com>,
        Hridya Valsaraju <hridya@google.com>,
        jamorris@linux.microsoft.com, Jann Horn <jannh@google.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Linux-MM <linux-mm@kvack.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Minchan Kim <minchan@kernel.org>, mm-commits@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 2, 2021 at 4:31 PM Kees Cook <keescook@chromium.org> wrote:
>
> Right -- the info leak would be snooping on what a privileged process
> was doing with a given fd? Similar stuff has been used to do typing
> pattern analysis with login passwords, but that's a stretch here, I
> think. Hmm.

So I think you'd see the directory list, but generally that's just the
file descriptor numbers.

Which is information you shouldn't have access to, but it's probably
not very *interesting* information.

I think it would be worth fixing but possibly not a very high priority.

             Linus
