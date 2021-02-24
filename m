Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327C0C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 21:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC11A64F0E
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 21:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBXVb5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbhBXVbz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2021 16:31:55 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC5EC061574
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 13:31:15 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id a17so4160929ljq.2
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 13:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CPUhh85QWrRGDc94MuGO68k+1Yg6s4gZIfhTzW+e1FU=;
        b=g4MpYTdaSQ+WdoHOz52Xbaoi9pQGteaqql+kuqaagEriziHGQqdiGooZjuZStRGCJl
         rGiXn9KAQftIOBRyIamBZBp+jiDNwXKQ3pGJXnOLw7WwmlJ4n3FmibswNpf7R7CMJl+K
         5G/g9YW7bxwFg2vQtVBMlNpzBKOJEG1qN8Djk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CPUhh85QWrRGDc94MuGO68k+1Yg6s4gZIfhTzW+e1FU=;
        b=n7HyA5NknaCCCUKyFFVHY/Zyjguy6m7o8I9OOPjwK0wxzP55F0WMcnkfMXKENtPmYp
         qKvIBD74Ya2bFvn/dgzE3Fe5BThD/zzGSFa6TMVeDmYp6w+VjWfU2QTU7yGJjjvZgAf2
         1onpuj/0cc7ATmZPELqo2zr7X/+/FWpdZ9RWqTDd1kE2Ep5H0k6LreWA4GTDtR3QnDZp
         L5KOM3bSrgaXGwGWaMGkmrKSp3oX3uGGosm+KP2Pj/pkIyuuNdkix7DHWqUIv0N3lOSn
         HCMEQMUVO5hG4d4u6OQ3p1eSe6e5tuEOQGCk8y3r/TVLAJhkznGbsSpSWx8OdekD3xLJ
         da2g==
X-Gm-Message-State: AOAM531nw5qc8qr8R1n4X8IAy2FiCqwyOeCChKy6LT0ZGMPxneld9arY
        dZnI0ZfVqZX0QQ8Ro+T5SPMg+F4/XPMXUQ==
X-Google-Smtp-Source: ABdhPJwfBBuzuX1UQTm6LcUKnUrpvcs9NNDWMxVWEaSe06EfCSUuAl2wJCkTunj6nuL26Ly56m8YIQ==
X-Received: by 2002:a2e:90c4:: with SMTP id o4mr4394982ljg.293.1614202273918;
        Wed, 24 Feb 2021 13:31:13 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id q14sm721453lfu.196.2021.02.24.13.31.13
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 13:31:13 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id m11so3280578lji.10
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 13:31:13 -0800 (PST)
X-Received: by 2002:a2e:9659:: with SMTP id z25mr1050573ljh.411.1614202272907;
 Wed, 24 Feb 2021 13:31:12 -0800 (PST)
MIME-Version: 1.0
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 24 Feb 2021 13:30:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiO1=xV1_gOsiWS9TuFJ_RQ0_HuXLg-qVAMnNj2TvHk2g@mail.gmail.com>
Message-ID: <CAHk-=wiO1=xV1_gOsiWS9TuFJ_RQ0_HuXLg-qVAMnNj2TvHk2g@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 24, 2021 at 11:58 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> A few small subsystems and some of MM.

Hmm. I haven't bisected things yet, but I suspect it's something with
the KASAN patches. With this all applied, I get:

  lib/crypto/curve25519-hacl64.c: In function =E2=80=98ladder_cmult.constpr=
op=E2=80=99:
  lib/crypto/curve25519-hacl64.c:601:1: warning: the frame size of
2288 bytes is larger than 2048 bytes [-Wframe-larger-than=3D]

and

  lib/bitfield_kunit.c: In function =E2=80=98test_bitfields_constants=E2=80=
=99:
  lib/bitfield_kunit.c:93:1: warning: the frame size of 11200 bytes is
larger than 2048 bytes [-Wframe-larger-than=3D]

which is obviously not really acceptable. A 11kB stack frame _will_
cause issues.

              Linus
