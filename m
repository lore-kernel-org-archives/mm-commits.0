Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3536FC6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 03:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBZD1m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 22:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBZD1l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 22:27:41 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E2E113F4
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 19:27:40 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o15so10192549edr.13
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 19:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4LG6eymnVogwOKViXhHE1/PB/p0T/rjRJiCGRuQ7pc=;
        b=hje52BCvFJGjhtqKJ28w+Gj04eqoFbgZ1+idWrtOfIghYvxWYZ4to7CPGzRKBbY41x
         fQdBfHwAmsf+Q+7Y1Q9Hp/GUGQrmU1xP5TeFJROES/xtfL4CSl0VoBXEVxtgd2MrpbpH
         9JfrUd5O0jmbzLgN3zd022AYlbGZzc6X3UuAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4LG6eymnVogwOKViXhHE1/PB/p0T/rjRJiCGRuQ7pc=;
        b=3+/FuFyYzdmdknYMK2t4NMbaUz1o7A0h10cLhP13NE2HJg9FTbUmU9vIdOYDYTr2z1
         lUvwK0jRocZUfnKLVSTqyLiaTQldZigIxeZifiR7czpJNLHFgMzMi5DYWnRVFjmAc3ND
         0DPWPOIk7feKFLp/i8AMSpoVKHCPK1GKnDxEB53WpFE59zyPyu9T45eqGTDWnfjsFvYO
         Z5xDkgZ7W674MlQw8ukjY07V5goUG8UBOMeDh8+f8D47wHpcOj1kEvPsCM9JMxvgtnoH
         TIROyZcOItidmygIJ2Ed8DffC5Dlc6GeqkZaC2qRC472B3VzfdNT+3Ew64PU78xjkp5l
         infg==
X-Gm-Message-State: AO0yUKXSLP0sr9knUllRtaLg+KA4RMp0kuFR5Tb3w9uB+RJxE2VFHDVt
        L7u+sUrOoMbjmK0UJnG/nleQ/qN91OBjGnyVAtuufg==
X-Google-Smtp-Source: AK7set8JQvMhzRcUhvSrBhm9L9ewM8InRDarj4ysBlq2CePkHLtMtvnclnLnZd2r420rJKCmeovBlg==
X-Received: by 2002:a17:907:33cc:b0:895:58be:94a with SMTP id zk12-20020a17090733cc00b0089558be094amr30672902ejb.14.1677382058463;
        Sat, 25 Feb 2023 19:27:38 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id l24-20020a170906939800b008cf1b61a73esm1488119ejx.41.2023.02.25.19.27.37
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 19:27:37 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id ee7so12772999edb.2
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 19:27:37 -0800 (PST)
X-Received: by 2002:a17:906:1707:b0:8f1:4c6a:e72 with SMTP id
 c7-20020a170906170700b008f14c6a0e72mr4103996eje.0.1677382057309; Sat, 25 Feb
 2023 19:27:37 -0800 (PST)
MIME-Version: 1.0
References: <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org> <CAHk-=whVN2gKO_7UvMqgG8cetrVs3BCTxQovJvhC5x7AcJDJgQ@mail.gmail.com>
In-Reply-To: <CAHk-=whVN2gKO_7UvMqgG8cetrVs3BCTxQovJvhC5x7AcJDJgQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Feb 2023 19:27:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgxWDgLJ-e3uDiYQvmMEqTNYFvDxtHbu4inR=zgBEP11Q@mail.gmail.com>
Message-ID: <CAHk-=wgxWDgLJ-e3uDiYQvmMEqTNYFvDxtHbu4inR=zgBEP11Q@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.3-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Feb 25, 2023 at 6:43=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm. Just a note to let you know that I'm bisecting google-chrome
> dumping core, and it seems to be due to something in this pull.
>
> I've got a couple of hundred commits to go, so let's see what it
> bisects to, but right now all the bad state came from this pull,
> afaik.
>
> Maybe it's a false alarm, but it seems to be consistent so far.
>
> Will update when I've bisected closer.

It's solidly in the "change XYZ to use vma iterator" chunk now.

Commit 0378c0a0e9e4 ("mm/mmap: remove preallocation from
do_mas_align_munmap()") is good, and commit 37598f5a9d8b ("mlock:
convert mlock to vma iterator") is bad.

Will bisect further, but adding Liam to the participants because it's
now narrowed down to his changes.

               Linus
