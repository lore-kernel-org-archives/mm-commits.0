Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6614BC48BE6
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31426613C7
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 22:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhFPWbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Jun 2021 18:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232967AbhFPWbi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Jun 2021 18:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623882569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Eh5HvfZRrvOSfDLHyNuvrslSA3vNH3BLYZ+pp3cVx+E=;
        b=YYTt//ikvoOPa3iWGepCtbvO6c6SyBw59WzVsRmxa412WJ6z64gBodcBS/EbbbXbXc0T4B
        IGGWTR4iz2Y774UtZXwOI907XEzMLFk8Wzmsr4UaeJguflS3mXnFzA75cLV9lVwy9+jNcW
        StupqE258kP0lKsrn2tCibt7p5heqJw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-shF60hrWMsam99vojlNtVw-1; Wed, 16 Jun 2021 18:29:26 -0400
X-MC-Unique: shF60hrWMsam99vojlNtVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA38F100C610;
        Wed, 16 Jun 2021 22:29:24 +0000 (UTC)
Received: from optiplex-fbsd (unknown [10.3.128.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F80D19C66;
        Wed, 16 Jun 2021 22:29:22 +0000 (UTC)
Date:   Wed, 16 Jun 2021 18:29:19 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     akpm@linux-foundation.org
Cc:     hca@linux.ibm.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz, vdavydov.dev@gmail.com,
        willy@infradead.org, yuzhao@google.com
Subject: Re: + mm-mark-idle-page-tracking-as-broken.patch added to -mm tree
Message-ID: <YMp7P/peGtRkfRQf@optiplex-fbsd>
References: <20210615020547.0bhMmTZsz%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615020547.0bhMmTZsz%akpm@linux-foundation.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Jun 14, 2021 at 07:05:47PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: mark idle page tracking as BROKEN
> has been added to the -mm tree.  Its filename is
>      mm-mark-idle-page-tracking-as-broken.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-mark-idle-page-tracking-as-broken.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-idle-page-tracking-as-broken.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Subject: mm: mark idle page tracking as BROKEN
> 
> In discussion with other MM developers around how idle page tracking
> should be fixed for transparent huge pages, several expressed the opinion
> that it should be removed as it is inefficient at accomplishing the job
> that it is supposed to, and we have better mechanisms (eg uffd) for
> accomplishing the same goals these days.

I didn't follow the aforementioned discussion, so it would be nice to
have a little bit more detailed explanation on both points raised here
(issues with THP and innefficiency). There are some Red Hat customers
and partners that do rely on the feature, thus the interest. Thanks.

> Mark the feature as BROKEN for now and we can remove it entirely in a few
> months if nobody complains.  It is not enabled by Android, ChromeOS,
> Debian, Fedora or SUSE.  Red Hat enabled it with RHEL-8.1 and UEK followed
> suit, but I have been unable to find why RHEL enabled it.

minor nit on the RHEL mention: CONFIG_IDLE_PAGE_TRACKING is enabled since 8.0
for RHEL-8, and 7.7 for RHEL-7.

Cheers,
-- Rafael

