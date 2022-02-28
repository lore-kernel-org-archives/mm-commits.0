Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D95AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 19:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiB1TPG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiB1TPF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:15:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5108D885D
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 11:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kskZDC0YDlIe3voiKoeIr/nZ7mAG2118Y6YQzAK6+sA=; b=dE06UrViAy2fXGmk2n8IeAMLRE
        wydz1bKXF6dpmouHYFMu2/Q1OuUh4jcELEzHD0nmv/28q+0q3w3cFgheg51uNxsTwmy4lrhkigVLt
        QQjnUM1CGplB5uOttLFhAsff2SpsGuoe3OOMM9p+WnXYfi6H+zzuJ91kH5f+KOrCRpiPim7q23WF5
        M202zJSvIEs5gXruJWQQbBAvOpSlgqayy0xkZGg/xAbrDyRqHlieQMNnoFln+N4CskdDMB39i3IB5
        X8vtyAMF8xviG6ipkCFC5UJq+UbxOtFjkFiUFdqhXd2YOE2jNpsohV+STa13Dts+lwdp9fXwUIt13
        CBCHuYlA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOlTK-008pvi-Mz; Mon, 28 Feb 2022 19:14:14 +0000
Date:   Mon, 28 Feb 2022 19:14:14 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        kirill@shutemov.name, hch@infradead.org
Subject: Re: + mm-export-pageheadhuge-fix.patch added to -mm tree
Message-ID: <Yh0fBip7UPo+dzci@casper.infradead.org>
References: <20220228184317.5759BC340F1@smtp.kernel.org>
 <2515942.1646075324@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2515942.1646075324@warthog.procyon.org.uk>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Feb 28, 2022 at 07:08:44PM +0000, David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > -EXPORT_SYMBOL(PageHeadHuge);
> > +EXPORT_SYMBOL_GPL(PageHeadHuge);
> 
> Does this mean that we're moving towards forbidding use of the pagecache in
> non-GPL drivers?  'Standard' bits of the folio API use this function
> implicitly.

Check out the definition of PageHuge() directly above.  Same usage in
pre-folio times.
