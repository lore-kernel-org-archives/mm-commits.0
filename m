Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D3AC6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E16721D7A
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgLBXep (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:34:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgLBXep (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:34:45 -0500
Date:   Wed, 2 Dec 2020 15:34:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606952044;
        bh=1j9Tm46X5njtnU+O5ji+D/K3m3JFr2vzgwM8qBqkhgs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=1XqbpGGMYehRhutNfXOWXaeJp91aPiANQq5T4a4q29b39W5QJu5ukDsqohp+v+DZ8
         hXMybMcrNyv+c/pmbTxTStd3TUZFmVzI/SkITeuotSxAyVIoNw65dT0LwwUcPvxgFW
         2cfMpz3NWmxbm1crFHn+S7lqlHeWZwgXvaPvvGbQ=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     <adobriyan@gmail.com>, <andreyknvl@google.com>,
        <aryabinin@virtuozzo.com>, <catalin.marinas@arm.com>,
        <dvyukov@google.com>, <ebiederm@xmission.com>, <elver@google.com>,
        <glider@google.com>, <mm-commits@vger.kernel.org>,
        <song.bao.hua@hisilicon.com>, <stable@vger.kernel.org>,
        <vincenzo.frascino@arm.com>, <will.deacon@arm.com>
Subject: Re: + proc-use-untagged_addr-for-pagemap_read-addresses.patch added
 to -mm tree
Message-Id: <20201202153402.4b157e9a4f19e7f932a7cf68@linux-foundation.org>
In-Reply-To: <1606874629.22275.5.camel@mtkswgap22>
References: <20201128035253.0uYNNDp0B%akpm@linux-foundation.org>
        <1606874629.22275.5.camel@mtkswgap22>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 2 Dec 2020 10:03:49 +0800 Miles Chen <miles.chen@mediatek.com> wrote:

> On Fri, 2020-11-27 at 19:52 -0800, akpm@linux-foundation.org wrote:
> > The patch titled
> >      Subject: proc: use untagged_addr() for pagemap_read addresses
> > has been added to the -mm tree.  Its filename is
> >      proc-use-untagged_addr-for-pagemap_read-addresses.patch
> > 
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/proc-use-untagged_addr-for-pagemap_read-addresses.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/proc-use-untagged_addr-for-pagemap_read-addresses.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> 
> Sorry for bothering, I checked the next-20201201 tag and the patch in
> next-20201201 is [1], but there is a overflow issue in [1] so I
> submitted v2 [2]. We should take [2], right? 
> (the patch in this email is [2] but the patch in next-20201201 is [1])
> 
> [1] https://lore.kernel.org/patchwork/patch/1343258/
> [1] https://lore.kernel.org/patchwork/patch/1345874/
> 

Yup, I haven't released an -mm snapshot since updating to v2.  (Been
waiting for an arm64 situation to settle itself out).  Hopefully
today...


