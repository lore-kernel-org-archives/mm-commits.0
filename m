Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6A5C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 10:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A714D6109D
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 10:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbhHMKSY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 06:18:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239325AbhHMKSY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 06:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628849877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wxjz0He6kIcKCT3vJYzKmzPUuLiyjWEM5BbhpTfbhoA=;
        b=X/K9j4114nbSGMx1sHZpTiG78kWIoFYn7fnxUW2UcFeGRbR/oLnvsRj27+8ZIoaGWPyHi8
        cZy/oIxPUJfUfpWTu5zjf5qNvfql6ky6eQnfgnhn7SCxuAFTGtdtmqbZ2sRqEc3UyVlnSR
        KWTW6Z2oP3xEesVn/8i9XrpyM27d1zc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-vYlQ9mU5M7OrgTWuruR2Ag-1; Fri, 13 Aug 2021 06:17:53 -0400
X-MC-Unique: vYlQ9mU5M7OrgTWuruR2Ag-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76F1E1082920;
        Fri, 13 Aug 2021 10:17:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.22.32.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A5FF2854F;
        Fri, 13 Aug 2021 10:17:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210812215406.bDjzn%akpm@linux-foundation.org>
References: <20210812215406.bDjzn%akpm@linux-foundation.org>
To:     akpm@linux-foundation.org
Cc:     dhowells@redhat.com, mm-commits@vger.kernel.org,
        willy@infradead.org, william.kucharski@oracle.com,
        kirill.shutemov@linux.intel.com, hannes@cmpxchg.org,
        songmuchun@bytedance.com
Subject: Re: + mm-remove-redundant-compound_head-calling.patch added to -mm tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3565215.1628849869.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 13 Aug 2021 11:17:49 +0100
Message-ID: <3565216.1628849869@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

akpm@linux-foundation.org wrote:

> There is a READ_ONCE() in the macro of compound_head(), which will preve=
nt
> compiler from optimizing the code when there are more than once calling =
of
> it in a function.  Remove the redundant calling of compound_head() from
> page_to_index() and page_add_file_rmap() for better code generation.
> =

> Link: https://lkml.kernel.org/r/20210811101431.83940-1-songmuchun@byteda=
nce.com
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: William Kucharski <william.kucharski@oracle.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Seems reasonable, but will it conflict with Willy's folio patchset?

Reviewed-by: David Howells <dhowells@redhat.com>

