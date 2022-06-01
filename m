Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCD0C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 23:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiFAXRO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 19:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiFAXRO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 19:17:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F339B18314C
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 16:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBF21CE1DCE
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 23:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A400C385A5;
        Wed,  1 Jun 2022 23:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654125424;
        bh=FJkkFXR8MB/E+NPJZZcTB0R0pXuVq7qMMEFXKLw3BOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T1Q4jjK7OdfTJ/0SGhoHYP1dtkd8J5p6GrdmIm+fAxWhKn2gY99G8RzDEDTI3Pz1q
         kJ9xv7Z+I/SNMIMn5VQg3250jpi80Z11OG61caVaHHKKb7FtNHBad4mf7TGf82gb2r
         j5jGdrZrxSAbcVCJ0+EhUPyWNzkbJ7VrE0jSYlNU=
Date:   Wed, 1 Jun 2022 16:17:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     mm-commits@vger.kernel.org, Liam Howlett <liam.howlett@oracle.com>
Subject: Re: + mm-drop-oom-code-from-exit_mmap-fix.patch added to
 mm-unstable branch
Message-Id: <20220601161703.3dd75c2a536df153b1a8ef2f@linux-foundation.org>
In-Reply-To: <CAJuCfpFYrG-xT3uX69MZsDEmLjdfXx2xksRwbwsbNwJWy6AYYg@mail.gmail.com>
References: <20220601220859.B1F0EC385A5@smtp.kernel.org>
        <CAJuCfpFvH0EnyNnc8bdFnMVE3tHWQX2zwN7L29Yz+PT_xsZq5A@mail.gmail.com>
        <20220601152228.9f3186da0b507f5bab859f24@linux-foundation.org>
        <CAJuCfpFYrG-xT3uX69MZsDEmLjdfXx2xksRwbwsbNwJWy6AYYg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 1 Jun 2022 15:37:43 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> >         set_bit(MMF_OOM_SKIP, &mm->flags);
> > +       mmap_write_unlock(mm);
> 
> Instead of the line above ^^^
> +
> +       mmap_write_lock(mm);

doh, thanks.
