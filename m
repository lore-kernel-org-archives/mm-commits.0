Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4773C54EED
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 22:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbjAXWPa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 17:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbjAXWP3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 17:15:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF29C22787
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 14:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ADF66136C
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 22:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A2CC4339B;
        Tue, 24 Jan 2023 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674598527;
        bh=HKU4GpeoIA9EMAXhgOXIDPqcY8WjZQbxpBgxOnwWLsY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TpKXI1bW14RXPxk7MGB3Pokggtswtf5gblCDBj5Os57QFeEYzmspK9iyoThtxpZCS
         GXUAdlTkgw3YUzRhUyZvR7SoiKLZmQTYGdFThwsa8N08ppRSkpGX/cZXaAnU4bvr9k
         1WrYCogf0/ZtjcsSfAMxA9iRiRLudzL7IhcWhMYw=
Date:   Tue, 24 Jan 2023 14:15:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, vishal.moola@gmail.com
Subject: Re: + mm-add-folio_estimated_mapcount.patch added to mm-unstable
 branch
Message-Id: <20230124141527.e095c02a748056d00af8e536@linux-foundation.org>
In-Reply-To: <Y9BT/uHMeP/3ytht@casper.infradead.org>
References: <20230124215305.23B14C433D2@smtp.kernel.org>
        <Y9BT/uHMeP/3ytht@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 24 Jan 2023 21:56:14 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Tue, Jan 24, 2023 at 01:53:04PM -0800, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: mm: add folio_estimated_mapcount()
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-add-folio_estimated_mapcount.patch
> 
> Um, there was a build breakage report from one of the bots on this
> patch.  Probably better to hold off on this series for now.

It was only arch/alpha ;)  Presumably the usual header file
mess.  
