Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BC8C83F17
	for <mm-commits@archiver.kernel.org>; Tue, 29 Aug 2023 21:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjH2VcV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Aug 2023 17:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238883AbjH2VcD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Aug 2023 17:32:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034A1CC9
        for <mm-commits@vger.kernel.org>; Tue, 29 Aug 2023 14:31:58 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-52a40cf952dso6460571a12.2
        for <mm-commits@vger.kernel.org>; Tue, 29 Aug 2023 14:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693344716; x=1693949516; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rU7dErnvLiuzDuD68u3YsP6+F+SRgavTnqk7toHPtos=;
        b=Y4OjGEi76WfnyBMZ6fLyZ/IGF9DnKPQoavAfHo8Cz2W8NEK7iZnqTF5dkomTaOH+Hn
         S8EZv+OlEYcyNRDzsRFfvL9QDG2AnvxYjXgr9F+pp7GdEpsxWVqWcoGXTB3MOhgtp+aQ
         pNxuwd+4H8VdhVHjFHh3cnLYXA2Bt0LeZ2Mv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693344716; x=1693949516;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rU7dErnvLiuzDuD68u3YsP6+F+SRgavTnqk7toHPtos=;
        b=M5hIo8PMyPtJe2b1rjvOg6rZGZ3E5T99X1k+/7BfsP96cWXbvvQywzoIeN75SUwB10
         n5PYEsA50NJ4A2/2HQG8ySV+F8VytGjSqQJDaMY5mq0lI6Zjxf+IvIm/XX4GzhlR7GtG
         brEqUDmZv2GsOeNRZVzE6Jj4/ohebb8P+lF1ukQigtjo8kbEGm2H0oTYkxDKQQiTuP3h
         z6ShA8Rl0EtGbafAZz3lRAF72qunlqfoO2K4wIqnxneOelbIsIni1P2T/7kdB4x/CenD
         JGJDsZunwpsUdL6n29WtCrxhIo4BDvj9NACVCp8w8nVo7HErNsjRKCJL5nrJMdGunqZu
         Cr7A==
X-Gm-Message-State: AOJu0Yzl/PAZKFqU08E7F+p5c51i0yCQyaRmqfNbL4MEqm0w62Gi8PXb
        WhD4Pn1U0lSKQHARDoW1iZnVa1btwBWClIT/c3f+x2oO
X-Google-Smtp-Source: AGHT+IGc6myYxXhV5u9Q3KAwFQsrbYgX1lK0JOYHq22bQf4ax3rsHqWkWKiztoNJAr/IObi250X9LQ==
X-Received: by 2002:a17:907:2723:b0:9a1:d67c:b4f3 with SMTP id d3-20020a170907272300b009a1d67cb4f3mr133239ejl.77.1693344716477;
        Tue, 29 Aug 2023 14:31:56 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id pg23-20020a170907205700b0098e34446464sm6462479ejb.25.2023.08.29.14.31.55
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 14:31:56 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-99c136ee106so637579366b.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Aug 2023 14:31:55 -0700 (PDT)
X-Received: by 2002:a17:906:9bfa:b0:9a1:d2ef:3e3b with SMTP id
 de58-20020a1709069bfa00b009a1d2ef3e3bmr158630ejc.38.1693344715187; Tue, 29
 Aug 2023 14:31:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230828184251.bfbc164280503903eacf498c@linux-foundation.org>
In-Reply-To: <20230828184251.bfbc164280503903eacf498c@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Aug 2023 14:31:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjtBk23T4bsA4wxyogvDAP0mWmPPvy=qaMWsySM=WOC9A@mail.gmail.com>
Message-ID: <CAHk-=wjtBk23T4bsA4wxyogvDAP0mWmPPvy=qaMWsySM=WOC9A@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.6-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Guo Ren <guoren@kernel.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 28 Aug 2023 at 18:43, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> csky tree, arch/csky/abiv2/cacheflush.c:
> https://lkml.kernel.org/r/20230815104604.54f65293@canb.auug.org.au

At least this resolution in linux-next was wrong. It would just keep
on doing a cache invalidate on the same one-page address range over
and over again.

I think I did it right, but obviously can't test (and am too lazy to
build-test too).

Of course, it won't actually matter unless you have large folio on
csky, which is probably hard to impossible to trigger in practice, but
I thought I'd mention it if for no other reason than Guo Ren to be
aware and at least test-build and maybe think about it.

             Linus
