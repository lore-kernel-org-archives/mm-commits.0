Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69996C2B9F4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 16:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 357F761057
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 16:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhFQQD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbhFQQD7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jun 2021 12:03:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BACC061574
        for <mm-commits@vger.kernel.org>; Thu, 17 Jun 2021 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XScTWn5QtAay7JKFVwEjUg3s2nuwq8FzX+DQs4OttEA=; b=KF6S14OdCwoy43oM/Xhl54AmTf
        6QhcpgI7wkEmDVTOOq9P+2vHDWonpcDWfBBddcFuxJFwOrCTe6jhRMFlHoGoyr9YJ7ypshLDK0Juf
        8og/HgiqJRh50LkbQjXN16rElgE2wLTlV4MQJHjsE48dY6EQPdPpha/Ss0uUmxKaZOcAVobl2MYqu
        glSill+oL/OrhGdDHF+Lk+KiDyuHQvF0wv7oFpYar7NSVMGLskvD/RxE31wejpeGqn8ngqm9eyd1Z
        Z77uZVy5THhnc5eQxQpj8wopnkOl6g+wYrK9j5+In3zwb0NztDlTgbnrvgqHKCBREx7SkDpQsZyOr
        ffTlHeNg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltuSL-009JIK-Ol; Thu, 17 Jun 2021 16:01:28 +0000
Date:   Thu, 17 Jun 2021 17:01:25 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Rafael Aquini <aquini@redhat.com>
Cc:     akpm@linux-foundation.org, hca@linux.ibm.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, yuzhao@google.com
Subject: Re: + mm-mark-idle-page-tracking-as-broken.patch added to -mm tree
Message-ID: <YMtx1RLd07/nHUeb@casper.infradead.org>
References: <20210615020547.0bhMmTZsz%akpm@linux-foundation.org>
 <YMp7P/peGtRkfRQf@optiplex-fbsd>
 <YMtsLVyQsrROCeiG@casper.infradead.org>
 <YMtwN7nIvw/yl0gW@optiplex-fbsd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMtwN7nIvw/yl0gW@optiplex-fbsd>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jun 17, 2021 at 11:54:31AM -0400, Rafael Aquini wrote:
> On Thu, Jun 17, 2021 at 04:37:17PM +0100, Matthew Wilcox wrote:
> > On Wed, Jun 16, 2021 at 06:29:19PM -0400, Rafael Aquini wrote:
> > > > In discussion with other MM developers around how idle page tracking
> > > > should be fixed for transparent huge pages, several expressed the opinion
> > > > that it should be removed as it is inefficient at accomplishing the job
> > > > that it is supposed to, and we have better mechanisms (eg uffd) for
> > > > accomplishing the same goals these days.
> > > 
> > > I didn't follow the aforementioned discussion, so it would be nice to
> > > have a little bit more detailed explanation on both points raised here
> > > (issues with THP and innefficiency). There are some Red Hat customers
> > > and partners that do rely on the feature, thus the interest. Thanks.
> > 
> > It would be nice if you asked this on the original thread (which you're
> > cc'd on) instead of starting a new thread.
> 
> Sorry about that, but for some weird reason only Andrew's email made its way
> into my inbox.

You should probably file a bug with your IT department then.  There are
a dozen emails cc'ing you in this thread, some from people in your own
company:
https://lore.kernel.org/linux-mm/20210612000714.775825-1-willy@infradead.org/

