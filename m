Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD432C7EE24
	for <mm-commits@archiver.kernel.org>; Sat,  6 May 2023 00:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjEFA2N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 20:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjEFA2K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 20:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067764C19
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 17:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95972640EB
        for <mm-commits@vger.kernel.org>; Sat,  6 May 2023 00:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6139EC433EF;
        Sat,  6 May 2023 00:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683332889;
        bh=OQoA5SxPZGUpabzgvzBY3jYmUviOd0ygUUXVPOMmgyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwEmvlyEnUY1jdfhqW4G2OPgARxtouhHhvHEFHRFwJUyOUzcVFEgluNkeWXrmD5R2
         Ds4XX/Hnc6KOprnx03i5NGHO6D/mHrkNe5V69masBjFSEJjWgUKCgHB7XvcXPq5Z55
         /937NuubO+ImYp+6OQC4v0d8iCgb+gBLY3d/2pDI+u1xOQs/bBRtR1uD1bkgQP81fl
         SzxxFL4U/sn/KWtUhrP+0nSuRVtv/x43nWpd1DR/TkRaAgc19h0cnp5sbKenKmxHCJ
         Ccb4H8NwPQmMjaMe7uCI9L316FyA9aqpfr7KvgQERWyZWl5nDG/uw24mg9erYqnKM/
         qFW+Hk1HlJH9g==
From:   SeongJae Park <sj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, rostedt@goodmis.org, pmladek@suse.com,
        senozhatsky@chromium.org
Subject: Re: [merged] seq_buf-add-seq_buf_do_printk-helper.patch removed from -mm tree
Date:   Sat,  6 May 2023 00:28:05 +0000
Message-Id: <20230506002805.121855-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAJD7tkY9wBYX6JNf7D6tHTHRyYac_U+JKzRab+RJUKHCAG4zgw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 5 May 2023 17:00:20 -0700 Yosry Ahmed <yosryahmed@google.com> wrote:

> On Fri, May 5, 2023 at 4:57 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hi Andrew,
> >
> > On Fri, 05 May 2023 15:45:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > >
> > > The quilt patch titled
> > >      Subject: seq_buf: add seq_buf_do_printk() helper
> > > has been removed from the -mm tree.  Its filename was
> > >      seq_buf-add-seq_buf_do_printk-helper.patch
> > >
> > > This patch was dropped because it was merged into mainline or a subsystem tree
> >
> > Just for headup.  I just found the latest mm-unstable indeed dropped the patch
> > but a patch[1] depends on it.  As a result, build fails as below.
> 
> That patch was merged into Linus's tree, so I assumed that's why it
> was dropped from mm-unstable. Perhaps I am wrong.

Same to my assumption, and fit with the original mail's explanation.  I
confirmed the patch has merged in the mainline as commit 96928d9032a7.  So this
will be fixed if 1) mm-unstable is rebased on v6.4-rc1, 2) the dropped patch is
added again on mm-unstable, or 3) the patch[1] currently triggering the failure
is dropped.  This is never an important issue for me, so I don't have any
preference or opinion about the fix.  I just wanted to save time for others who
might got report of this.

[1] https://lore.kernel.org/mm-commits/20230502201509.B8711C433D2@smtp.kernel.org/


Thanks,
SJ

> 
> >
> >       CC      mm/memcontrol.o
> >     /mm/memcontrol.c: In function ‘mem_cgroup_print_oom_meminfo’:
> >     /mm/memcontrol.c:1693:2: error: implicit declaration of function ‘seq_buf_do_printk’; did you mean ‘seq_buf_bprintf’? [-Werror=implicit-function-declaration]
> >      1693 |  seq_buf_do_printk(&s, KERN_INFO);
> >           |  ^~~~~~~~~~~~~~~~~
> >           |  seq_buf_bprintf
> >     cc1: some warnings being treated as errors
> >
> > [1] https://lore.kernel.org/mm-commits/20230502201509.B8711C433D2@smtp.kernel.org/
> >
> >
> > Thanks,
> > SJ
