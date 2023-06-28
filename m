Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E086EB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jun 2023 19:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjF1TLe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jun 2023 15:11:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231409AbjF1TLd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jun 2023 15:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687979445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DHYzA765GPu9kX2/aCtAcTvHRHevAxD+3e5vQVRrgfY=;
        b=EKA05nBvlvstNW5+TwZ5GHIhFnbFg3pACu9GotfN30deCVRgCwdAZMNc3juNnec8nhMt7L
        20O2xGSU9q7Awnc1h4ypq/v6iVw9I78PTuvgqggAXipWcfjxwuuKp/pw1BpeRoNbtJI4tK
        dmTJJ+aClqMZ9CAHclxJKjXO+fBGIm0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-yDhu-QUUMAKeu8FHPLXHfg-1; Wed, 28 Jun 2023 15:10:43 -0400
X-MC-Unique: yDhu-QUUMAKeu8FHPLXHfg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDC1E8DBAEE;
        Wed, 28 Jun 2023 19:10:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1DFB200B677;
        Wed, 28 Jun 2023 19:10:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wjyJyV=Kyb8XJcLjFEPP-RMF0J6CQfT2OXLmJdM2yEv8w@mail.gmail.com>
References: <CAHk-=wjyJyV=Kyb8XJcLjFEPP-RMF0J6CQfT2OXLmJdM2yEv8w@mail.gmail.com> <20230626085035.e66992e96b4c6d37dad54bd9@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.5-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3696705.1687979441.1@warthog.procyon.org.uk>
Date:   Wed, 28 Jun 2023 20:10:41 +0100
Message-ID: <3696706.1687979441@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I think it needs to match the comment (and the try_grab_page()
> logic), and just basically
> 
>         if (flags & FOLL_GET)
>                 return try_get_folio(page, refs);
> 
>         if (is_zero_page(page))
>                 return page_folio(page);
> 
>         folio = try_get_folio(page, refs);
>         if (!folio)
>                 return NULL;
> 
> instead.

That looks right.

David

