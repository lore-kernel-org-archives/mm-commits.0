Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3EFC77B7C
	for <mm-commits@archiver.kernel.org>; Sat,  6 May 2023 00:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjEFA5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 20:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjEFA5J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 20:57:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33913AAF
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 17:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 606B6641C5
        for <mm-commits@vger.kernel.org>; Sat,  6 May 2023 00:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B980C433EF;
        Sat,  6 May 2023 00:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683334626;
        bh=+83nzF1c824Q/TkcQR3s1GbNDi3OW8iN7jZbpCHFojo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p7AqwiM31tVoFdaAS40iTQxTZvfHnh1Fxed8/nfIipSEDMgnte+CPR6msAyE84A9A
         vn1A3rIyCswgRvZwiKamrLhD8Di5tHrJb70RTsTM2WocNy7pL4OjMAtUHqUM5DmqDk
         t2OWCIp6CWMHIHuDDbKGhVIV5rbMVF9PgMUg69Ng=
Date:   Fri, 5 May 2023 17:57:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     Yosry Ahmed <yosryahmed@google.com>, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, pmladek@suse.com, senozhatsky@chromium.org
Subject: Re: [merged] seq_buf-add-seq_buf_do_printk-helper.patch removed
 from -mm tree
Message-Id: <20230505175705.7d969e202a14b6193dc05dcf@linux-foundation.org>
In-Reply-To: <20230506002805.121855-1-sj@kernel.org>
References: <CAJD7tkY9wBYX6JNf7D6tHTHRyYac_U+JKzRab+RJUKHCAG4zgw@mail.gmail.com>
        <20230506002805.121855-1-sj@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat,  6 May 2023 00:28:05 +0000 SeongJae Park <sj@kernel.org> wrote:

> > That patch was merged into Linus's tree, so I assumed that's why it
> > was dropped from mm-unstable. Perhaps I am wrong.
> 
> Same to my assumption, and fit with the original mail's explanation.  I
> confirmed the patch has merged in the mainline as commit 96928d9032a7.  So this
> will be fixed if 1) mm-unstable is rebased on v6.4-rc1, 2) the dropped patch is
> added again on mm-unstable, or 3) the patch[1] currently triggering the failure
> is dropped.  This is never an important issue for me, so I don't have any
> preference or opinion about the fix.  I just wanted to save time for others who
> might got report of this.

The mm-everything which I just pushed out has seq_buf_do_printk().

The mm-unstable branch doesn't, oops.  I'll fix and repush.
