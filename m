Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22E8C77B73
	for <mm-commits@archiver.kernel.org>; Sun, 16 Apr 2023 20:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjDPUy6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Apr 2023 16:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDPUy6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Apr 2023 16:54:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14E6268A
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 13:54:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8122321A7F;
        Sun, 16 Apr 2023 20:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681678495;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N36R5rrBBRQXJc0jClAutDe5aL3RCpYYqgANliAJqO8=;
        b=pVvLlHMGG4J1efUlGIw+6yg3C4tft6217piu0reUYGIi+Poaa6FTAVFkAnNUxB28LjiEj6
        7vudjfGpOZO7EGJvqkK5LLMJuqMUQZL75hgg5221BoraK9r/xoiGkuOfxOglDahZO0HEUE
        OJdUjguQJ9YOWtlDu+vZNqW4r7WFe/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681678495;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N36R5rrBBRQXJc0jClAutDe5aL3RCpYYqgANliAJqO8=;
        b=FW77zGfQLq2fOG5gZd3PD6ee19uIQvV1n2Hr5yU0cGa11W2t2M1YjyYfxG2uSB1Beb77HE
        LFhoIztf8x0/E6Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 21FD713498;
        Sun, 16 Apr 2023 20:54:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KyQABp9gPGTXTwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Sun, 16 Apr 2023 20:54:55 +0000
Date:   Sun, 16 Apr 2023 22:54:58 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, sam@ravnborg.org,
        ruben.ayrapetyan@arm.com, kevin.brodsky@arm.com
Subject: Re: + uapi-linux-consth-prefer-iso-friendly-__typeof__.patch added
 to mm-nonmm-unstable branch
Message-ID: <20230416205458.GA2297493@pevik>
References: <20230412002416.ED32CC433EF@smtp.kernel.org>
 <CAK7LNATXj+xV3Q_qeO_aO-fBhNif7i7sYQAo0oLVW=M1pGmHEA@mail.gmail.com>
 <20230412053439.GA1949572@pevik>
 <CAK7LNARLMmtHFwzwpg9ys+D6+7jonV8g+PCR9QeXiQTukb8VrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK7LNARLMmtHFwzwpg9ys+D6+7jonV8g+PCR9QeXiQTukb8VrQ@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

> Hi Andrew,



> On Wed, Apr 12, 2023 at 2:34 PM Petr Vorel <pvorel@suse.cz> wrote:

> > > On Wed, Apr 12, 2023 at 9:24 AM Andrew Morton <akpm@linux-foundation.org> wrote:


> > > > The patch titled
> > > >      Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
> > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > > >      uapi-linux-consth-prefer-iso-friendly-__typeof__.patch

> > > > This patch will shortly appear at
> > > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uapi-linux-consth-prefer-iso-friendly-__typeof__.patch

> > > > This patch will later appear in the mm-nonmm-unstable branch at
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

> > > > Before you just go and hit "reply", please:
> > > >    a) Consider who else should be cc'ed
> > > >    b) Prefer to cc a suitable mailing list as well
> > > >    c) Ideally: find the original patch on the mailing list and do a
> > > >       reply-to-all to that, adding suitable additional cc's

> > > > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

> > > > The -mm tree is included into linux-next via the mm-everything
> > > > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > > > and is updated there every 2-3 working days

> > > > ------------------------------------------------------
> > > > From: Kevin Brodsky <kevin.brodsky@arm.com>
> > > > Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
> > > > Date: Tue, 11 Apr 2023 10:27:47 +0100

> > > > typeof is (still) a GNU extension, which means that it cannot be used when
> > > > building ISO C (e.g.  -std=c99).  It should therefore be avoided in uapi
> > > > headers in favour of the ISO-friendly __typeof__.

> > > > Unfortunately this issue could not be detected by
> > > > CONFIG_UAPI_HEADER_TEST=y as the __ALIGN_KERNEL() macro is not expanded in
> > > > any uapi header.

> > > > Link: https://lkml.kernel.org/r/20230411092747.3759032-1-kevin.brodsky@arm.com
> > > > Fixes: d6fc9fcbaa65 ("kbuild: compile-test exported headers to ensure they are self-contained")


> > > This tag is wrong.

> > > The correct one is:

> > > Fixes: a85cbe6159ff ("uapi: move constants from <linux/kernel.h> to
> > > <linux/const.h>")

> > I'm sorry if I misinterpreted the history. The reason why I think it was
> > d6fc9fcbaa65 (which introduced -std=c90) is because there was already some
> > typeof() uses before this commit (uapi/linux/kernel.h and
> > uapi/linux/netfilter/x_tables.h).



> Sorry, I wrongly read the code.


> Fixes: a85cbe6159ff ("uapi: move constants from <linux/kernel.h> to
> <linux/const.h>")

> was also wrong.


> Before a85cbe6159ff, 'typeof' existed in include/uapi/linux/kernel.h.
> So, it was exported to userspace.


> Kevin suspects 607ca46e97a1 ("UAPI: (Scripted) Disintegrate
> include/linux"), but I think the issue goes back more.




> I think the following is the first commit that exported it.

> Fixes: a79ff731a1b2 ("netfilter: xtables: make XT_ALIGN() usable in
> exported headers by exporting __ALIGN_KERNEL()")

Yes, that's the first commit which adds typeof().

I pointed out d6fc9fcbaa65, because that brought -std=c90. I thought that commit
introduced expectation of C without non-gnu extensions for headers. But if this
expectation was "since ever" then obviously a79ff731a1b2 is the faulty commit.

Anyway, I'm going to send patch, which replaces typeof() in
netfilter/x_tables.h.

Kind regards,
Petr
