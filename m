Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA25EC7EE22
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 16:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjD1QR6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Apr 2023 12:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346092AbjD1QR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Apr 2023 12:17:57 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E54C103
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:17:56 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-555d2b43a23so623867b3.2
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682698676; x=1685290676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFyJc8+p4qTuozgH/v/B+1NflQRfcLItZsoQOpNrm4I=;
        b=KI6WifT1huW26vIMkQLL3klATIcHmUITIOLhmKPoBSZAVdw5odSR4lQ7QfzgVL2Sa6
         sxnbscyqWPfKsK5XMqqlJdblwIl5wfDje0FeISy/ie3hUuH/dOexjxVSWRpGN9JqF3ro
         4MNwZVuy+59IWxX+ch7zlDRFoY5BgvXTavJOX3+x6Q2lRog2uL/q8EdKNYf72eBox+po
         Yh9BW0u3jMdlKf+GNY7aANIEwQZjscT85ORaOaSIMcTXGg5DbC/ZyKzTsNmSEIN6smK5
         tE1ZbfxSG9NQLg//0mv3u6163fclJcSgt3Eu+FIu8sPSd4S0OUqnIGw17uK6AGVUPWQK
         SVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682698676; x=1685290676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFyJc8+p4qTuozgH/v/B+1NflQRfcLItZsoQOpNrm4I=;
        b=OLgQ2mdEmi9C4rYQKQF3xVRabDsE/uKjJ+227gu3P/g3dMesXAUubf6irhQCSjF7xA
         SQu8MzYOAWiu+ye2FLmk1HN9dNbD8ADMrNP/Qscs9pfIiR/bcYGRAXAiQ8btcbQazwuZ
         8YAwbj0EIi4FhiCJmhph0OaNPjmzCCWm0mDW9N3RFzz/qB10Awzyqkq9RueLy+TASjXi
         knZcQI2PQ9jusIEH9Qr1Mw9w2HivEt06qviNPvlsfjaAhV005sQCOAFQgBur6tfdc+l7
         /Vzar4qTpMZhAb73zxwyUvM+pVEyCfn2GeNbdIogaBIF2frOBiW2c7L4ACJzlfxH2KKt
         zyJg==
X-Gm-Message-State: AC+VfDyWVZ9GKpiMEDjBwMgbg4b+LCSHdxAMfEF1C1XFJTRCdeueE5Ak
        XeINr9Ig5vGlBf2F1A9MAR3Vx+2u1ZF31Vq0J7nrNw==
X-Google-Smtp-Source: ACHHUZ7nYMiGVX+Zyd6HKF12DlZ5nRD3X367dMTMrVNC7OnmWNX9lMIAFe2WO1BbxF00t0ps+U4NpYzDWgoMKA/4Uhs=
X-Received: by 2002:a81:4ed3:0:b0:540:c99d:efc1 with SMTP id
 c202-20020a814ed3000000b00540c99defc1mr3296966ywb.35.1682698675470; Fri, 28
 Apr 2023 09:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
 <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com>
 <CAJuCfpHZSEjG2nti5iWbPQjWgXcHZ95hFS2FKwaPC-sZPdSznw@mail.gmail.com>
 <CAHk-=wg0SyFDp_sdcEH-D+LNxuzL_dWA1vZEowUN16n_+yRHPQ@mail.gmail.com> <CAJuCfpHouhrEtomhPe2sf+p0oG4pGFKb3xidhOXP6BN-PydY-Q@mail.gmail.com>
In-Reply-To: <CAJuCfpHouhrEtomhPe2sf+p0oG4pGFKb3xidhOXP6BN-PydY-Q@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Fri, 28 Apr 2023 09:17:44 -0700
Message-ID: <CAJuCfpGcnJiJyU78v1r548W3bZ2LyfaYpr5huKKG8-WaiRHFHA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 28, 2023 at 9:14=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Fri, Apr 28, 2023 at 9:08=E2=80=AFAM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Fri, Apr 28, 2023 at 9:03=E2=80=AFAM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > I wanted these stats enabled by default to be able to identify
> > > possible pathological cases and to also let users disable them if the=
y
> > > can't tolerate even a small overhead in the pagefault path. Should I
> > > document this reasoning for the config option?
> >
> > You should document what the stats actually count (at a high enough
> > level for a user to understand), and why anybody would want to keep
> > them on.
> >
> > Honestly, 99% of the time, these are things that *developers* think
> > they might want, but that nobody else will ever ever use.
> >
> > Really, ask yourself if a normal user would ever look at them?
> >
> > Now, ask yourself whether this might be something that a cloud
> > provider would want to look at to gather statistics.
> >
> > And if it's the latter case, then it should be "default n", because
> > the default should be for the people who DO NOT KNOW, AND DO NOT CARE.
> >
> > The cloud provider will be using a custom config anyway. The default
> > is irrelevant for that use. The use that *matters* is literally the
> > clueless end user who I bet will never look at these numbers, and will
> > never be asked for them.
>
> Ok, sounds like this should be 'default n'. I'll prepare a patch. Thanks!

Should I send a replacement patch for "mm: introduce per-VMA lock
statistics" or a followup patch fixing it?

>
> >
> >                Linus
