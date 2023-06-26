Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F50EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 26 Jun 2023 06:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjFZGIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjFZGIT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2023 02:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB8F4
        for <mm-commits@vger.kernel.org>; Sun, 25 Jun 2023 23:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DE5C60C79
        for <mm-commits@vger.kernel.org>; Mon, 26 Jun 2023 06:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22608C433C0;
        Mon, 26 Jun 2023 06:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1687759697;
        bh=VkQhxCvPjXOEBHJL60Y/TDtIuzvRS8lQl+yYpmCiIwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZWc4wsdotuJTNIx+KoQ1B8vEfxLKyQ/92kD29HNtErdsH3/dKg8TXZsGSMp2vPNO4
         9qRi/Vh1A34vM2t472AGmxkXqJdWbHiLjblC3ZIk1UwX8Fz+0KEifCC/+nOJ+W7oue
         6CcKEZX51LFOWXtPZ1LDfc05b130HnL68v/Coz0I=
Date:   Mon, 26 Jun 2023 08:08:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, zwp10758@gmail.com,
        senozhatsky@chromium.org, pc@cjr.nz, mcgrof@kernel.org,
        keescook@chromium.org, tiozhang@didiglobal.com
Subject: Re: + cred-convert-printks-to-pr_level.patch added to
 mm-nonmm-unstable branch
Message-ID: <2023062647-baton-opacity-7bcc@gregkh>
References: <20230625035813.A23CAC433C8@smtp.kernel.org>
 <419ec62b9e88140ac75bd2dae7c94b13acb6b015.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <419ec62b9e88140ac75bd2dae7c94b13acb6b015.camel@perches.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Jun 25, 2023 at 02:38:39PM -0700, Joe Perches wrote:
> On Sat, 2023-06-24 at 20:58 -0700, Andrew Morton wrote:
> > The patch titled
> >      Subject: cred: convert printks to pr_<level>
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      cred-convert-printks-to-pr_level.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cred-convert-printks-to-pr_level.patch
> > 
> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> > 
> > ------------------------------------------------------
> > From: tiozhang <tiozhang@didiglobal.com>
> > Subject: cred: convert printks to pr_<level>
> > Date: Sun, 25 Jun 2023 11:34:52 +0800
> > 
> > Use current logging style.
> > 
> > Link: https://lkml.kernel.org/r/20230625033452.GA22858@didi-ThinkCentre-M930t-N000
> > Signed-off-by: tiozhang <tiozhang@didiglobal.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Luis Chamberlain <mcgrof@kernel.org>
> > Cc: Paulo Alcantara <pc@cjr.nz>
> > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: Weiping Zhang <zwp10758@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  kernel/cred.c |   27 +++++++++++++++------------
> >  1 file changed, 15 insertions(+), 12 deletions(-)
> > 
> > --- a/kernel/cred.c~cred-convert-printks-to-pr_level
> > +++ a/kernel/cred.c
> > @@ -4,6 +4,9 @@
> >   * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
> >   * Written by David Howells (dhowells@redhat.com)
> >   */
> > +
> > +#define pr_fmt(fmt) "CRED: " fmt
> 
> My preference would be to use
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> but it likely doesn't matter too much.

The patch as-is keeps the messages identical to before, so it should
probably stay this way.

thanks,

greg k-h
