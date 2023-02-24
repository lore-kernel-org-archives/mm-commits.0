Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C32C64ED8
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 20:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBXU7O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 15:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBXU7O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 15:59:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E4527D5F
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 12:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677272307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IRX7slzsj7oP9EoAKocW7fCHED6Bws5rQl0DCvHnUe0=;
        b=dO6wSRNHreQnbBWW67kCODpBfTNUTjglVYrok87xu+WXbhV7/nYp1xaOfMbhkqBykFRFh3
        v5eGVVHtr3W7gz6+CM0VzfoQFQahNmuG9Ljj6RBKU5yN+wt6cN29g1GvBIijcwHC1RJN6S
        7jEF+3P2FLxaE+f2Y7zhVgwPrhVF2/A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-DJUjrUgEMh-kLslfuqIpSg-1; Fri, 24 Feb 2023 15:58:21 -0500
X-MC-Unique: DJUjrUgEMh-kLslfuqIpSg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E6D2811E9C;
        Fri, 24 Feb 2023 20:58:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6618CC15BA0;
        Fri, 24 Feb 2023 20:58:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wgpjrdcs_aFvdHdH6TpOsOmN9S5rXDqCZTB8WqXsZH8Qw@mail.gmail.com>
References: <CAHk-=wgpjrdcs_aFvdHdH6TpOsOmN9S5rXDqCZTB8WqXsZH8Qw@mail.gmail.com> <Y/jhwuTCaOgOTLp2@casper.infradead.org> <2134430.1677240738@warthog.procyon.org.uk> <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com> <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org> <2213409.1677249075@warthog.procyon.org.uk> <2385089.1677258941@warthog.procyon.org.uk> <Y/kFnhUM5hjWM2Ae@casper.infradead.org> <2390711.1677269637@warthog.procyon.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        Steve French <stfrench@microsoft.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@cjr.nz>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] cifs: Fix cifs_writepages_region()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2392015.1677272298.1@warthog.procyon.org.uk>
Date:   Fri, 24 Feb 2023 20:58:18 +0000
Message-ID: <2392016.1677272298@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Then why do we have to wait for PG_writeback to complete?
> 
> At least for PG_writeback, it's about "the _previous_ dirty write is
> still under way, but - since PG_dirty is set again - the page has been
> dirtied since".
> 
> So we have to start _another_ writeback, because while the current
> writeback *might* have written the updated data, that is not at all
> certain or clear.

As I understand it, it's also about serialising writes from the same page to
the same backing store.  We don't want them to end up out-of-order.  I'm not
sure what guarantees, for instance, the block layer gives if two I/O requests
go to the same place.

> I'm not sure what the fscache rules are.

I'm now using PG_fscache in exactly the same way: the previous write to the
cache is still under way.  I don't want to start another DIO write to the
cache for the same pages.

Hence the waits/checks on PG_fscache I've added anywhere we need to wait/check
on PG_writeback.


As I mentioned I'm looking at the possibility of making PG_dirty and
PG_writeback cover *both* cases and recording the difference elsewhere -
thereby returning PG_private_2 to the VM folks who'd like their bit back.

This means, for instance, when we read from the server and find we need to
write it to the cache, we set a note in the aforementioned elsewhere, mark the
page dirty and leave it to writepages() to effect the write to the cache.

It could get tricky because we have two different places to write to, with
very different characteristics (e.g. ~6000km away server vs local SSD) with
their own queueing, scheduling, bandwidth, etc. - and the local disk might
have to share with the system.

David

