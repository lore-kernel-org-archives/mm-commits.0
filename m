Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9A9C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 18:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDC9761037
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 18:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhKFS50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 14:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhKFS5Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 Nov 2021 14:57:25 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A81C061570
        for <mm-commits@vger.kernel.org>; Sat,  6 Nov 2021 11:54:43 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id f3so25860514lfu.12
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 11:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A59YQbzIblHJkgrF7HqniOzVCuZVUMj6hZDKIN6sEg8=;
        b=fPpm85NuUvrjulBXZGaHaStOGOakZrFSW5gSOjBqNFxSM4Y8dbId53ND+i3E/OwxCi
         R3/zPDCKg6SadtBKvaMrA3hf0+khymvggmO7VKi8YQx7wEpjfQP35Xpo4y094vzzyEoT
         H7yPW8Fc7wycUmAiS8wGq18hoTw+TQq3yjwjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A59YQbzIblHJkgrF7HqniOzVCuZVUMj6hZDKIN6sEg8=;
        b=If4hXny1nyDYJ+paYKVM4ClhDtQDXgjj7xl/jmj2QSzBCrgEcpWVr4BAEasZS02nJs
         xURaRXYMDopJ8nUQxy5MCOymW19/QS/yrFwlze7BFGmf+8nD6gEe+PiKmBxtSuRuMf15
         fAi7aGnHMO9l0IfIMEoJyvx5ieUpNb41+ViTBbKRMIv2EbkKZ3pHxFuz3KUp+qVxkkhj
         NEoT3DW34r9d4bfFkuQZLL0hgS6kkhfGsModa+ks1rUdiCLn/ZhnIP4X9Di4hudnCfFF
         4R0aczv60jDnJtlZLamYRTXMlXSLBpKK+KhvTqoRuMKea5iwp26XEKVWd6oFHIdfEIn+
         qkqA==
X-Gm-Message-State: AOAM530Suw/vvvU8pz0JFDJmqndAT/1jJKDJC6hV4zbTT7/WEGrPXiPR
        IqQKDVN60ktVxrYHQQTQIAS8FcveJdugz/Iw
X-Google-Smtp-Source: ABdhPJwLRt/ppMKhTBPS06NRubOv27GRp9PwWHNWiwpJceMN/4dRVR3J1yRqFbJkxquvGEOfeyds5g==
X-Received: by 2002:a05:6512:1087:: with SMTP id j7mr64807633lfg.488.1636224881707;
        Sat, 06 Nov 2021 11:54:41 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id d9sm1234045lfs.108.2021.11.06.11.54.40
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 11:54:40 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id j2so25998254lfg.3
        for <mm-commits@vger.kernel.org>; Sat, 06 Nov 2021 11:54:40 -0700 (PDT)
X-Received: by 2002:ac2:57d3:: with SMTP id k19mr13824566lfo.150.1636224880295;
 Sat, 06 Nov 2021 11:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211105203821.mV5HWKCGr%akpm@linux-foundation.org> <2F9ABC3C-1B24-4A0B-9F4D-C1EA225F26E4@vmware.com>
In-Reply-To: <2F9ABC3C-1B24-4A0B-9F4D-C1EA225F26E4@vmware.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 6 Nov 2021 11:54:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whLWnsmLTuAkdYWWk_LHD-2X47ScWULNS9=QkK50SN-_Q@mail.gmail.com>
Message-ID: <CAHk-=whLWnsmLTuAkdYWWk_LHD-2X47ScWULNS9=QkK50SN-_Q@mail.gmail.com>
Subject: Re: [patch 071/262] mm/memory.c: use correct VMA flags when freeing page-tables
To:     Nadav Amit <namit@vmware.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux-MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        Nick Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Nov 5, 2021 at 1:57 PM Nadav Amit <namit@vmware.com> wrote:
>
> Hugh correctly indicated that I made a silly bug, and this patch is not
> healping.
>
> Nothing would explode, but I assumed the patch would be dropped for me
> to submit v2.
>
> I=E2=80=99ll send a fix to this fix instead unless it is dropped.

I've dropped it.

                Linus
