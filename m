Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E99C001DE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 17:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjHJRhM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjHJRhL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 13:37:11 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D300EA
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:37:11 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-407db3e9669so28601cf.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691689030; x=1692293830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vclYB2SvR87/E5uOrWe00kcCLqnlByW7M8hC1eVTbW0=;
        b=nshTDbKwPKGcgiKnavW8RHccpCMGOwq/5HSIvWVNxER6RwRidjzdDXC1/m/jTXh3LN
         0TOGvKORsr35JNHzUfmbkviuhZAvc07LqJRPSmTJEe4DdIs+T5JsOkobIcTbooQqkCb8
         WPD8bHdrQ2HKocl9+ZHO9p0HsH8Ka8Ip6X0WB2jY4TZNeWw/iNcr8YEAp3HvkrlYHHO3
         g1tKD0cKA7dp0qLVJlWRC3y8ebVVZhz526X9cVzPIKS0jqZ+ACpaH0yLSlGih+p9SdbD
         b2OlMVLwpFltJvEIeJKOx/vaIHFqWrI+5G6nbZ2bhx4IbALkwr0V4+lUxcQH9REeR1hR
         xwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691689030; x=1692293830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vclYB2SvR87/E5uOrWe00kcCLqnlByW7M8hC1eVTbW0=;
        b=bXHt/7UYie6gx0Z1XFQDF9sGD1ZdY0kucRHuhmAN7OXU5V5PP3qbPt68un9CELjD5J
         CLi/xDlU8+dk1cOYPb+Qbyn7rPPTjO5eo1nlrdQ3z+iVYeDfpfscQVTRSRNPEcqF4lG+
         6ViHeS0bHyh2K8/CW47dVk7nxcAB5fu1mOgudvFuqshv3VVKFLRRHO45AKE3BZLhhqVf
         D/O5HzWHBvv4VqYUH9A5fpIeMxMZijXfFue41HzbHSfqKl0vZS01tlukopQEbAzLlzDt
         4awkCYR/TtDyTgTzIXK/m7OWi8rvG0ycO0VmBo4LxOSxH9JNhkdsVr70nCyDrrDFRgvF
         HEfw==
X-Gm-Message-State: AOJu0Yxq0hp3xy9RuyouEaa12zeMw6OrL5MxjfZKDeJ96mDMIY96Xjvz
        k4sWkLsawXxT2+t3b+NWK/x0nwcQyKP2nVkDa0u3tg==
X-Google-Smtp-Source: AGHT+IGJhtzZYEFstRlio+c3Q9yR14RPtlIV+665a9Jtm2O9wus66Q2nLJejFs989TgGbGbuSOa4120Lgti4DGOvwV0=
X-Received: by 2002:ac8:5acc:0:b0:407:4aa8:c5ba with SMTP id
 d12-20020ac85acc000000b004074aa8c5bamr26879qtd.14.1691689030259; Thu, 10 Aug
 2023 10:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230810163130.E3D10C433C8@smtp.kernel.org> <279ce23c-8331-2b7c-86d3-b318f2c157af@redhat.com>
 <20230810102545.6a135af6009f436601c1c199@linux-foundation.org>
In-Reply-To: <20230810102545.6a135af6009f436601c1c199@linux-foundation.org>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 10 Aug 2023 11:36:34 -0600
Message-ID: <CAOUHufbuMAaonfpm0K=sg7qhEA2vzaoeNxKqqHcjtheircGnfw@mail.gmail.com>
Subject: Re: + mm-large_anon_folio-for-improved-performance.patch added to
 mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, mm-commits@vger.kernel.org,
        ziy@nvidia.com, ying.huang@intel.com, willy@infradead.org,
        shy828301@gmail.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, itaru.kitayama@gmail.com,
        fengwei.yin@intel.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Aug 10, 2023 at 11:25=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Thu, 10 Aug 2023 18:42:42 +0200 David Hildenbrand <david@redhat.com> w=
rote:
>
> > On 10.08.23 18:31, Andrew Morton wrote:
> > >
> > > The patch titled
> > >       Subject: mm: LARGE_ANON_FOLIO for improved performance
> > > has been added to the -mm mm-unstable branch.  Its filename is
> > >       mm-large_anon_folio-for-improved-performance.patch
> > >
> >
> > It's good to give these patches some early testing in -next.
> >
> > But let's wait for more review and acks before we pull this into mm-sta=
ble.
> >
>
> OK, I thought the dust had adequately settled on this series.
>
> I'll await the next version ;)

Thanks. Close but not yet :)
