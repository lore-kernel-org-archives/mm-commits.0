Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC45C4363A
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A3D22253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709266;
	bh=rYW1JkedZpmL4IoAdclADqERDkV8ixdS9HH8U6mkrs0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:List-ID:
	 From;
	b=IMXknYIde5a4WwfCHP9e2zlPVNWevMZZFyKZcJLnvgjhhbRwGlkJigGLyePWXat2S
	 EsQfPncxA76QtACKBGFs43n4K4QEd6PMhoP9bypsWhyJB3ZHPTevoTpG7xZ8pw0djd
	 RDSmqUVQCDo69Oyra5oSbtmuqP4Fx6c1XiY+260s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgJNVBF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgJNVBD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26FE622259;
        Wed, 14 Oct 2020 21:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709255;
        bh=rYW1JkedZpmL4IoAdclADqERDkV8ixdS9HH8U6mkrs0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k8qwoVvRCd3VGnZNI9//Vtn5N0lFQT+HUXGYUBLBvyIILwkNaam9xAVv0MGixUhT0
         8us6bDPoxLa0/KMWXqbOoSvwrWg7+zxMj4nDiO2R2gNDDN3ixgVxadt+dF3g/fBh67
         6zdvLR95qEVIcGXv+1LNXhRMDCaeFOVSoLUsTyqA=
Date:   Wed, 14 Oct 2020 14:00:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexander Potapenko <glider@google.com>
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Albert van der Linde <alinde@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>, Christoph Hellwig <hch@lst.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        mm-commits@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [wrecked] x86-add-failure-injection-to-get-put-clear_user.patch
 removed from -mm tree
Message-Id: <20201014140053.a6b51a7ea680f29b2c54a14b@linux-foundation.org>
In-Reply-To: <CAG_fn=U+zDi-Z7FmkhUWsMjVALvG-jkOgvmjiz6_HfjzLcF4UQ@mail.gmail.com>
References: <20201013182031.poYlHG6fX%akpm@linux-foundation.org>
        <CAG_fn=U+zDi-Z7FmkhUWsMjVALvG-jkOgvmjiz6_HfjzLcF4UQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 14 Oct 2020 16:00:56 +0200 Alexander Potapenko <glider@google.com> wrote:

> Hi Andrew,
> 
> On Tue, Oct 13, 2020 at 8:20 PM <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: x86: add failure injection to get/put/clear_user
> > has been removed from the -mm tree.  Its filename was
> >      x86-add-failure-injection-to-get-put-clear_user.patch
> >
> > This patch was dropped because other changes were merged, which wrecked this patch
> 
> On top of which tree should we rebase the patches to see/resolve these
> conflicts?
> linux-next/akpm and linux-mm/master seem to still contain all three
> patches in question.

The problem is ec6347bb43395 ("x86, powerpc: Rename memcpy_mcsafe() to
copy_mc_to_{user, kernel}()"), which is in Linus's tree.  It seems to
have got slammed in at the last minute (with a cc:stable so I guess
it's important).  Please rebase and retest against current -linus and
resend?


