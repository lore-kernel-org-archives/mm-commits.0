Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F83C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jan 2022 16:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243960AbiARQeW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jan 2022 11:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243977AbiARQeU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jan 2022 11:34:20 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F16C061574
        for <mm-commits@vger.kernel.org>; Tue, 18 Jan 2022 08:34:19 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 23so3513085ybf.7
        for <mm-commits@vger.kernel.org>; Tue, 18 Jan 2022 08:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cFLJZnNfVA2hCXwB0s6ZjiPuvxnZUePWAooBTPU852M=;
        b=G5erIZGbvmegUtG5C0zxO4yXCWE4gtDIbjk3ToPHrs+DaC2xKf7n/9Rij7MZA7wqyW
         DkGv6kljPu7+YqY8zLxf5FUc9+It3uU5r2ctlM5ZhKw21mPd2XcPP4EngAJXVY2YGVx9
         kuA7xwKFhP+L/HduNMi335CM2fipZBVcGMcvwA/fzAnl5srEPtmseEpLI+hf6KicC55c
         iESC+oJUiVUcJC55eSHcJvaY7B1T9YwPMp/VTMFydv8nRyfOjMC5C3/UIa60aqR9CyDE
         BPnxBRf+Wj9OzVVgHDhNw3VQfz7D/aygtcHplEvdZuTnzugy4/vceEn4oCFf/mKLvP0n
         aMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFLJZnNfVA2hCXwB0s6ZjiPuvxnZUePWAooBTPU852M=;
        b=3C412z6BZP8o12ZKMTRDUJUi89R447w//eybgLKaUAAzF5NsyrwiXLc/diXP4U6Lkj
         bHxUmQuEWnJBOvyjqopI3rhEpelHW808LnKEzGhjH+yFwiF83w2YGA65Txsjz/MGK8lT
         A6gOthR7F4KhZJsV9dzD9DCvOS2c7kU0OF5OeXE1HQ8aQ+XkipHXrsy+43Qqfil+YSNk
         5Yg5wWwgj6AT4UgNLpYqNwjdm7VAwwt+/Do6I4DnpFvMYD8MZlA9z/DlbcPAMa0LUJFN
         vHzx1Cj70aeJhA+QHctMRxx9h4RC1fBpDDNv6yZTfm3d+4bGmfhHmGbtmwh2p7fWWEkq
         cKrA==
X-Gm-Message-State: AOAM530G0mSf++SGf+OeFwmSp+JSe5ab4NRu2xjJDRBZzC3LhdAY+hbY
        0zXdPYj94pEtVAFHXM028WWzRZE25jdAHyU6dki5LQ==
X-Google-Smtp-Source: ABdhPJzIWXCdR/TtXqi3JjuZe2JymY69Sm90gPsH4SEWVht4RaZfi/F9gSRFFK1+L6+w1N12qFQMrcIMl9PaDOrq3Zg=
X-Received: by 2002:a25:3791:: with SMTP id e139mr1806490yba.488.1642523658728;
 Tue, 18 Jan 2022 08:34:18 -0800 (PST)
MIME-Version: 1.0
References: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
 <20220114220555.kAbhSEmus%akpm@linux-foundation.org> <CAHk-=wgH6jmhs=wtv8eEWcfw1NVvxwdt2h6fMKhRf75fiTW1Hw@mail.gmail.com>
In-Reply-To: <CAHk-=wgH6jmhs=wtv8eEWcfw1NVvxwdt2h6fMKhRf75fiTW1Hw@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 18 Jan 2022 08:34:08 -0800
Message-ID: <CAJuCfpETS++d_TW9HNw5mZUvxpizwX3Ho5F5qOAgzf3RvoF31Q@mail.gmail.com>
Subject: Re: [patch 056/146] mm: rearrange madvise code to allow for reuse
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Colin Cross <ccross@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>,
        Jan Glauber <jan.glauber@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, mm-commits@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Rob Landley <rob@landley.net>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Shaohua Li <shli@fusionio.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Jan 15, 2022 at 6:16 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Jan 15, 2022 at 12:06 AM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > Speed up fork() by up to 40% by refcounting the anon vma name field.
>
> What?
>
> No.
>
> This doesn't speed up anything at all.
>
> The refcounting of the anon-vma name field avoids a 40% regression
> that comes from adding the field in the first place, but this commit
> message makes it sound like this series is speeding up fork() by 40%.
>
> I don't mind the series, but I absolutely mind these kinds of horribly
> misleading commit messages.
>
> This is literally the first commit in the series - and the series in
> no way improves performance by 40% in the end, it just first makes it
> worse, and then fixes the regression.
>
> I can speed up any function by a thousand percent - if I'm just
> allowed to make it horribly slow first, and only count the final
> speedup win when I remove the overhead of the garbage I added.

Thanks for fixing it! I see in your tree it is changed to:
"Avoid performance regression of the new anon vma name field refcounting it."
Please let me know if anything else is left to be done here.

>
>                Linus
