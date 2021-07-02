Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0418EC07E95
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 19:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E253C6141D
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 19:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhGBTDD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 15:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhGBTDD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 15:03:03 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33CAC061762
        for <mm-commits@vger.kernel.org>; Fri,  2 Jul 2021 12:00:29 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r20so19144ljd.10
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 12:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=atEbqDv+e/wpi1BSg3HZbvigb6Fs3eD+eWqGWV43rpE=;
        b=Zs1daiUnEBZt/PaOoN7ikcf1ja9Zmm89Dl9RsGqJY5Ho1W6CnXm3tnu4ieJviKXxx/
         oLUGNNI1bKPKhhRnjBLNOIyoM6jr6DEsRIsvlBjd4Kfrj0CLioM8qknZ2uLNLVSo8XaK
         w9pXJy02dvnXH5eZZEv+Z3DDxlCY3+vyYWREU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=atEbqDv+e/wpi1BSg3HZbvigb6Fs3eD+eWqGWV43rpE=;
        b=JOnlniL2fLjLxoCtuasJ/X7M4Ah4l8rDMsElyLnUfyiTZmSEV/iM5DMDrdEQPpfV7q
         3QzmLpiX/9wRAf/97j6JOHebxCNkQoThLcnAWO6jIL8OvuP6fsGXmh2DFg9BOoEkWjWM
         79TrxQZTvfksBNRYgr8yn22JkalQHiJoTQD39GZ5q0lPztGxDUPd+7FUhnNM3PyPnRrq
         7ETPo+b/eRG4UE2bGcdEokz18tyVigVFUX7gQYdyMMfSpxhwC8pbI9UbylmtyrYwOk3P
         MEDnuOKTCC/pEQ+oo0ABXXw7IJLacVQ4ejeoVgSSbwZuJ7io1eSLSwMYTc8vPIQIfDOu
         nkVQ==
X-Gm-Message-State: AOAM530LrMYr9QSeRpN/pGz9t1FBSFpo72tUA7zrgDYoU65SJFf8dzyO
        dg+QVRtlVmpGsVJp/idrr0MkuH1BvWeAtS0K
X-Google-Smtp-Source: ABdhPJzTqwOIDtEx9dilUo5SYiVCuxBEmxGU+1gknwEXi58amTQcTMsOhaLdIepGbymemDgWG5aYUg==
X-Received: by 2002:a2e:9c94:: with SMTP id x20mr662757lji.435.1625252427391;
        Fri, 02 Jul 2021 12:00:27 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id u2sm347843lff.73.2021.07.02.12.00.27
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 12:00:27 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id bq39so7211641lfb.12
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 12:00:27 -0700 (PDT)
X-Received: by 2002:a2e:b553:: with SMTP id a19mr650860ljn.507.1625252416176;
 Fri, 02 Jul 2021 12:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015444.ZOZaFPX0b%akpm@linux-foundation.org> <202107021047.CC57ED634@keescook>
In-Reply-To: <202107021047.CC57ED634@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jul 2021 12:00:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiGcrds=Q7+utqPE7irvcsGfEY_qvp1+T7x67xdHbuSEA@mail.gmail.com>
Message-ID: <CAHk-=wiGcrds=Q7+utqPE7irvcsGfEY_qvp1+T7x67xdHbuSEA@mail.gmail.com>
Subject: Re: [patch 142/192] procfs: allow reading fdinfo with PTRACE_MODE_READ
To:     Kees Cook <keescook@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Gladkov <gladkov.alexey@gmail.com>, hridya@google.com,
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

On Fri, Jul 2, 2021 at 11:43 AM Kees Cook <keescook@chromium.org> wrote:
>
> Uhm, this is only checked in open(), and never again? Is this safe in
> the face of exec or pid re-use?

Interesting question, but not really all that valid for this particular patch.

Why? Because we already only check for owner permissions on open, and
never again. So if we have fdinfo issues across a suid exec or pid
re-use, they are pre-existing..

But yes, it would probably be a good idea to think about readdir() on
that directory. If somebody reminds me after the merge window is over,
I'll come back to this, but if somebody else wants to think about it
before then, that would be great.

              Linus
