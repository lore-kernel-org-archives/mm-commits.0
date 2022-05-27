Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F171C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 11:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbiE0L2Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 07:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbiE0L2X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 07:28:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DA1BCBA
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 04:28:22 -0700 (PDT)
Received: from zn.tnic (p200300ea97465727329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9746:5727:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2F0791EC01A9;
        Fri, 27 May 2022 13:28:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1653650897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=HHppRTC40Y6+2eoncHCdfnKVWjko+FhCz1o03rYlyCc=;
        b=LN1EzsyvZ2sLeZ3Tl7ENuteHHNmcuWv36VyNiTfryuZdzWLnENO1x3VsZyF2yzDmk+eORo
        8wo7BL3PqvrsmXPr0N8R47ZP468Q/DOrqx8umtU1amU2YB7vBUSR1AAfFewO4dVdwYOFia
        muMEHkcYg8YJpl6h72PghChaMEAxrEo=
Date:   Fri, 27 May 2022 13:28:12 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Mark Hemment <markhemm@googlemail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Patrice CHOTARD <patrice.chotard@foss.st.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] x86/clear_user: Make it faster
Message-ID: <YpC1zAomHtZoaz1b@zn.tnic>
References: <YnLfl6lupN2nq7+t@zn.tnic>
 <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
 <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
 <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic>
 <Ynq1nVpu1xCpjnXm@zn.tnic>
 <YozQZMyQ0NDdD8cH@zn.tnic>
 <CANe_+Uga8g+Nhxz_GxXN7OH28=JOAyfE++NbWBHZv9SvO8Vung@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANe_+Uga8g+Nhxz_GxXN7OH28=JOAyfE++NbWBHZv9SvO8Vung@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, May 25, 2022 at 01:11:17PM +0100, Mark Hemment wrote:
> A slight doubt here; comment says "less than a cachline", but the code
> is using 'ja' (jump if above) - so calls 'clear_user_original' for a
> 'len' less than or equal to 64.
> Not sure of the intended behaviour for 64 bytes here, but
> 'copy_user_enhanced_fast_string' uses the slow-method for lengths less
> than 64.  So, should this be coded as;
>     cmp $64,%rcx
>     jb clear_user_original
> ?

Yeah, it probably doesn't matter whether you clear a cacheline the "old"
way or with some of the new ones. clear_user() performance matters only
in microbenchmarks, as I've come to realize.

But your suggestion simplifies the code so lemme do that.

Thx!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
