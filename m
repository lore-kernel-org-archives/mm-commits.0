Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18233C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 15:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389851AbiDUPJZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 11:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243205AbiDUPJX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 11:09:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242A018E0F
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 08:06:34 -0700 (PDT)
Received: from zn.tnic (p200300ea971b581b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:581b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BB1AE1EC047F;
        Thu, 21 Apr 2022 17:06:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1650553588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1CUulx46ore+C/81/qYOIkQxt48mM0FBMnOdoOdynsM=;
        b=Y5WQgQ7AdYqN26pSEAyaqifnyv7y3UyqXatOJjJtM4KRl4sSRsf6nfMWgC+gQRdz9pyuSM
        bNRJEsP7STktDlc7gbAxOFEkHFnWJ5f0l9gVQJKF+bDPZj6JSQFc2sIduh/H3512ZICmmL
        hsP3VfP2sITOXEUMspyA+WVjZf3uErc=
Date:   Thu, 21 Apr 2022 17:06:24 +0200
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
Message-ID: <YmFy8DEqvX4FlnuB@zn.tnic>
References: <Ylr8rR+LHQ1uGL47@zn.tnic>
 <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
 <Ylsx5PwyUPOainHa@zn.tnic>
 <YlxtTNFP58TcUHZQ@zn.tnic>
 <CAHk-=wiB8GXu84rChFvUZoZDfp6LnTuLruc0xoxj=mStmK-b1Q@mail.gmail.com>
 <Yl06PWVgeZplboXV@zn.tnic>
 <CAHk-=wh3ZFnUs+k0w3yTth8Kiy8xK45jo2VaT7x_-VFFMBVZiw@mail.gmail.com>
 <Yl5+DCfQmG5C3BHf@zn.tnic>
 <CAHk-=wi1iQXd3SSoyWZebdxdK3gFCVGq9q=4pwq3rON3BYZJkA@mail.gmail.com>
 <Yl7146AZDgfLviVv@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yl7146AZDgfLviVv@zn.tnic>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Some numbers with the microbenchmark:

$ for i in $(seq 1 100); do dd if=/dev/zero of=/dev/null bs=16K count=10000 2>&1 | grep GB; done > /tmp/w.log
$ awk 'BEGIN { sum = 0 } { sum +=$10 } END { print sum/100 }' /tmp/w.log

on AMD zen3

original:	20.11 Gb/s
rep_good:	34.662 Gb/s
erms:		36.378 Gb/s
fsrm:		36.398 Gb/s

I'll run some real benchmarks later but these numbers kinda speak for
themselves so it would be unlikely that it would show different perf
with a real, process-intensive benchmark...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
