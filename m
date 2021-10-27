Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BDCC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 05:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66EED6103B
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 05:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbhJ0FkL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 01:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239564AbhJ0FkL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Oct 2021 01:40:11 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DC5C061570
        for <mm-commits@vger.kernel.org>; Tue, 26 Oct 2021 22:37:46 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r28so1909373pga.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Oct 2021 22:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=RX2GNYu8TK9twAN2Lh7LQrNQzOMDZSFdqrZtavC3pao=;
        b=leOdfHqFIEYjc7RcksxJzZPM4hRhMivChxi9yOh3eXPEJc/bDA1l9+o8zPHANtztYt
         oEMbAmLb4+JsCzfOqThTsImq5Lm1qHv6FxKj5oOfrOHfBOWbT2QQHZrU3Bn/RgncBDEG
         FegV7Lhsrf16F+bCPKmqFziVb/nAcj0OkKhuiglOTVdjGxDNsZO/hHZmm0UqYhgnG09x
         ks14/pOF6c4ERBxS4GQ/96Lv5hjZYkpaWCoSO7NCKCq19/TBhp4j2QJ/p1EB5HZQviwl
         qc2GOK5Tc5ADJE7oILD5B8TRk0gC2Ii99K2siTq+S0pE2s9k+0TEmuK1H/O2H29/62vg
         qRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=RX2GNYu8TK9twAN2Lh7LQrNQzOMDZSFdqrZtavC3pao=;
        b=ttcGZBN/RPlSSXJrTCkcov0oN9xZy4tD1kyhfQp0vYb1ZCyRyr6GMKIUPvZjlK1JOf
         gJcmYUf7cvBriBXaOGP06TOLkj7wcMkxgzkgf58bHUOh6tfSHeCMLbFJ9TvolviwWm8Z
         2ZghYnxiD8nSw6Ojvy0sINtxNarPq+V8kFI9tA2QjefYukfcUnvwUwEzes9vVPTbrNhP
         tvh/x6Yzgk7KSKx/E8GxRkAaiV19suJdJR2qiSpuJ6UFO6RTqjJPjpQ2lBGxPCN858T/
         IUNtrAGnkb75I9IG/jrknN68koHdZ/fZEhIjNXNP8AnTZOO6Ru1jfIb4yr5u/43olnZp
         p9+A==
X-Gm-Message-State: AOAM532lALyeXljvJNZkk3LleTsLZmkppL8ny/k0T9laqED166gGw7Kt
        rB2DxcuGYjCKvm0yYZXxct9PfOwv40PuUHrcZS7kDrHy/us=
X-Google-Smtp-Source: ABdhPJwtkehYKxSAauZXgAX9mmJZbcUmXNaVkDiadjgldkZm18VdoW2uL2cuTMZOhmvRQXSZGXh6J/menfzP6ub4Euw=
X-Received: by 2002:a05:6a00:851:b0:47c:288c:88f7 with SMTP id
 q17-20020a056a00085100b0047c288c88f7mr3114322pfk.29.1635313065942; Tue, 26
 Oct 2021 22:37:45 -0700 (PDT)
MIME-Version: 1.0
From:   yunhua li <yunhual@gmail.com>
Date:   Tue, 26 Oct 2021 22:37:35 -0700
Message-ID: <CAMqbrUgDCpwXTV871R-13VHgKg5RiTuogSpFGM=cyfowwFCnhg@mail.gmail.com>
Subject: Does shrink_page_list also drop Readonly page?
To:     mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

1. I don=E2=80=99t have  swap partition
2. My application use lots of memory, and use mlockall to locked lots
of physical page.

I guess when the free pages get really low, kernel doesn=E2=80=99t have oth=
er
option, as lots of pages are locked(mallocall) and dirty.
The only option is to drop some read only data,  as I cat
/proc/$PID/smaps, I found Some .so file. Rss is much. smaller than the
actual size, and sometimes my application got unexpected ReadIO and
latency. I guess that's because the code segment dropped, then it
needed to be read back.

7f9bf0faa000-7f9bf11a9000 ---p 00037000 103:01 51781261
  /usr/lib/x86_64-linux-gnu/libxxx.so
23784 Size:                            2044 kB
23785 KernelPageSize:         4 kB
23786 MMUPageSize:           4 kB
23787 Rss:                             0 kB
23788 Pss:                             0 kB

My question is: which code will drop the readonly page? For dirty page
I can find it in mm/vmscan.c shrink_page_list -> pageout

https://elixir.bootlin.com/linux/latest/source/mm/vmscan.c#L1553

As pageout function call guards by
if (PageDirty(page)) {
   =E2=80=A6
   pageout(page, mapping);
}

Can anyone tell me where the code is located to drop the read only
pages?  Such as the elf/.so code segment. Thanks.

Regards
Yunhua
