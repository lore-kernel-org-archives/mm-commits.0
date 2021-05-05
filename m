Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A345C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 17:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B861610EA
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 17:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhEERlg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 May 2021 13:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238515AbhEERiT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 May 2021 13:38:19 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAACC0612AF
        for <mm-commits@vger.kernel.org>; Wed,  5 May 2021 10:10:53 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c11so3600204lfi.9
        for <mm-commits@vger.kernel.org>; Wed, 05 May 2021 10:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cpUaxRULJxpkZQ+cozpPSu15vmmZtAc6oUbFY/lIXy0=;
        b=F0UHJMt5IwA5bDTU57VX2DzSM1I7+UFrHeSj/LR79N+PSGY6UUCVFfqYAOYXMcfh69
         TlPHMdYN3cyKm0lcYoT8FzG23p/knBEJDCyZKYVmem/f/uHEAa9cw3HhB0UnZEtEklmn
         fZzD4X6RyooSTtDShXDpD6r2gi8MZCrc57DtA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cpUaxRULJxpkZQ+cozpPSu15vmmZtAc6oUbFY/lIXy0=;
        b=apITLRc3oF5H24De/UcIxYf3lZrV9LO/DrNxVRn0q2geISF21dLUWFLSOJxeI97Hir
         U7dtus11/Rhz7j+9e7DLqw2hwQHxnuY8a6aEX6+FtdcP7hP182Ql639vxnRP3udqsVf3
         fj5/MA7E7DTcgZRZmK8d/UVM5bq/dJmJmoblFDA4AMmO9fIfecbBPMkOd+E2EHQvp9SY
         8MniYsylkXhhlQ3FZfP5zZ+LJlvTv66XWtEX4oIIe7aw+9LgyfqG/4Dyc7DmTEI3bDEK
         kFOztLFD8B54zEmjADccMWpeMXxc2UVwEHJSEJYPTJFRjQe8L1C9p0Ge5GCEIDOPQYar
         FLVg==
X-Gm-Message-State: AOAM532v0bwyZpjiBUbVdkx/hyrVRISQ3i/U51XZ1uDsLNGMBkM/fVVD
        Uo+i5a68orVw/Y2+uDBGvUrJDeL9cfVFh42oULQ=
X-Google-Smtp-Source: ABdhPJzvKMbQ3EtQHBx395ASwOZQtp1ztbdXqBr8jidPspXPoQhhGhI5nnblM02pNaR/XOitQ96m/w==
X-Received: by 2002:ac2:5601:: with SMTP id v1mr21347492lfd.275.1620234651343;
        Wed, 05 May 2021 10:10:51 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id o3sm667542lfu.114.2021.05.05.10.10.50
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 10:10:50 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id 12so3564768lfq.13
        for <mm-commits@vger.kernel.org>; Wed, 05 May 2021 10:10:50 -0700 (PDT)
X-Received: by 2002:a05:6512:1095:: with SMTP id j21mr20016063lfg.40.1620234650228;
 Wed, 05 May 2021 10:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
 <CAHk-=wjzDtUVs9To0nMerMt-XDiP3JH2ee=1A9z+0onQaFD4KQ@mail.gmail.com> <20210504201608.5e5f94e76f7eed7264285c28@linux-foundation.org>
In-Reply-To: <20210504201608.5e5f94e76f7eed7264285c28@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 May 2021 10:10:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgOGM5u0Kcx0L0u58D9ms6vQ=LwtJNMNd4xmAjQ+jcQSw@mail.gmail.com>
Message-ID: <CAHk-=wgOGM5u0Kcx0L0u58D9ms6vQ=LwtJNMNd4xmAjQ+jcQSw@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 4, 2021 at 8:16 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Let me resend right now with the same in-reply-to.  Hopefully they will
> land in the correct place.

Well, you re-sent it twice, and I have three copies in my own mailbox,
bot they still don't show up on the mm-commits mailing list.

So the list hates them for some odd reason.

I've picked them up locally, but adding Konstantin to the participants
to see if he can see what's up.

Konstantin: patches 103/106/107 are missing on lore out of Andrew's
series of 143. Odd.

             Linus
