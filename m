Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E833BC7EE23
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 17:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBXRUT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBXRUT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 12:20:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795BB158BF
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 09:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677259177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f2WOQUqLPxDcFQ7Nje15yiuLa01CXfpErjUcBxi/r80=;
        b=YMsr/j5JWxeYuBubFaI/0Oi6Dvb5wSYqrG42l39ciO8GpzWsttGVSfLA9kJkoesHdhFPsg
        xrHnxqKYSDtvxi1SJiHrtOznmZu8pmNldD1Zm6E840TeVn6efQo9mjl+obDyY8wB3/8HY0
        6JveW6VLqeQLVgvN5xDebXaz3vCdmJY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-NifuMESHMPOwiyBH2L3mAQ-1; Fri, 24 Feb 2023 12:19:31 -0500
X-MC-Unique: NifuMESHMPOwiyBH2L3mAQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C0DD3804531;
        Fri, 24 Feb 2023 17:19:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6C722026D4B;
        Fri, 24 Feb 2023 17:19:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=whFKL4VuFBWvenG8fAgfvbf36PDgouUSx47rZDWr9BkJw@mail.gmail.com>
References: <CAHk-=whFKL4VuFBWvenG8fAgfvbf36PDgouUSx47rZDWr9BkJw@mail.gmail.com> <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com> <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org> <2134430.1677240738@warthog.procyon.org.uk> <2213409.1677249075@warthog.procyon.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dhowells@redhat.com, Steve French <stfrench@microsoft.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@cjr.nz>,
        Matthew Wilcox <willy@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] cifs: Fix cifs_writepages_region()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2385283.1677259167.1@warthog.procyon.org.uk>
Date:   Fri, 24 Feb 2023 17:19:27 +0000
Message-ID: <2385284.1677259167@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Can you humor me, and try if just removing that skip count thing
> instead? IOW, this attached patch?

That works too.

> Because that whole "let's stop writing if we need to reschedule" sounds
> truly odd (we have a cond_resched(), although it's per folio batch, not
> per-folio), and the skip count logic doesn't make much sense to me either.

The skip thing, in my code, is only used in WB_SYNC_NONE mode.  If we hit 5
things in progress or rescheduling is required, we return to the caller on the
basis that conflicting flushes appear to be happening in other threads.

David

