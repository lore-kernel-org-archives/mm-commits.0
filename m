Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AE6C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 18:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJKSov (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 14:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJKSot (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 14:44:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB64D101F8;
        Tue, 11 Oct 2022 11:44:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93E9DB81662;
        Tue, 11 Oct 2022 18:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BB2C433C1;
        Tue, 11 Oct 2022 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665513886;
        bh=kyayna2rlKwjfKz02ltMfVPHv/rzSWgj6SiEFuUd3Nk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcOgczNVxlQkjCzCBLAG3UNJBsyD42k4fQ57YqXCGNm5o3VBL1fTh+k/Jhs+qdprT
         VBcYBtZbhau7BKtbdt12etSMYilzfu38GRWK4DjIY2NZxmxCa/IC91EdJM6vUdlbXP
         jYv/i0Ya7FeWEjfW995xvNkofbNQLU7JMoBpAtg7kmrIYb7mX7ZmjzdJqP7TzfYeDW
         7Ds5iDkq4+G+kEVZiFGIpvRCGQ/1CYEWZNPX7ihTW4Rh9Js44lbZ73W0/zBoo5Yhfh
         9edTUsWHTCLAnwTf5RkPe9/y676IHOSEuJaPEiKKXWkF/G/wwwunemD5HLr+Fp8Bej
         AkyJhXKxswZ6w==
Date:   Tue, 11 Oct 2022 11:44:44 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.1-rc1
Message-ID: <20221011184444.npthr2pmzqb32x6z@treble>
References: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
 <CAHk-=wigZoriP8ZB+V87Jf+EQV=ka6DQe_HCAQmh3Dmus2FFhw@mail.gmail.com>
 <Y0UoO2+NsJjbZtaf@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y0UoO2+NsJjbZtaf@hirez.programming.kicks-ass.net>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Oct 11, 2022 at 10:24:27AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 10, 2022 at 06:20:00PM -0700, Linus Torvalds wrote:
> > The other thing I notice from just doing a build is that I now get
> > 
> >    vmlinux.o: warning: objtool: kasan_report+0x12: call to
> > stackleak_track_stack() with UACCESS enabled
> 
> So kasan_report() is already marked as being special; and it does the
> mandatory user_access_save() / user_access_restore() things to fix it
> up.
> 
> But it looks like kasan code itself is now getting instrumented by the
> stackleak stuff and that inserts a call outside of the
> user_access_save()/restore() thing, and *that* is getting flagged.
> 
> Looking at mm/kasan/Makefile it disables a lot of the instrumentation,
> but perhaps not enough?

I can recreate, but weirdly the below doesn't seem to fix it.

diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
index d4837bff3b60..a41cf1235032 100644
--- a/mm/kasan/Makefile
+++ b/mm/kasan/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 KASAN_SANITIZE := n
+KMSAN_SANITIZE := n
 UBSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 

