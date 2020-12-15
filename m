Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8299C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF6C223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgLOD0D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgLOD0C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Dec 2020 22:26:02 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE41C061793
        for <mm-commits@vger.kernel.org>; Mon, 14 Dec 2020 19:25:21 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id a12so35662223lfl.6
        for <mm-commits@vger.kernel.org>; Mon, 14 Dec 2020 19:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5tNl9aes1ZSZKbogVQvc30qaquCZv6Ce51djzUCV0EM=;
        b=h19V9aGCMsUT+vDGu6Jel6DkqZbENtjzu0/mfELwdcxgI6TjBPMjfjsVBI8MTff2TP
         UFTJ0/XcaT6e0aCcPNzsJgJk4GAp4kIqCiF7NSp3IfKwOQ5qpPrt9i3ViAwN8i8lF9Jj
         ckCRXluciytM3kGJE8Na+cNARbgEbuOF/Ygjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5tNl9aes1ZSZKbogVQvc30qaquCZv6Ce51djzUCV0EM=;
        b=cv9NNdcEtYwlbQNKGF2uhdnHfIIEOdg8gILTG+f7mjUdbqNmr3F4rxg/hq/7slmPRN
         wfMe3o+mnZCsP9kaFUR/fAVeZIJNZ+0f1tUMbB9tyc7wJfMY/FfNPfcVCRrfese3I0Pn
         Fsr8hkFvXhMto3Zrl2BiWCqApwGZDeUntyPpBsjMVnl8Mymoz2hl6yk3ySqtU2fXqfue
         dqY9gCHQGdFQJSKgZ1zDUShKEH0G2REiPjGNPbvfSCLbDrZIlsrnJjtFeTdtDbuzCnqR
         WahGDmjUG1vfRYyIpsRnRnqicYhJbpmRACj4I392OH0LsQ5+JAWFdWD7VOI+X7CByVBT
         p/YA==
X-Gm-Message-State: AOAM531oT3D6L6Qlupf+wutMNkthptqdzgrz9AhXANaGO6viGKEe1imO
        HH08nAbKtVOcJHavn0ULhJByl4Psmdtl1Q==
X-Google-Smtp-Source: ABdhPJxSQMW/gKoLaaZ/n+pvlh7k6oaQqRMv37qF31P3kT9jmrLg49nZyKjSID7BU2MP1IxaFDPrUw==
X-Received: by 2002:ac2:5d31:: with SMTP id i17mr10481797lfb.476.1608002719911;
        Mon, 14 Dec 2020 19:25:19 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id w16sm52076lfq.285.2020.12.14.19.25.18
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 19:25:19 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id o17so32722962lfg.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Dec 2020 19:25:18 -0800 (PST)
X-Received: by 2002:a2e:3211:: with SMTP id y17mr5058126ljy.61.1608002718596;
 Mon, 14 Dec 2020 19:25:18 -0800 (PST)
MIME-Version: 1.0
References: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 14 Dec 2020 19:25:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=whRm2sKHeY-YQqxEJF=d9fGhnU2ajJs9i7CKC4feuPMTA@mail.gmail.com>
Message-ID: <CAHk-=whRm2sKHeY-YQqxEJF=d9fGhnU2ajJs9i7CKC4feuPMTA@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 14, 2020 at 7:02 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> 200 patches, based on 2c85ebc57b3e1817b6ce1a6b703928e113a90442.

I haven't actually processed the patches yet, but I have a question
for Konstantin wrt b4.

All the patches except for _one_ get a nice little green check-mark
next to them when I use 'git am' on this series.

The one that did not was [patch 192/200].

I have no idea why - and it doesn't matter a lot to me, it just stood
out as being different. I'm assuming Andrew has started doing patch
attestation, and that patch failed. But if so, maybe Konstantin wants
to know what went wrong.

Konstantin?

            Linus
