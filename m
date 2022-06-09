Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21363C43334
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 17:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbiFIRRo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 13:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240663AbiFIRRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 13:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDA51BF143
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 10:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2BDBB82CF1
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 17:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0529BC34114;
        Thu,  9 Jun 2022 17:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654795059;
        bh=I1iTkukKfj8Cr6MUAiVDBOLBC/Avmq/TxGEur96UcMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RbtoQiPUN0FC5/XW+GKI4lOmfpveoE3xW1MDokNcVMGazo1e34F4TYWF9BP9rsvf+
         m+I9RU9nyByx57GrrluJXDuqKP8+XFwq5xJgo+7XN5xqa48RLtknYJUG8GRb8Pp01D
         0MM26nXgyf28eoxbFNjoG3rnGYEyxJ5ifd/Rnsgg=
Date:   Thu, 9 Jun 2022 10:17:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     mm-commits@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Alexander Potapenko <glider@google.com>,
        geert+renesas@glider.be, Geert Uytterhoeven <geert@linux-m68k.org>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: + mm-kfence-select-random-number-before-taking-raw-lock.patch
 added to mm-unstable branch
Message-Id: <20220609101738.393ace428296b78106525c13@linux-foundation.org>
In-Reply-To: <CAHmME9pgWOU1wg2s5r99DowFgKYHYn=uYPjOLzHf6HEWOcsqgw@mail.gmail.com>
References: <20220609165640.E538EC34114@smtp.kernel.org>
        <CAHmME9pgWOU1wg2s5r99DowFgKYHYn=uYPjOLzHf6HEWOcsqgw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 9 Jun 2022 19:02:55 +0200 "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> Hi Andrew,
> 
> On Thu, Jun 9, 2022 at 6:56 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >      Subject: mm/kfence: select random number before taking raw lock
> > has been added to the -mm mm-unstable branch.
> 
> I believe this belongs in the hotfixes branch, actually. It's a
> regression in 5.19.
> 

Oh, OK.  Do we have a Fixes: tag?
