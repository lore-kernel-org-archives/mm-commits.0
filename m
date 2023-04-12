Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5266C77B6E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 05:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDLFep (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 01:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDLFen (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 01:34:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3329B49FD
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 22:34:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9C05C2193C;
        Wed, 12 Apr 2023 05:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681277679;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=apFfEcFsIrl0mUBeQ/6GfTn6JiqNnhCW/31csKeKFdo=;
        b=mtqtuJBxI7dJkw/SM4mW2LeGWKPFBq5qk77E60wqUZretBaEjPkVyJz7u9iHxHwLMpRNzI
        KsGdDIyuupRgJCqNDCRTtRaDRtW4iCT/dusGjcBjHQV8vVZM+jGbUMykyBwEHabNScWr4U
        Uvgm3CPRuph4k+CrFK9FPtDKApvILgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681277679;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=apFfEcFsIrl0mUBeQ/6GfTn6JiqNnhCW/31csKeKFdo=;
        b=+sCOtyZivf61OOcSE+aGr8webfVeBgS36xoRIP9zrlJD5pe3iWOKec9Lq00wT2mxrxTvGt
        wzq75oC6UPDFe+DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7117F138F0;
        Wed, 12 Apr 2023 05:34:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LbqaGu9CNmRpAgAAMHmgww
        (envelope-from <pvorel@suse.cz>); Wed, 12 Apr 2023 05:34:39 +0000
Date:   Wed, 12 Apr 2023 07:34:39 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, sam@ravnborg.org,
        ruben.ayrapetyan@arm.com, kevin.brodsky@arm.com
Subject: Re: + uapi-linux-consth-prefer-iso-friendly-__typeof__.patch added
 to mm-nonmm-unstable branch
Message-ID: <20230412053439.GA1949572@pevik>
References: <20230412002416.ED32CC433EF@smtp.kernel.org>
 <CAK7LNATXj+xV3Q_qeO_aO-fBhNif7i7sYQAo0oLVW=M1pGmHEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK7LNATXj+xV3Q_qeO_aO-fBhNif7i7sYQAo0oLVW=M1pGmHEA@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

> On Wed, Apr 12, 2023 at 9:24 AM Andrew Morton <akpm@linux-foundation.org> wrote:


> > The patch titled
> >      Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      uapi-linux-consth-prefer-iso-friendly-__typeof__.patch

> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uapi-linux-consth-prefer-iso-friendly-__typeof__.patch

> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's

> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days

> > ------------------------------------------------------
> > From: Kevin Brodsky <kevin.brodsky@arm.com>
> > Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
> > Date: Tue, 11 Apr 2023 10:27:47 +0100

> > typeof is (still) a GNU extension, which means that it cannot be used when
> > building ISO C (e.g.  -std=c99).  It should therefore be avoided in uapi
> > headers in favour of the ISO-friendly __typeof__.

> > Unfortunately this issue could not be detected by
> > CONFIG_UAPI_HEADER_TEST=y as the __ALIGN_KERNEL() macro is not expanded in
> > any uapi header.

> > Link: https://lkml.kernel.org/r/20230411092747.3759032-1-kevin.brodsky@arm.com
> > Fixes: d6fc9fcbaa65 ("kbuild: compile-test exported headers to ensure they are self-contained")


> This tag is wrong.

> The correct one is:

> Fixes: a85cbe6159ff ("uapi: move constants from <linux/kernel.h> to
> <linux/const.h>")

I'm sorry if I misinterpreted the history. The reason why I think it was
d6fc9fcbaa65 (which introduced -std=c90) is because there was already some
typeof() uses before this commit (uapi/linux/kernel.h and
uapi/linux/netfilter/x_tables.h).

Kind regards,
Petr

> Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>




> > Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> > Reported-by: Ruben Ayrapetyan <ruben.ayrapetyan@arm.com>
> > Tested-by: Ruben Ayrapetyan <ruben.ayrapetyan@arm.com>
> > Reviewed-by: Petr Vorel <pvorel@suse.cz>
> > Tested-by: Petr Vorel <pvorel@suse.cz>
> > Cc: Masahiro Yamada <masahiroy@kernel.org>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---

> >  include/uapi/linux/const.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)

> > --- a/include/uapi/linux/const.h~uapi-linux-consth-prefer-iso-friendly-__typeof__
> > +++ a/include/uapi/linux/const.h
> > @@ -28,7 +28,7 @@
> >  #define _BITUL(x)      (_UL(1) << (x))
> >  #define _BITULL(x)     (_ULL(1) << (x))

> > -#define __ALIGN_KERNEL(x, a)           __ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
> > +#define __ALIGN_KERNEL(x, a)           __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
> >  #define __ALIGN_KERNEL_MASK(x, mask)   (((x) + (mask)) & ~(mask))

> >  #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> > _

> > Patches currently in -mm which might be from kevin.brodsky@arm.com are

> > uapi-linux-consth-prefer-iso-friendly-__typeof__.patch
