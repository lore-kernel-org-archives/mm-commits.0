Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA082C678DB
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 22:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCDWfW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Mar 2023 17:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDWfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Mar 2023 17:35:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFD612063
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 14:35:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f13so24109435edz.6
        for <mm-commits@vger.kernel.org>; Sat, 04 Mar 2023 14:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1677969318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjLU05mpbmIrZ5UOJsg0FItkE1EtBF9bZysOGBrLVhQ=;
        b=Y6wD5A6CQnmMTLgQdcGKSUoePY7qOwARkvWy2V77lvrUHkJN9BB/+tofM45h5yiddG
         cpiW5r05bjqOE35GSPOwhMSrkBSY/Ed9P0hYO3GeN/QMBB2wm3354o69R+zOXBlrIb+7
         odxgV+ICXHIi7jvjH00v6RiQxKmxSG+tv/yvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677969318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VjLU05mpbmIrZ5UOJsg0FItkE1EtBF9bZysOGBrLVhQ=;
        b=SMoAZOD0ZlvISZ0LUY9i/Gq+sC572Vs0pBC/hDxyPRRmSRJIxEp1fn5/YyWYT3CI0m
         nRy05D3CCHAshjiqPIdTUClJ1aGA6vgwV8IVQOgRcLCa8r7d0ZIDedVGhddS4rhj75cy
         IeLs/gIhdR60g5OXydpLhueuqQ4/TA96/xDF+uWsDhv6UkQqarQd4E1EVgps9WwgZkh5
         JpOoOxBrS2LJrN8rAiwThbPqgs5Pu/HuKZsK9xk37pc3ZPTwscqRetxSVUa0UXF/zw5h
         dRiVmm7ZOKiIQ1cG8X+fkfGhCKuynlpQguerjy9E0SIQpONEsfC8G9oSYPeb5zmMPa+M
         lV7w==
X-Gm-Message-State: AO0yUKWCqGPllQhpXlBr1DxvZFrwEevGqKpdFxOHU15mPfl+ICxyr9CO
        9X/jRhyxNyJxEOnXHkOGJ+383eSmfk8wnaH7QZpfjw==
X-Google-Smtp-Source: AK7set8ioT+ds9YR+HVtQ6MLmXolSKaUYo6YvvCMQa6yKEY+Bw+MuorKdqWTkH+hI5Mp5atPdHcwkA==
X-Received: by 2002:a17:907:5cb:b0:8b1:3a23:8ec7 with SMTP id wg11-20020a17090705cb00b008b13a238ec7mr8109133ejb.43.1677969318126;
        Sat, 04 Mar 2023 14:35:18 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id ga2-20020a170906b84200b00882f9130eafsm2494561ejb.26.2023.03.04.14.35.17
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 14:35:17 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id a25so24365286edb.0
        for <mm-commits@vger.kernel.org>; Sat, 04 Mar 2023 14:35:17 -0800 (PST)
X-Received: by 2002:a50:cd94:0:b0:4c2:1a44:642e with SMTP id
 p20-20020a50cd94000000b004c21a44642emr3476060edi.5.1677969317070; Sat, 04 Mar
 2023 14:35:17 -0800 (PST)
MIME-Version: 1.0
References: <20230304131528.4645d19a2ab897fb7518159e@linux-foundation.org>
In-Reply-To: <20230304131528.4645d19a2ab897fb7518159e@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 4 Mar 2023 14:35:00 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9guryjifHyr26w73ta+kNeoHtGde682Z5N6OSjKu4UQ@mail.gmail.com>
Message-ID: <CAHk-=wj9guryjifHyr26w73ta+kNeoHtGde682Z5N6OSjKu4UQ@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.3-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Mar 4, 2023 at 1:15=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> 17 hotfixes.  Eight are for MM and seven are for other parts of the
> kernel.  Seven are cc:stable and eight address post-6.3 issues or were
> judged unsuitable for -stable backporting.

Hmm. Since this pull didn't fix the gcc note about playing pointer
games that I get for my allmodconfig test build, and since I _really_
don't want to have an rc1 release tomorrow with that (valid) warning,
I fixed it up myself.

I fixed up the gcc note the cleanest way I could, by using a union to
make it very explicit that yes, we're basically doing a bit-for-bit
assignment from one incompatible type to another.

I would *not* encourage this pattern in general, but it had a comment
about why that invalid pointer conversion was fine in this case, and
it really does seem to be a fairly natural use of a union. This
situation really is that kind of "don't convert types, just copy the
bit representation".

So it's kind of conceptually quite similar to the traditional "use a
union to convert floating point bit representations to integers" and
back (as opposed to using a cast to convert a pointer in order to then
_use_ it as a pointer in the new form).

See

    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3De77d587a2c04e82c6a0dffa4a32c874a4029385d

for details.

At least gcc generated identical code (well, for an unholy version of
that patch that had been edited to avoid line number changes) for me,
so that "go through a union type" doesn't cause any other differences
than getting rid of the gcc note.

(And this was definitely one of the cases where I felt that the gcc
note was entirely valid, and a good warning - even if it wasn't
technically a warnign that would cause -Werror to trigger. So I didn't
want to shut up the note by turning it off, I really wanted the code
to be more clear about what it does).

             Linus
