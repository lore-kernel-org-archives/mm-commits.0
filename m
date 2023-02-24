Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F01C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 01:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBXBeK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 20:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjBXBeJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 20:34:09 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5534A3773C
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 17:33:58 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id ck15so50436574edb.0
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 17:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ymzGFsmWya6beQpPK0i2hFaBLxyxKs7ybs+4Ujx9o08=;
        b=NsTxMu91loRThYoVGXFnM1XQ6n7iZETYV2DEh33EWoE15bp7NJWrtEXVpY0Rgsg7Sp
         LnJ2qOiHjWOr23v7VHuhjP9/UNu+4HIaRK604xjFVXvMp6MZw3aDF9OlbfLeAoPOzaxW
         03/jDGV57fRr3MShW//nWjDkbPz7ix5RXbCaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymzGFsmWya6beQpPK0i2hFaBLxyxKs7ybs+4Ujx9o08=;
        b=J/Kf/K5TLF1kOMbIK9EhrH1p81MoKqvdkJrUB/iFKcQ1Sxz+Xa05340/3O8nAqQjzi
         SzTsLKDmMZHBgNzZpxWkfAvu8mKcXL4yJPEwPm8/nM1nl2K6tS6nqr0sI6wYiWUBuWl9
         FVOQ0dThc7qFgycb6HhtP9PhA3sBqU72d17a+bhOwm5BHLF5ulzF4P6aHnXxDaERifkL
         Rmfvf+141kDLjwekIHAYsxIhLh+Kr0TU1NZLd7FHZ+FHWim5D2avH7QUmnUwxAuXxzrF
         YDfxa1FRa6JD7useWDOEpZTkzyHyvGPfuUOZO8B6OjYCKZgPZvYxQlRO8s9eKH3O2t0x
         ZaDA==
X-Gm-Message-State: AO0yUKUjbItQ5o4Hvuz1ORzpyIxTbJPeLopjEFLvxudPmgRwNmJ2EhhY
        Xgz5Fxg1ub1Joz8unqrkxQjQX4MU40ujRDmP2dupiA==
X-Google-Smtp-Source: AK7set/knLCTolOxQlqZFPVUzndDqVTcRIAL3yBnlTvqSL34koNG79MHbYzmqLhsaPK6Uz2q0kMOQg==
X-Received: by 2002:aa7:c74e:0:b0:4ad:7ad3:de18 with SMTP id c14-20020aa7c74e000000b004ad7ad3de18mr14694459eds.28.1677202436540;
        Thu, 23 Feb 2023 17:33:56 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id m17-20020a50c191000000b004af6a840f21sm1653943edf.15.2023.02.23.17.33.54
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 17:33:55 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id i34so23856328eda.7
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 17:33:54 -0800 (PST)
X-Received: by 2002:a17:906:40cc:b0:877:747d:4a82 with SMTP id
 a12-20020a17090640cc00b00877747d4a82mr10458388ejk.0.1677202434537; Thu, 23
 Feb 2023 17:33:54 -0800 (PST)
MIME-Version: 1.0
References: <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
In-Reply-To: <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 23 Feb 2023 17:33:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
Message-ID: <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.3-rc1
To:     Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Vishal Moola <vishal.moola@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Matthew Wilcox <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Feb 20, 2023 at 1:52 PM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> Linus, please merge this cycle's MM updates.

Ok, finally got around to this one, and I am not thrilled about it.

A few notes:

 - my fs/udf/inode.c is "minimal". Ugly, ugly, I think
udf_adinicb_writepage() should just be made to actually deal with
folios inherently, but I did *NOT* do that, and just did

        struct page *page =3D &folio->page;

   at the top, and left it at that. I'm not proud of it, but I hope
Jan might want to do this properly.

   That conflict wasn't mentioned, and now I wonder if the UDF changes
were in -next at all?

 - the fs/cifs/file.c conflict was a nightmare.

   Yes, I saw David Howells resolution suggestion. I think that one
was buggy. It would wait for a page under writeback, and then go on to
the *next* one without writing it back. I don't thin kthat was right.

   That said, I'm not at all convinced my version is right either. I
can't test it, and that means I probably messed up. It looked sane to
me when I did it, and it builds cleanly, but I honestly doubt myself.

   I think that code should probably use xas_for_each_marked(), but
instead I kept the old model, added a loop like DavidH did, and then
munged the end result until I thought it was palatable.

   NOTE! Don't even try to look at the conflict diff. It makes no
sense at all. But somebody (I'd hope all of DavidH, SteveF and Willy)
should really take a look at my end result.

 - gcc 12.2.1 quite reasonable complains about some of the new MM code:

    mm/migrate.c: In function =E2=80=98__migrate_folio_extract=E2=80=99:
    mm/migrate.c:1050:20: note: randstruct: casting between randomized
structure pointer types (ssa): =E2=80=98struct anon_vma=E2=80=99 and =E2=80=
=98struct
address_space=E2=80=99

     1050 |         *anon_vmap =3D (void *)dst->mapping;
          |         ~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~

   and while this doesn't cause a build failure ("note" is different
from "warning"), I do think something needs to be done. Gcc is right.
This code seems to *work* simply because it's intentionally
mis-casting pointers, but I think it needs to be seriously looked at
and something done to make gcc happy (and a *LARGE* comment about it).

That last note is not some merge result, it's purely about the new MM code.

Anyway, the merge is done and pushed out, I just am not very confident
about the end result at all. That cifs thing really needs somebody
competent looking at it.

I think I went through three different iterations of my resolution
before I was happy with my approach, and "happy" may end up being more
about having exhausted my will to live, than about the end result
actually being any good.

I saw some noise about ext4 being a nightmare too, but I haven't
gotten that pull request yet.

I'll tackle the non-MM pull next, but I'm taking a break first.
Alcohol may have to be involved.

               Linus
