Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8A9C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 19:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiB1TJa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiB1TJa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:09:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 322D23B288
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 11:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646075329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bROWJeQrprNwnP0M1M0WojtlEIgcUpLS3QKz1kK1Pm4=;
        b=f02IgxYR84FLM/sVjBMpLRJB80u+oUlfoDqFLd7acQEE4XzO1yQmuPRuqUAxlb2jc2pmNJ
        yf7UvVaIlbeVeCX0K1+OJxLDvOYwWNLxy0rLjYa+50SEJDVT8blsonqge0m0EAHLLXUiF2
        Y2AsxWqpJJxp8XoGzE6/RZ92Z8yqULM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-qWgkcNG6M46rS6CWpzJELQ-1; Mon, 28 Feb 2022 14:08:48 -0500
X-MC-Unique: qWgkcNG6M46rS6CWpzJELQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D05D1091DA2;
        Mon, 28 Feb 2022 19:08:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C07D196F1;
        Mon, 28 Feb 2022 19:08:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220228184317.5759BC340F1@smtp.kernel.org>
References: <20220228184317.5759BC340F1@smtp.kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     dhowells@redhat.com, mm-commits@vger.kernel.org,
        willy@infradead.org, mike.kravetz@oracle.com, kirill@shutemov.name,
        hch@infradead.org
Subject: Re: + mm-export-pageheadhuge-fix.patch added to -mm tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2515941.1646075324.1@warthog.procyon.org.uk>
Date:   Mon, 28 Feb 2022 19:08:44 +0000
Message-ID: <2515942.1646075324@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> -EXPORT_SYMBOL(PageHeadHuge);
> +EXPORT_SYMBOL_GPL(PageHeadHuge);

Does this mean that we're moving towards forbidding use of the pagecache in
non-GPL drivers?  'Standard' bits of the folio API use this function
implicitly.

David

