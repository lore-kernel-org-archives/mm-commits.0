Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA82BC54EED
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 22:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjAXWg3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 17:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjAXWg3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 17:36:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19361658E
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 14:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=udVLjl6Su50OKg2e41HQMcVVtK0XIDEhXfTSB98WnGw=; b=aoFHHZhOxKfFKaJt6iuTzIKdAo
        zY6zKy2YivdM9zYoFxKVGizSf0t3ejnvIrNZXE6+pQKeUpD5wuf3zY9xkV3F/oa9ZZsMv9DDSTjcx
        hJuZESnA6qU16ElN20vyUSH4NCt4Rmi8Q+GB+DOPhoPeVGKIIAy8bTuk1yFRtJNJhMkHGV+ggMJN0
        oAq+sdA+rtsl+KSJHao5vjYqUeSl0QgU5EoYn6DJp1rSDqUrOsRSYFPj/oA4ODqRqeCNKaD9Ak3mu
        Biq8qwLdaX2fXoWgjUvOr5DTBZT/HM8prLw8xiOrSBKFwyfx47roo9tSSJyU65GIjwJ4MjduCnrhr
        k2Ha5ZaA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKRt0-005POG-Sx; Tue, 24 Jan 2023 22:35:26 +0000
Date:   Tue, 24 Jan 2023 22:35:26 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vishal.moola@gmail.com
Subject: Re: + mm-add-folio_estimated_mapcount.patch added to mm-unstable
 branch
Message-ID: <Y9BdLvx1hOhdSqrs@casper.infradead.org>
References: <20230124215305.23B14C433D2@smtp.kernel.org>
 <Y9BT/uHMeP/3ytht@casper.infradead.org>
 <20230124141527.e095c02a748056d00af8e536@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124141527.e095c02a748056d00af8e536@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jan 24, 2023 at 02:15:27PM -0800, Andrew Morton wrote:
> On Tue, 24 Jan 2023 21:56:14 +0000 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Tue, Jan 24, 2023 at 01:53:04PM -0800, Andrew Morton wrote:
> > > 
> > > The patch titled
> > >      Subject: mm: add folio_estimated_mapcount()
> > > has been added to the -mm mm-unstable branch.  Its filename is
> > >      mm-add-folio_estimated_mapcount.patch
> > 
> > Um, there was a build breakage report from one of the bots on this
> > patch.  Probably better to hold off on this series for now.
> 
> It was only arch/alpha ;)  Presumably the usual header file
> mess.  

I predict there will be more ;-)  page_pfn() / pfn_page() is dangerous
(and in this case, hidden).
