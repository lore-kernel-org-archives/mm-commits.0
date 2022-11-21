Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88248C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 17:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiKURZ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 12:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiKURZ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 12:25:26 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023B32AC9
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 09:25:26 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id d7so8482205qkk.3
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 09:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9HcjKMfGyc5vWKHCdEvgUimexbmYdSMFMtRjkFYCy0c=;
        b=GQDmb2Ri3pJ3sCVS4xlEAzwqNq/2UGdmffhKYItWI0RuGiFmCKNdzOth0F1ymdbJYu
         AwK9qB28imcSlEgJE2A08m4t8OeLFTBdW2mqINamJuOHzKnf0l44c8YwDJYdjaHWe60h
         zTkaPIHlilDrBk1QWyAfPiSBnXP8Y31xu9MIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9HcjKMfGyc5vWKHCdEvgUimexbmYdSMFMtRjkFYCy0c=;
        b=2gWsmcF97ajrLldRi6VrJpruZkllmyNazDcWXjqGdwDTR+Va05MZI7soYLl3TTOh1C
         opUXLH9rFBTSf0SFk0/v+zvxVEBwfI2m4O638StGRt6+8Li3CO7AP9g2XPjiRIdZEvFZ
         69qhxC/6RX2RlsEdsd28UxRj5l7qB+7feIEvC5ZNYTk8knv8Op1kCNScCQXe8fT4UsFH
         ZZIKMpz+w3QujAYYVFRyvN7a+k09S2mLt6gQPEQlDbTIyUqjg7xQfYjFpd26eeAKdKWz
         EnpdYlySllUgJbepvaNe03ppQh2crpqnI6ok14T1Q35ld8uwxdK8UUYU/2EGL9yvLmpC
         0jaQ==
X-Gm-Message-State: ANoB5plvXCkP3KOgd+0dA2dBF+4R0vEcEdq0WWBud6HIcZcJSw+pLBR0
        QPsxs+imeRwAdcDyjMB0Nr1vctW+sUGlTA==
X-Google-Smtp-Source: AA0mqf6ffuIaxnAMr1+g5xd5O4CFqox9xUOV2wDQSINHp11EJoo4ZuyS0jtp8sreLCCP5kmc199rJw==
X-Received: by 2002:a05:620a:491a:b0:6eb:70db:b2e5 with SMTP id ed26-20020a05620a491a00b006eb70dbb2e5mr15305945qkb.445.1669051524773;
        Mon, 21 Nov 2022 09:25:24 -0800 (PST)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com. [209.85.219.41])
        by smtp.gmail.com with ESMTPSA id y18-20020ac87092000000b0039a08c0a594sm6861460qto.82.2022.11.21.09.25.23
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 09:25:23 -0800 (PST)
Received: by mail-qv1-f41.google.com with SMTP id s18so6843032qvo.9
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 09:25:23 -0800 (PST)
X-Received: by 2002:a0c:efd0:0:b0:4bb:a80f:3f43 with SMTP id
 a16-20020a0cefd0000000b004bba80f3f43mr989395qvt.43.1669051523306; Mon, 21 Nov
 2022 09:25:23 -0800 (PST)
MIME-Version: 1.0
References: <20221111231502.1238DC433C1@smtp.kernel.org> <CAG_fn=WeE=_jP0sQ8Hvwr4chdZupZp-cJd0v268Pdo1n1ROpug@mail.gmail.com>
In-Reply-To: <CAG_fn=WeE=_jP0sQ8Hvwr4chdZupZp-cJd0v268Pdo1n1ROpug@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Nov 2022 09:25:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjkQb7s1+WknAW03R3RCKNQK78S=SYXj3GU6b2RUe--xQ@mail.gmail.com>
Message-ID: <CAHk-=wjkQb7s1+WknAW03R3RCKNQK78S=SYXj3GU6b2RUe--xQ@mail.gmail.com>
Subject: Re: + revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch added to
 mm-hotfixes-unstable branch
To:     Alexander Potapenko <glider@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        elver@google.com, ebiggers@google.com, dvyukov@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Nov 21, 2022 at 1:38 AM Alexander Potapenko <glider@google.com> wrote:
>
> @Linus as a heads-up, this revert is still missing in 6.1
> It's not strictly required for the release, but, as noted on the other
> thread, the original patch is not needed anymore, so reverting it will
> make mmu_gather less ugly.

Yes, but as Andrew picked it up, I'll just get it for 6.2 when he
sends me his pull requests.

The revert cleans code up, and gets rid of an ugly thing I happened to
notice while just working on that code anyway, but I don't consider it
in any way critical just because I happened to note it and complain
about it.

So I'm perfectly happy just in the knowledge that it will go away, and
don't feel any need to hurry it along.

Thanks,
               Linus
