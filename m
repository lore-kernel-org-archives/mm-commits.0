Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E12E9272B
	for <mm-commits@archiver.kernel.org>; Thu,  5 Oct 2023 19:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjJETXz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Oct 2023 15:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjJETXy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Oct 2023 15:23:54 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC55F98
        for <mm-commits@vger.kernel.org>; Thu,  5 Oct 2023 12:23:53 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-419b53acc11so71131cf.0
        for <mm-commits@vger.kernel.org>; Thu, 05 Oct 2023 12:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696533833; x=1697138633; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qWKRDwpuxB9DAZZ14qs4a81cJZdQ0wwSz0x4Sc08wY=;
        b=hCtAa4PozVw4v8pP1oPEtiirLOKJ442F+89XrsZvqgfs0QK5wGrunXZuZFbD51/h0w
         sfVowW2EG7e4PSuFBCnXlfSUAx0gfeXPQ2bRfzbGEVucYHCuJKmcqmy4GNWuCUEOcKia
         Zev/Zg9A5pRUAdo+TeQHUjHYOUXeTg1tqQd1MW18bMJMBSP8pE24f2NfZx0oO4TqJZfU
         +rlWzPvLd6EwA6dnqUt8gOEAg0D4SyFJwKF7C1jvC5dLqxrVxLluDA+Ajcu9BN+B5j3p
         L9rGIyCtz0lwdbpCLm+IttudEtq2JVvgynMZgSeXmemMIK2OD0nB9ET8r6//7Jmn50/k
         HgVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696533833; x=1697138633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7qWKRDwpuxB9DAZZ14qs4a81cJZdQ0wwSz0x4Sc08wY=;
        b=XMu0PkNDoH5pSjnQs35+yBoD2KI9glLupsRorONAz7gHSy/jza6PaiaoTn3o6pOjbG
         yQxwtxKAUV7x8Lz/bldw3bfRs0IPAIrRNPPr0LeR8PnyT4YhRJMldt2zBiataraLCAPJ
         VofWiW43TNU5zlD/r4ie7cAKRHxlThdy88KVyQQNX3GSIpCtIETQwY4GJh7d5zrdMcxN
         RIGgX8O+l9Smhh2xxr6a/jMzYEhEHEw/k2eWbW7/BumOsGIhi2MoYx1jPO/ZnCcZGB6G
         iU4FwlHEYe468dG+MXYfCAsEpFNkgHwJbyGCmSdorHk9PlzLix9VQZHdte5nLanf3A2D
         qv7Q==
X-Gm-Message-State: AOJu0Yyd+G9x1d5q8iv9DJiZMHT+xPfU6m4CLmBjonebkFe7WopT/CUH
        1k/AFngmlp7uvUk+gFo7yi+/0tOiBh/HECsKaHzDZQ==
X-Google-Smtp-Source: AGHT+IGPUJG7b5JurfieCZE7FQ9LcO1TiL6mjCLZMvkC2sqlZlCitjarkLvSToCuqIiam9uWeMOYGWnC+96WMO9t+PA=
X-Received: by 2002:ac8:5a0f:0:b0:412:9cd:473b with SMTP id
 n15-20020ac85a0f000000b0041209cd473bmr214930qta.4.1696533832661; Thu, 05 Oct
 2023 12:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230929190832.CBFFBC433C7@smtp.kernel.org> <63426190-5865-970f-773f-cce33a8209d1@redhat.com>
In-Reply-To: <63426190-5865-970f-773f-cce33a8209d1@redhat.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 5 Oct 2023 13:23:15 -0600
Message-ID: <CAOUHufabXCBdrybKUzYVvHQExocj=XiNT8mYDxejt18vhMYr_A@mail.gmail.com>
Subject: Re: + mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
 added to mm-unstable branch
To:     David Hildenbrand <david@redhat.com>, ryan.roberts@arm.com,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 5, 2023 at 2:12=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 29.09.23 21:08, Andrew Morton wrote:
> >
> > The patch titled
> >       Subject: mm: non-pmd-mappable, large folios for folio_add_new_ano=
n_rmap()
> > has been added to the -mm mm-unstable branch.  Its filename is
> >       mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patc=
h
> >
>
> Andrew, please don't move these patches to stable before we have a
> couple of acks from people involved in the discussions.
>
> I'm confident that we'll get them into 6.8.

I am not :)

As I repeated, the priorities seem wrong to me. There are many pending
work items that don't involve any ABI changes, and IMO, we should
focus on them before we even start discussing ABI changes.

I've been quiet  because I don't think opinion based discussions are
essential to nailing down ABIs. As I suggested, I prefer a Kconfig
option as the first step so that people can play with it. After we
have collected field data, then we'd be better at coming up with
suitable ABIs.
