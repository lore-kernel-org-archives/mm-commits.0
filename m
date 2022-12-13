Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F277C00145
	for <mm-commits@archiver.kernel.org>; Tue, 13 Dec 2022 02:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiLMCoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Dec 2022 21:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLMCoi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2022 21:44:38 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2E2B19
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 18:44:36 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id a16so10794935qtw.10
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 18:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6YrtMVCi4WDvYhEXVLWW1FmmQIRQNnrvyDRxLnMe8wQ=;
        b=H/Kb8jbkK7O8EOgPL9u/zI0bjx5Hpf6Uk8N1TtUotbskhhTLnlwg4lGSWh7Gm1LSUo
         Mll6BV5akO1BfpJ0t4fKjqv83cxZlVhoewqJq6SnQPOV3xGmcaK4RByoy4GbcvFMfbLm
         FxNvN6099PglUOF12in1KnbZdjfRFAP9EJCIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6YrtMVCi4WDvYhEXVLWW1FmmQIRQNnrvyDRxLnMe8wQ=;
        b=1d+8emfpUQteI+qOEG4OnXxsMXUzuqntZQXijn6nJg8jXy+LewguSVrdhi9AiIrZmK
         MYdxxsL24sN52MS1EwrsS75dEd0jdgMfFVENwR2qEpGNkyKyXLAdMb+3TS3OHvMOol3E
         LtomNP46fxofB8BL2rPpEH522/vRRD7PntOSF4W3FYHKxOzB0btyn+uqysXY1g0ebOT2
         9PE8vjIDZ7lqxdDLadeXQtaPWjGQeQAxKhACmT1czaRb9vA3U2mRprN5uGCJ/4Ts02au
         RIoyDWNtciDSOeeTRMfC9k6osisj4wdKD9L/JysvwLOJj8bebcIvkdLHEDPiiBo8PEr9
         wIgg==
X-Gm-Message-State: ANoB5pkJpoJGHQjbO66nFZtfUyH83ut1BEsm1EDRAFmRKKZ1ukTP+xa2
        ECpI9TBHxp3PIVOXlU/StMVgjv5woSdiy0hG
X-Google-Smtp-Source: AA0mqf555YEc4MVTvQYw7DFRgbrQRfG29nxnNrXFK5E2PPC1/0krKMIVh5t95flwIIwjf0pGl+/DqA==
X-Received: by 2002:a05:622a:90f:b0:3a6:2170:b0a1 with SMTP id bx15-20020a05622a090f00b003a62170b0a1mr29276392qtb.6.1670899475152;
        Mon, 12 Dec 2022 18:44:35 -0800 (PST)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com. [209.85.160.177])
        by smtp.gmail.com with ESMTPSA id fp39-20020a05622a50a700b003a7e38055c9sm6683384qtb.63.2022.12.12.18.44.34
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 18:44:34 -0800 (PST)
Received: by mail-qt1-f177.google.com with SMTP id jr11so10188749qtb.7
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 18:44:34 -0800 (PST)
X-Received: by 2002:ac8:4992:0:b0:3a7:648d:23d4 with SMTP id
 f18-20020ac84992000000b003a7648d23d4mr18731340qtq.180.1670899474206; Mon, 12
 Dec 2022 18:44:34 -0800 (PST)
MIME-Version: 1.0
References: <20221212134425.b20b80955e5e8a4a36ce1b9a@linux-foundation.org>
 <Y5eoS/UfBhovR70j@zx2c4.com> <20221212142754.5f699c4ff515fd9d42768fb2@linux-foundation.org>
 <e7c6b99a-743f-f40a-0b0f-31730964cb36@suse.cz> <20221212183554.e0a2536e860172282b189ca4@linux-foundation.org>
In-Reply-To: <20221212183554.e0a2536e860172282b189ca4@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Dec 2022 18:44:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjaO_S-kMb1n00suvnTBQS=mY2tH-YG9Tti_5pxnn_tzQ@mail.gmail.com>
Message-ID: <CAHk-=wjaO_S-kMb1n00suvnTBQS=mY2tH-YG9Tti_5pxnn_tzQ@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM commits for 6.2-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 12, 2022 at 6:35 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Well here's a hacky thing - just look for duplicated patch titles after
> stripping away the hashes.

Please don't do that.

Just use the git machinery that Vlastimil pointed at.

"git cherry" uses the actual patch ID (which is just a hash of the
patch with whitespace removed), so it actually looks at the patch
itself, not just eh first line of the commit message.

If you insist on writing your own shell script for this, please use
that same "patch-id" logic. That's made available by "git patch-id".

But do "man git-cherry" and "man git-patch-id" before you do any of that.

And in no situation should you go "the first line of the commit
message is identical, so the patches must be the same".

                     Linus
