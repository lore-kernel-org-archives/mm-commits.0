Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892BBC4332F
	for <mm-commits@archiver.kernel.org>; Sun, 11 Dec 2022 01:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiLKBP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Dec 2022 20:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKBP1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 10 Dec 2022 20:15:27 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F9B13CE9
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 17:15:27 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id c15so6488413qtw.8
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 17:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q8wxfaikdFYvVtdWG+RjLvFSxS3wMPNKgsWLeD6RevA=;
        b=PnRfvDH2GYJEcZVZ7MuoIVohSMSURlQA5ojSh/eZy9+le5NfiH7p47dDLE+nTmTif3
         A3A3nWJAkwjNYD1MedUAGzaA0jICqz4q+LZslug0aUKQj+spGveC6L6B+nfCrZie5sJM
         yCsPek51vqZssxsmyJaSiQW4mkRjcmJyi8vP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q8wxfaikdFYvVtdWG+RjLvFSxS3wMPNKgsWLeD6RevA=;
        b=nEtP5GkX0L1U+agOD9XSJikZ7yr0PIolLHFU5bSY09cNmJuzmJaUbrmuXHcLAzZS5F
         Il7AHbOBKhvfO1+/xcdC0xa2j7jz8JPRDkKLO2Kf5JMgAN5OLadANGNytaz72ehcTnmm
         +MLpr/RZw+8ONQVcCKqxx/GfowLAVR7opRs1J+jXa2MN86D0Kc0VOMeGrejQPgkGIpfG
         ZzEA3/LNa1ATVgI3sSF6Bwv/g+HVy1eANvIgagVRXFiJOY8nXTYcBdFcspGWY4gPxJrS
         NYDBUlJRqUUY8X//UlkdUPKI+W4BMjS0AYTy5F0oNBtqZ1Sn4X2PA4aJirlEp1d5Uh7j
         v4pA==
X-Gm-Message-State: ANoB5pnWHWIJ+FPGBzZs/7RzOpaNYsdZ+JgCOkmbu+456dHiFvooEzye
        sT99xruB0j8TLjhX/7SJM0JFuS5b6ryoaT6c
X-Google-Smtp-Source: AA0mqf6OKjxMIe+1BD5OguX5DvBsAJM3bTQRRQpp4+7Er0j8vhKLQEAUTabYp6IxocCugRLwl+fd0g==
X-Received: by 2002:ac8:4996:0:b0:3a8:1299:6d3c with SMTP id f22-20020ac84996000000b003a812996d3cmr649607qtq.51.1670721325731;
        Sat, 10 Dec 2022 17:15:25 -0800 (PST)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com. [209.85.160.170])
        by smtp.gmail.com with ESMTPSA id dm20-20020a05620a1d5400b006fca1691425sm3012766qkb.63.2022.12.10.17.15.25
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 17:15:25 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id jr11so5879455qtb.7
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 17:15:25 -0800 (PST)
X-Received: by 2002:ac8:688:0:b0:3a5:122:fb79 with SMTP id f8-20020ac80688000000b003a50122fb79mr76107362qth.452.1670721324812;
 Sat, 10 Dec 2022 17:15:24 -0800 (PST)
MIME-Version: 1.0
References: <20221210170317.130e7dbfc0e78de6067c4012@linux-foundation.org>
In-Reply-To: <20221210170317.130e7dbfc0e78de6067c4012@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 10 Dec 2022 17:15:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgrapQ=pf0Btr9_0bso99E5Mq6FgANKLbN0mkdohfB4qQ@mail.gmail.com>
Message-ID: <CAHk-=wgrapQ=pf0Btr9_0bso99E5Mq6FgANKLbN0mkdohfB4qQ@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.1 final
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Dec 10, 2022 at 5:03 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Tejun Heo (1):
>       memcg: fix possible use-after-free in memcg_write_event_control()

Heh. Apparently your scripts to notice that some patch already made it
upstream didn't notice that I took this one directly already when it
was posted, so now it's duplicated.

Not a big deal.

           Linus
