Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05EBC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDRX7l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjDRX7k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680BB449F
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:59:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02CA962D0E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069BBC433D2;
        Tue, 18 Apr 2023 23:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681862378;
        bh=it0BR3aoIkmLnu4ma7uAa+cCCFIiD8qb/6C4Up8RC5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lM55pnNNweULRdicTL80byDYW3GjG1RLHa6HA5Oj9TwVSLeQQzMLEDtAeiZHanFMB
         N+AQpfwhlAQAS8nmkKHPK/Pq9pZlhsN+hZiMseSD+RD80VYkdigrM9Jc34cPS18M3x
         RgpCWxNgo6jiYlFMw5UZHgI4vzNesI45rvUJJuFc=
Date:   Tue, 18 Apr 2023 16:59:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        punit.agrawal@bytedance.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hannes@cmpxchg.org,
        dave@stgolabs.net
Subject: Re: [merged mm-stable]
 mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked.patch removed
 from -mm tree
Message-Id: <20230418165937.3b70f5945ab95f3c77c2cdb4@linux-foundation.org>
In-Reply-To: <CAJuCfpFjfZEWpS2G4YijK0SQ2+0fHqk9k-4YLHsyw9jNQm8RnA@mail.gmail.com>
References: <20230418233556.91AA5C433D2@smtp.kernel.org>
        <CAJuCfpFjfZEWpS2G4YijK0SQ2+0fHqk9k-4YLHsyw9jNQm8RnA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 18 Apr 2023 16:39:40 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> On Tue, Apr 18, 2023 at 4:35 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > The quilt patch titled
> >      Subject: mm: handle swap page faults under vma lock if page is uncontended
> > has been removed from the -mm tree.  Its filename was
> >      mm-handle-swap-page-faults-if-the-faulting-page-can-be-locked.patch
> >
> > This patch was dropped because it was merged into the mm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Andrew, there are cases which are not properly handled in this patch,
> outlined here: https://lore.kernel.org/all/87sfczuxkc.fsf@nvidia.com/
> Please drop it for now until I post the next version. It's not stable
> material yet. Thanks!

OK, this patch has been dropped.
