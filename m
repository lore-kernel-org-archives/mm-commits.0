Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126B4C49361
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 15:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF9A7613F2
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 15:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhFQP4u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:56:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233366AbhFQP4u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 11:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623945282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YBtb3bfwPGh7tKJcHZkomkhd98BKwZ9Q1OjVZgTGJlc=;
        b=CDsWrSdocvUsqAYC6yqPdk6N5vvlDs1YirXnwvyz5t5Y7cDbIqOvwyI0UlWqcxnXRqk+qm
        3zjyzxaLqAPBqal3+AFihb0D8dzrqjo9jj/fYree/mpv7cLP0Q656ezrRcMLbfjcyQy5F7
        pOUJEr13IDkJ84BwhM8sA6ve/9hXR5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-rQp1x9g9OPaq4OoqR3hZwg-1; Thu, 17 Jun 2021 11:54:38 -0400
X-MC-Unique: rQp1x9g9OPaq4OoqR3hZwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 153CB80ED99;
        Thu, 17 Jun 2021 15:54:37 +0000 (UTC)
Received: from optiplex-fbsd (unknown [10.3.128.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EF6B5D6D7;
        Thu, 17 Jun 2021 15:54:34 +0000 (UTC)
Date:   Thu, 17 Jun 2021 11:54:31 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     akpm@linux-foundation.org, hca@linux.ibm.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, yuzhao@google.com
Subject: Re: + mm-mark-idle-page-tracking-as-broken.patch added to -mm tree
Message-ID: <YMtwN7nIvw/yl0gW@optiplex-fbsd>
References: <20210615020547.0bhMmTZsz%akpm@linux-foundation.org>
 <YMp7P/peGtRkfRQf@optiplex-fbsd>
 <YMtsLVyQsrROCeiG@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMtsLVyQsrROCeiG@casper.infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jun 17, 2021 at 04:37:17PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 16, 2021 at 06:29:19PM -0400, Rafael Aquini wrote:
> > > In discussion with other MM developers around how idle page tracking
> > > should be fixed for transparent huge pages, several expressed the opinion
> > > that it should be removed as it is inefficient at accomplishing the job
> > > that it is supposed to, and we have better mechanisms (eg uffd) for
> > > accomplishing the same goals these days.
> > 
> > I didn't follow the aforementioned discussion, so it would be nice to
> > have a little bit more detailed explanation on both points raised here
> > (issues with THP and innefficiency). There are some Red Hat customers
> > and partners that do rely on the feature, thus the interest. Thanks.
> 
> It would be nice if you asked this on the original thread (which you're
> cc'd on) instead of starting a new thread.

Sorry about that, but for some weird reason only Andrew's email made its way
into my inbox.



> > > Mark the feature as BROKEN for now and we can remove it entirely in a few
> > > months if nobody complains.  It is not enabled by Android, ChromeOS,
> > > Debian, Fedora or SUSE.  Red Hat enabled it with RHEL-8.1 and UEK followed
> > > suit, but I have been unable to find why RHEL enabled it.
> > 
> > minor nit on the RHEL mention: CONFIG_IDLE_PAGE_TRACKING is enabled since 8.0
> > for RHEL-8, and 7.7 for RHEL-7.
> 
> Red Hat makes it incredibly hard to find out what changed when.
> You can't then whine about us not understanding what you're doing,
> when you're going out of your way to obfuscate what you do.
>

Not whining about it, just pointing out the fixup. That's part
of the review process, isn't it? There's no need to whine back at it.


