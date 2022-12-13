Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3829AC00145
	for <mm-commits@archiver.kernel.org>; Tue, 13 Dec 2022 01:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiLMBch (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Dec 2022 20:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbiLMBcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2022 20:32:36 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624191CFDC
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 17:32:34 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id jr11so10073881qtb.7
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 17:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2eqfa1XIBCm6hdVVCJy7q3CDQSZOeuXGCdncD/RyVHQ=;
        b=BVvVXFKCWlL+28CaWZrxozLYkVmJ7nKRWx1pTdi6ral8n0X7EZK+/eVNXCRP69319e
         912y6oIwz7nUqvyF7b1a5tlXNicP19OGma5unRKw8ipxgdwIOCSH0YGUwBmzBd6HX4uK
         Fq3WjMBgGwTlPn43iJwELDMI+ecMotnu7X528=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2eqfa1XIBCm6hdVVCJy7q3CDQSZOeuXGCdncD/RyVHQ=;
        b=bud56YJMDn6jnVvQjNNzN+8OpFzyGT5mRwJvtaJYv5Xt3LE/ouI2A8qEu9e7EcxbMX
         eSRYRVHZyYA9gKpAKX4Z9KP4DttKE/dmQppuov32SvPUjKrVYfVDg7D5FcXQHPdf7S2G
         7SoizV+UdQj0A9leinhBZAIa6kiou/0yKJ0gZBiv9c7M84DX8gfjhcEpKCFkJ365sESL
         +BDEGda1qfHzvaAKKQ8ajBUWNJM02y2e2Hdwxjmi4OIcfPFTzNYoo/KVcAc0wxGLSXGK
         OImTSEaeGuyZ8Ml5WXwB8wIV7AIs6/X44STvJ6L9p2PJEhWnqKEOfsuDKMP7f7TVLHK2
         7JoA==
X-Gm-Message-State: ANoB5pk57B0xF49rKAglFNatX/HhsJkXFW3pnvzIz0/d1qE0rTEkAPqW
        JOn6UifIFaX/sh5QCSBeDSrdd78F4tPMxIAG
X-Google-Smtp-Source: AA0mqf4VqT4ZZzHpA9/xjTJtXOSlNM3CRu6KxRpIxPJJyyyXNULaKi9nxcvombKT9qeB8SmmyPy+Dw==
X-Received: by 2002:ac8:6f09:0:b0:3a8:1f82:5b66 with SMTP id bs9-20020ac86f09000000b003a81f825b66mr2715889qtb.18.1670895153169;
        Mon, 12 Dec 2022 17:32:33 -0800 (PST)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com. [209.85.160.170])
        by smtp.gmail.com with ESMTPSA id u10-20020a05620a430a00b006fa31bf2f3dsm6935190qko.47.2022.12.12.17.32.32
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 17:32:32 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id g7so10701965qts.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 17:32:32 -0800 (PST)
X-Received: by 2002:ac8:4988:0:b0:3a7:ef7b:6aa5 with SMTP id
 f8-20020ac84988000000b003a7ef7b6aa5mr7544619qtq.436.1670895151958; Mon, 12
 Dec 2022 17:32:31 -0800 (PST)
MIME-Version: 1.0
References: <20221212134425.b20b80955e5e8a4a36ce1b9a@linux-foundation.org>
In-Reply-To: <20221212134425.b20b80955e5e8a4a36ce1b9a@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Dec 2022 17:32:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=whD2ouXCgWK27x7KQt7pQ2Xckzr9Gkkzqs3ZcPH_A2g-A@mail.gmail.com>
Message-ID: <CAHk-=whD2ouXCgWK27x7KQt7pQ2Xckzr9Gkkzqs3ZcPH_A2g-A@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM commits for 6.2-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 12, 2022 at 1:44 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - A series from Yang Yingliang to address rapido memory leaks

"rapido memory leaks"?

[ Goes off to look at the commits ]

Ahh. Typo.

           Linus
