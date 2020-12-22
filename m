Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0095C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 21:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79AF222AAE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 21:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgLVVot (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 16:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgLVVos (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2020 16:44:48 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5029BC0613D3
        for <mm-commits@vger.kernel.org>; Tue, 22 Dec 2020 13:44:08 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id b26so25866224lff.9
        for <mm-commits@vger.kernel.org>; Tue, 22 Dec 2020 13:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fQOBFvS04B+DEeDrOe6dtVMqdgYNu3ydTTbbpU6XSOc=;
        b=XRUsB9/s7JSsddVyosJ2hW1Xp5vbcsu+kxmh+3bwMzlg/6BiyQLeKGMBGM8TO5gyuW
         sETvQlwkEyK1jgRDq+/Ui2e1YirUXhm+HBTzQ79L7BOIopTWyS4QL3PYDKA2drNyzBG3
         IAhzOXcCQQra6ZkjNx0ne6JEhCCXWs/fGv5pg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQOBFvS04B+DEeDrOe6dtVMqdgYNu3ydTTbbpU6XSOc=;
        b=KYXv40mKB89cvaRiV7+evECE1foaf3TndhLZlgqZ3JY4krV8CLGv9lSOLqE8axvxgP
         1WuKe0XvxRtNw3ihgD5GM6jUIzpxJ23uKf/rG9Nu0NLRVKdDm8foujD3wam2TgasHMjG
         VGhkPY/DUA4b5AdZaycx5QdSsNgFtQWcboy2my/XQJ8kXYSnplBcktsZIge/9xnn6sHi
         VMBuC11IijXvOaeNfFGKbqT8fvKtP2344Yq9AGwJ6CT0YpJ3UVHA28S4Th/+upSbP7jE
         QyEz7MhL/sLH3ws3ARVBlvKdFhTvWT5JPhLwdw9Gbr7EnG/ba+S0kxPg4Y3GUspfzA+1
         teIg==
X-Gm-Message-State: AOAM531ks479lGNCeGHTwX0Q/pSoTuHynE7NJSc1exAvz697K1JfXo7a
        V94ApThdRRFFYA0t21XqxK/KRNROGrsHpA==
X-Google-Smtp-Source: ABdhPJzs04x+1QNIAwUn1J6ZMT8wT/hOQOLxb1ltSgSuJ6cftEQQdUxMt1A0vrJEkNSt7DXCzuJ1Tw==
X-Received: by 2002:ac2:43bb:: with SMTP id t27mr9271027lfl.93.1608673446494;
        Tue, 22 Dec 2020 13:44:06 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id b141sm2818804lfg.123.2020.12.22.13.44.05
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 13:44:05 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id m25so35285359lfc.11
        for <mm-commits@vger.kernel.org>; Tue, 22 Dec 2020 13:44:05 -0800 (PST)
X-Received: by 2002:a2e:8995:: with SMTP id c21mr10187762lji.251.1608673445334;
 Tue, 22 Dec 2020 13:44:05 -0800 (PST)
MIME-Version: 1.0
References: <20201222115844.d30aaef7df6f5b120d3e0c3d@linux-foundation.org>
In-Reply-To: <20201222115844.d30aaef7df6f5b120d3e0c3d@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Dec 2020 13:43:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj37L3_N2N2TjXr0Hdw789=PwMCAeCVDcYoe_fPuZDkDw@mail.gmail.com>
Message-ID: <CAHk-=wj37L3_N2N2TjXr0Hdw789=PwMCAeCVDcYoe_fPuZDkDw@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 22, 2020 at 11:58 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> 60 patches, based on 8653b778e454a7708847aeafe689bce07aeeb94e.

I see that you enabled renaming in the patches. Lovely.

Can you also enable it in the diffstat?

>  74 files changed, 2869 insertions(+), 1553 deletions(-)

With -M in the diffstat, you should have seen

 72 files changed, 2775 insertions(+), 1460 deletions(-)

and if you add "--summary", you'll also see the rename part ofthe file
create/delete summary:

 rename mm/kasan/{tags_report.c => report_sw_tags.c} (78%)

which is often nice to see in addition to the line stats..

           Linus
