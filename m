Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974DAC43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiGHAfu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiGHAfu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:35:50 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7749D6EE80
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:35:49 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id l190so2918493vsc.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Jul 2022 17:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X1/D+gnFdWPbNjKpWws/C0eoPgJTqvNraTYO7IAqPGE=;
        b=i7pGjgBfgTj/rYovssEsqikRZ8nR0pmb5W5LAR/VmNwDYqIpYVRQ0xsU35J/98hQ99
         NlBfMn+y5np9USK7CEaJpC78jXK1k0jKXDOusAAk+Q0R4lCPSEd9aRNnL6dLylCnj9Ej
         UxXRbIjScFFTPCMH+eUQu51SXl+6wPmyg9SL2Jg20mDwMZt3dCESZ83MyS2CupfcSw7X
         sJoP+BVdD9A8GT/cOu4seFQyuXRkyVtyBDNAD7f+No014J84cLesagufJl5uzrODIJtl
         6J4CZgnFIWvArIOAFiHzFwDRiiju6tQNKqOhIyUxoTy/UiUhzKIAI2bJR2+ZM093gYo6
         CNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X1/D+gnFdWPbNjKpWws/C0eoPgJTqvNraTYO7IAqPGE=;
        b=MnwfH7dEQkkLqug5lYdoScSAkiP2Tkbmo5+hZE8Fja3Rqag5oI6F1ZYsRsHoovtAYL
         xbz1k/KGCBIF0GNlEm9T+p9sU39Z2wzvYprl/UpyOqEcujH/MNGOc0b7aVTJRliHoctR
         YuM5PUfButIjOmIVLtaT9VuyGcgnGEiGbhjWjTJeQEpo68V1gcUgKK4uTmb/91KMdkV5
         /SVaWI5rRo1zz88DxODDc6JGk6VkS2zZyGIVaVKmNOiPXVESs2exka3+at0RUqRWUPV0
         fn+2eKiLjDXhmLEnrDDz8QwWbpMWfwuDUp+kJ+MudxPApqfeG94oSQP9KT1dhBPNi4rg
         2x2A==
X-Gm-Message-State: AJIora9IiNUyEUOY8UgrRVum03DgIfU9u+G9pSOZSXayqQ3Pi9E0JPEH
        D7sKT/QYIvcF8vbhOc7drIorpTG4uusDx1iZgFkU6g==
X-Google-Smtp-Source: AGRyM1t19PwiuOlSW8SMALEeBTVEqMSfvur0ZLf4zzcD0jYgj9mb0OaZMol3I1R9+4QT4/GkLxjRwMlks0kDCbfH7z0=
X-Received: by 2002:a67:b24c:0:b0:356:c997:1cf0 with SMTP id
 s12-20020a67b24c000000b00356c9971cf0mr310001vsh.9.1657240548490; Thu, 07 Jul
 2022 17:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220707200919.90C41C3411E@smtp.kernel.org> <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
 <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
 <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz> <2030965f-5f68-c5ea-80a0-34be503de47f@google.com>
In-Reply-To: <2030965f-5f68-c5ea-80a0-34be503de47f@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 7 Jul 2022 18:35:12 -0600
Message-ID: <CAOUHufZXmSfM78+uLhifozOQacbZX0xM9fjc52Bw5zi+nm8FgQ@mail.gmail.com>
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch added
 to mm-unstable branch
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>, dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 7, 2022 at 6:22 PM Hugh Dickins <hughd@google.com> wrote:
>
> On Fri, 8 Jul 2022, Vlastimil Babka wrote:
> > On 7/8/22 00:09, Yu Zhao wrote:
> > > On Thu, Jul 7, 2022 at 3:58 PM Vlastimil Babka <vbabka@suse.cz> wrote:
> > >>
> > >> On 7/7/22 22:09, Andrew Morton wrote:
> > >> > The patch titled
> > >> >      Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> > >> > has been added to the -mm mm-unstable branch.  Its filename is
> > >> >      mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
> > >> >
> > >> > This patch will shortly appear at
> > >> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
> > >> >
> > >> > This patch will later appear in the mm-unstable branch at
> > >> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > >> >
> > >> > Before you just go and hit "reply", please:
> > >> >    a) Consider who else should be cc'ed
> > >> >    b) Prefer to cc a suitable mailing list as well
> > >> >    c) Ideally: find the original patch on the mailing list and do a
> > >> >       reply-to-all to that, adding suitable additional cc's
> > >> >
> > >> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > >> >
> > >> > The -mm tree is included into linux-next via the mm-everything
> > >> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > >> > and is updated there every 2-3 working days
> > >> >
> > >> > ------------------------------------------------------
> > >> > From: Andrew Morton <akpm@linux-foundation.org>
> > >> > Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> > >> > Date: Thu Jul  7 01:06:35 PM PDT 2022
> > >> >
> > >> > add missing local_unlock_irqrestore() on contention path
> > >>
> > >> Doh, that's true and something to fix, although patch 7 did remove the bug
> > >> later in the same series so that wouldn't explain the lkp report for patch
> > >> 7. The reason lkp test robot complained was AFAICS that it was testing v4,
> > >> as I just replied there.
> > >
> > > Sorry I didn't bother to reply until now: it did test v5, at this
> > > commit, not the whole series.
> >
> > I meant this report that appears to be for v4 (full series including patch 7):
> > https://lore.kernel.org/all/YsFk%2FqU+QtWun04h@xsang-OptiPlex-9020/
> > That reported a bug due to missing unpin that was previously reported for v4
> > and fixed in v5.
> >
> > I'm not aware of a lkp report for v5 (found only Dan's) but yeah, hitting
> > the (similar but not identical) bug fixed by this -fix would indeed be
> > possible in v5 if patch 7 was not applied.
>
> This is all very confusing.
>
> For whatever reason, Mel's 7/7 (and its -fix per Yu Zhao) was not
> included in next-20220706 or next-20220707 (I never tried 0705, and
> 0704 had none of Mel's series, so no problem in this regard; and
> in weeks before that, no time for testing here).
>
> So when I tried testing on 0706, got plenty of rcu_preempt stalls or
> sleeping function called from invalid context (irqs_disabled(): 1) or
> other alternative warnings. And found that applying the missing 7/7
> plus -fix (I've never tried 7/7 without -fix) got rid of all those,
> allowing to move forward and look into other bugs.
>
> But now we have a different fix going in, though I thought Andrew
> said he wanted to move 7/7 to mm-stable tomorrow (despite its not
> even reaching mm-unstable?).  Maybe the Oliver Sang lkp testing (on
> out-of-date version) cast doubt on v5 7/7 and delayed it going in.
>
> This relentless drive towards mm-stable: I for one cannot keep up.
> I'd like to ask for slowing down a bit - my intention had been to
> reach testing maple tree again (it's not yet what I'd call stable),
> but this and a couple of other issues got in the way.  More mails
> to write.

Sorry for not being clear (it doesn't seem confusing to me because I
don't trust the bot):

There were two reports, the first one [1] tested v4 without the fix
[2]; the second one [3] tested v5 at patch 5/7 (not the whole series).

v4 + the fix is good; v5 the whole series is good.

Please do not drop patch 7/7 and do not add this fix.

Thanks.

[1] https://lore.kernel.org/r/YsFk%2FqU+QtWun04h@xsang-OptiPlex-9020/
[2] https://lore.kernel.org/r/20220615160446.be1f75fd256d67e57b27a9fc@linux-foundation.org/
[3] https://lore.kernel.org/r/202207071103.r5a2F97A-lkp@intel.com/
