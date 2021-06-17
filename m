Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F191FC48BE5
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 15:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3809610CA
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 15:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhFQPkN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhFQPkM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jun 2021 11:40:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAF3C061574
        for <mm-commits@vger.kernel.org>; Thu, 17 Jun 2021 08:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=psENrHR4DKV6NrCx6JPqvem9CXDYaInbv7dGQIYnp60=; b=B9HdZ5EHoyaVceOs9XYSxu5Bzn
        MnnpmwiXBZObJbM29XmtTPMU8mpeHsu0MjiiEyLneY+8rGi/8+JT+Ijl4gaQxvfMzna8MI/Owx90g
        yaQqrw4opcDSx3QdgTOLeS/Gnn8CqkRZr+F4REo6Lz95gfULP8dwf9ZXQfNNtRLavdUDbjZXruodB
        OvxUha8gEYKSt/qNdLWX/TPw6Om2Sq3qiThPzWapYsYO2eX0g4NG0j8M7f7cqoMD/M+WTZE8fIxxD
        9ZXm+Uqyp9iUfmKuAt87EnU1rzpdWJNlVXPkOuIbE1JO2AtLvURcJ/mF6IldTr/gEyqgeBusUVbr6
        qYQUuPTg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltu4z-009HxH-LR; Thu, 17 Jun 2021 15:37:28 +0000
Date:   Thu, 17 Jun 2021 16:37:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Rafael Aquini <aquini@redhat.com>
Cc:     akpm@linux-foundation.org, hca@linux.ibm.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, yuzhao@google.com
Subject: Re: + mm-mark-idle-page-tracking-as-broken.patch added to -mm tree
Message-ID: <YMtsLVyQsrROCeiG@casper.infradead.org>
References: <20210615020547.0bhMmTZsz%akpm@linux-foundation.org>
 <YMp7P/peGtRkfRQf@optiplex-fbsd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMp7P/peGtRkfRQf@optiplex-fbsd>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 16, 2021 at 06:29:19PM -0400, Rafael Aquini wrote:
> > In discussion with other MM developers around how idle page tracking
> > should be fixed for transparent huge pages, several expressed the opinion
> > that it should be removed as it is inefficient at accomplishing the job
> > that it is supposed to, and we have better mechanisms (eg uffd) for
> > accomplishing the same goals these days.
> 
> I didn't follow the aforementioned discussion, so it would be nice to
> have a little bit more detailed explanation on both points raised here
> (issues with THP and innefficiency). There are some Red Hat customers
> and partners that do rely on the feature, thus the interest. Thanks.

It would be nice if you asked this on the original thread (which you're
cc'd on) instead of starting a new thread.

> > Mark the feature as BROKEN for now and we can remove it entirely in a few
> > months if nobody complains.  It is not enabled by Android, ChromeOS,
> > Debian, Fedora or SUSE.  Red Hat enabled it with RHEL-8.1 and UEK followed
> > suit, but I have been unable to find why RHEL enabled it.
> 
> minor nit on the RHEL mention: CONFIG_IDLE_PAGE_TRACKING is enabled since 8.0
> for RHEL-8, and 7.7 for RHEL-7.

Red Hat makes it incredibly hard to find out what changed when.
You can't then whine about us not understanding what you're doing,
when you're going out of your way to obfuscate what you do.
