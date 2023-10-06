Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D590E81E0B
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 15:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjJFPYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 11:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjJFPYn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 11:24:43 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53EB83
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 08:24:41 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-4195fe5cf73so278181cf.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Oct 2023 08:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696605881; x=1697210681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yav04U1N5TjoLBlrkgzBfcAnyIgT5aCMx3ukhswJtNQ=;
        b=ahewnaAgmNOzp3lLhunIz4pJrZLyHuh5Z5h8fy72rpFFrPXoPr/F/P4g1h128T51SV
         ej3UTfYcF/VdFlTmx/hqu3h3EZbA9lJMa2iBYN5qe+hiejjJvQ9c+ooQuYKbqx8CC2Ws
         XlC+w+8DUaf2tCtYwvHWRFOZdpM0DO3KfEfQ0uMZtDAfSRqLv+Z5yaV+saMM8c8uQj43
         5JZj5gl/7ziyAE0s4XK8ekD+Rh+4Quqdee/ksgKk7TRTa/bMsG/w6K4lVHSaeZ/Va+9K
         4MlRJrVOhdC1cnrJHUqqqWCLgPaqXiZiEdwVtSAartYEWc246StfU+r8AIPn3pvLXcm9
         0eyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696605881; x=1697210681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yav04U1N5TjoLBlrkgzBfcAnyIgT5aCMx3ukhswJtNQ=;
        b=kDZpm2rQxZVGVCuOmw/hMDB0IwyCmzB1CevUqmnb1YWj2ZxjxT7yhFGoUMy9xv4AAr
         MvADx4YN06L3fFzFTc0XQPqoIuN5soOny0GgGVf6t24kaXnKS9Glm6oRWeSz/mhWWvga
         gg4J5zZJ/urernGbrsgDrk/3oqfh/go1LxkP1FlVU8XyDW3295HRerzwJeLeOTH5lEiI
         tsfr2eAVyh3r2m1+DcnjICYMFIFCPKCr2f/quT9AvwSVc94K/lYTNFtIK2+afe6G0nRu
         dINlQwthUp6q4VJD6olQAgqsFoocwvUg3KP53uX7Nk99HKEezAX9/2iCoYIiFzjcQY9A
         fqMg==
X-Gm-Message-State: AOJu0Yzb9pfCXRM6RKxipo8ETLxv+OOBNXSWJlC28hF11y3G7pt27ox7
        Of4lKGoW0k20xQBBWpxD7hJbnCYrEzvI7z5SP30KdQ==
X-Google-Smtp-Source: AGHT+IGKbLgGVMZvyi6I8plAn6cIaSQ4UWa727JCuPk/scqecGRFUYyqTUko6G6BpgNZbA+bGT+GP+X+FBIJ5OI3Ljs=
X-Received: by 2002:a05:622a:104d:b0:410:88dc:21b with SMTP id
 f13-20020a05622a104d00b0041088dc021bmr494956qte.26.1696605880728; Fri, 06 Oct
 2023 08:24:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230929190832.CBFFBC433C7@smtp.kernel.org> <63426190-5865-970f-773f-cce33a8209d1@redhat.com>
 <CAOUHufabXCBdrybKUzYVvHQExocj=XiNT8mYDxejt18vhMYr_A@mail.gmail.com> <137d2fc4-de8b-4dda-a51d-31ce6b29a3d0@arm.com>
In-Reply-To: <137d2fc4-de8b-4dda-a51d-31ce6b29a3d0@arm.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Fri, 6 Oct 2023 09:24:02 -0600
Message-ID: <CAOUHufYEKx5_zxRJkeqrmnStFjR+pVQdpZ40ATSTaxLA_iRPGw@mail.gmail.com>
Subject: Re: + mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
 added to mm-unstable branch
To:     Ryan Roberts <ryan.roberts@arm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
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

On Fri, Oct 6, 2023 at 2:53=E2=80=AFAM Ryan Roberts <ryan.roberts@arm.com> =
wrote:
>
> On 05/10/2023 20:23, Yu Zhao wrote:
> > On Thu, Oct 5, 2023 at 2:12=E2=80=AFAM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 29.09.23 21:08, Andrew Morton wrote:
> >>>
> >>> The patch titled
> >>>       Subject: mm: non-pmd-mappable, large folios for folio_add_new_a=
non_rmap()
> >>> has been added to the -mm mm-unstable branch.  Its filename is
> >>>       mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.pa=
tch
> >>>
> >>
> >> Andrew, please don't move these patches to stable before we have a
> >> couple of acks from people involved in the discussions.
> >>
> >> I'm confident that we'll get them into 6.8.
> >
> > I am not :)
>
> I don't find that comment particularly helpful; Are you implying a NAK? I=
f so,
> some rationale and actionable suggestions would help.

From my POV, there have been some random changes between each version
of your patchset:
1. v3 *introduced* a boot parameter `flexthp_unhinted_max`, which
   *disappeared* in later versions.
2. v4 *introduced* a random constant ANON_FOLIO_MAX_ORDER_UNHINTED,
   which *disappeared* in v6.
3. v5 is really close to what I think can be merged -- my only
   objection is to ANON_FOLIO_MAX_ORDER_UNHINTED, I've never heard
   *a good reason* why that random constant should sit in core mm.
4. v6 *introduced* a sysfs ABI -- we had a couple of alignment meetings
   about how it might look but there was *never a consensus*.

FWICT, you haven't made up your mind. So I'm not convinced this series
is close to being ready to introduce an ABI. This is NOT a NAK, just a
ton of concerns with your current approach.

And I'm not sure how I could be more clear on how we can move forward
progress [1][2][3]. Some suggestions would also help.

[1] v3 https://lore.kernel.org/linux-mm/CAOUHufaDfJwF_-zb6zV5COG-KaaGcSyrNm=
baEzaWz2UjcGGgHQ@mail.gmail.com/
[2] v4 https://lore.kernel.org/linux-mm/CAOUHufackQzy+yXOzaej+G6DNYK-k9GAUH=
AK6Vq79BFHr7KwAQ@mail.gmail.com/
[3] v5 https://lore.kernel.org/linux-mm/CAOUHufbUGwc2XvZOBmTCzMsOHxP-eLB60E=
dysKYzrkRMScOyMg@mail.gmail.com/
