Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F979C64ED8
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 20:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBXUOq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 15:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBXUOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 15:14:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8A8231C5
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 12:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677269644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s7+ZgZ9AOzeVCqtrS/SRc6vtP8hmyKMJwSCtnXuKzE0=;
        b=CW/oz6ZNWR2K8ysLqafcGQG06oBoX0sG3S1/qIdGamyBTUvEI0myOOSRih2r9q4axjd3Xc
        Sb3EWYvHuJgaDDPRyykZfRYDf55rcYvvTHkGoUVpyun4KW9xSIM4AvJ+VIU1Fj0DomLSlZ
        kx6OlwaZPOiBusIr8rXMfBVansuF8uA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-QtwMliXsNPCmyUCOCF5vNw-1; Fri, 24 Feb 2023 15:14:00 -0500
X-MC-Unique: QtwMliXsNPCmyUCOCF5vNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3EAD95D601;
        Fri, 24 Feb 2023 20:13:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 218B72166B2B;
        Fri, 24 Feb 2023 20:13:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y/kFnhUM5hjWM2Ae@casper.infradead.org>
References: <Y/kFnhUM5hjWM2Ae@casper.infradead.org> <Y/jhwuTCaOgOTLp2@casper.infradead.org> <2134430.1677240738@warthog.procyon.org.uk> <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com> <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org> <2213409.1677249075@warthog.procyon.org.uk> <2385089.1677258941@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Content-ID: <2390710.1677269637.1@warthog.procyon.org.uk>
Date:   Fri, 24 Feb 2023 20:13:57 +0000
Message-ID: <2390711.1677269637@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> I don't understand why waiting for fscache here is even the right thing
> to do.

Then why do we have to wait for PG_writeback to complete?

David

