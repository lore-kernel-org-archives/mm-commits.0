Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5757C6FA8F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Aug 2023 22:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbjH2WVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Aug 2023 18:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239035AbjH2WVA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Aug 2023 18:21:00 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40D81AE
        for <mm-commits@vger.kernel.org>; Tue, 29 Aug 2023 15:20:56 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-997c4107d62so636275066b.0
        for <mm-commits@vger.kernel.org>; Tue, 29 Aug 2023 15:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693347655; x=1693952455; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HBGxhGVE/O9KafVESYT+LOweSNa/w8MY2IicYyYz9S4=;
        b=Unc0se7ruQg74CBzq0y8JF71x/zDRCuWc/gUiKc2TP5QW741lBf5x09S6Au7QR3VtO
         qkw6E/qoqU0fi/j1FkQAtYmvveUKJ6xOI65Q7SfqK9jU7N+wpX/oUT4aTFImYf3QRXEI
         krQ1mlWWu2qAN/pariSljSm9a95iFx/XsyA+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693347655; x=1693952455;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HBGxhGVE/O9KafVESYT+LOweSNa/w8MY2IicYyYz9S4=;
        b=Bnbk82NR3pXQAMijmFvnMBaeuRLaHkQg7ip6sStcwWoWpMmfKpnm24CrRr+02I+Wa2
         bZzTi9Rg7YgRs33glgqI1/tYo8ucbN4lpfyTQWHuEHfMhY6k9xgL7uZSUwZV85cWGdzg
         hAs698WqehrsLtxbMubYzWMphR23dydHIwdrMr77vi5WSiZAcsd/Bb7DbjwVBaEZGpFr
         YaioR4m4MzQT5VJxYDFL7V5njSRg3HJbLwmbP3+CauN658MBbi7oweLeqAYnBCqDXVqc
         IHazp7ZO5IBkXoVODbd3Mtx4v8A0ZQRSRh979qrN3RtaSIadiZmJqhhN6x2T+HqA0k4Y
         zWWg==
X-Gm-Message-State: AOJu0YxImEhFAmx7nHAc11lPiNckX9ltFd5/Kwakc0h853Aw0FydYUe4
        t2P8wj+yHBk89ay4IZ9/aFNYA9a5Idkx5Z26KFrs+FPx
X-Google-Smtp-Source: AGHT+IGyNRZXtQdpWfpTGHaVRUYSR4BGEx5cjz7e8A1+QGk+3/238uV2WQC17ziwLVyjKbZjrAXKAg==
X-Received: by 2002:a17:907:7895:b0:9a5:c9a4:ba19 with SMTP id ku21-20020a170907789500b009a5c9a4ba19mr221853ejc.47.1693347655178;
        Tue, 29 Aug 2023 15:20:55 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id qq21-20020a17090720d500b0098ec690e6d7sm6460189ejb.73.2023.08.29.15.20.54
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 15:20:54 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-31c8a710545so3092402f8f.3
        for <mm-commits@vger.kernel.org>; Tue, 29 Aug 2023 15:20:54 -0700 (PDT)
X-Received: by 2002:a5d:554b:0:b0:317:618a:c72 with SMTP id
 g11-20020a5d554b000000b00317618a0c72mr262356wrw.64.1693347654025; Tue, 29 Aug
 2023 15:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230828225431.354d3d2d3b80ee5b88e65eb5@linux-foundation.org>
In-Reply-To: <20230828225431.354d3d2d3b80ee5b88e65eb5@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Aug 2023 15:20:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgsKp2ZPxQ_WvRGLJXtZG6Z2TrqC_jNppukfniCZB9doQ@mail.gmail.com>
Message-ID: <CAHk-=wgsKp2ZPxQ_WvRGLJXtZG6Z2TrqC_jNppukfniCZB9doQ@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.6-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 28 Aug 2023 at 22:54, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Linus, please pull mm.git's non-MM updates for this cycle.

Hmm. For some non-obvious (to me) reason this triggers

  vmlinux.o: warning: objtool: ibt_selftest+0x18: sibling call from
callable instruction with modified stack frame

which didn't happen before, even though the pull doesn't actually
change that file at all.

I see that Josh has a patch to fix this by making it be real assembly
code rather than a hacky inline asm in a C file, but it's a bit
surprising, and I don't see why it's triggered now when it wasn't
before.

At a guess it's related to the Kconfig changes, but I have nothing to
back that guess up with.

Slightly annoying, but I guess I'll live with the warning for now.

               Linus
