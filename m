Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AF1C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 17:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244499AbiDSRvP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 13:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242394AbiDSRvO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 13:51:14 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDAF10FF0
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 10:48:28 -0700 (PDT)
Received: from zn.tnic (p200300ea971b5839329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:5839:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 76FD51EC02B9;
        Tue, 19 Apr 2022 19:48:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650390502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GuY3DwVEGjMuRiXBQXhcN1znmQXzba5WWmftIlbw9YE=;
        b=RK7ztxvbXeGsf8EMFBli8pG9NwHvjyXIYvHJTPZG8Ztq+d7rEgQKKJrgUBVe2ZsCcV4/ov
        zLd0pYazSCglt/l1o+T7eb7kOhPCQuNV2LFhOlFxt2//CNsgCbWd1jn0mDhz6CYJwLDmUq
        41+oK5Ou6oe3N3NjFSiFRxjtvyh+L8c=
Date:   Tue, 19 Apr 2022 19:48:19 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
Message-ID: <Yl7146AZDgfLviVv@zn.tnic>
References: <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com>
 <Ylr8rR+LHQ1uGL47@zn.tnic>
 <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic>
 <YlxtTNFP58TcUHZQ@zn.tnic>
 <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic>
 <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic>
 <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Apr 19, 2022 at 09:41:42AM -0700, Linus Torvalds wrote:
> But I'm ok with the complex version too, I guess.

I feel ya. I myself am, more often than not, averse to such complex
things if it can be solved in a simpler way but we have those fancy
exception handlers tricks everywhere and if we did it here differently,
it would completely not fit the mental pattern and we would wonder why
is this special...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
