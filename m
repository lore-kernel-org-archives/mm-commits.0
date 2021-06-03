Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3CEC47082
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 12:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7705613F0
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 12:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhFCMM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229765AbhFCMM4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 08:12:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 250FC613E7;
        Thu,  3 Jun 2021 12:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622722255;
        bh=b6Wv+sTYF1XPgS/bhgG52tCpWt2MvBEtGeyq75utdfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ye6M8Fdft/5q29wI8JVZweZn/oGM1W2OyI02TSKFdjCIZP6xao86YDtD4hBPf7X9k
         Hvdz2378nBEEOPQGfCiultKHf+DCBMo8DfhJpexh9HvPAtgJvdfdnZd1x6mlY74XMw
         wf30IhzuF7DC76yKMIR+4KVbv+L76kti5fRbYGOM=
Date:   Thu, 3 Jun 2021 14:10:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eli Billauer <eli.billauer@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        broonie@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: mmotm 2021-06-01-19-57 uploaded (xillybus)
Message-ID: <YLjGzWmli7ZpP4O3@kroah.com>
References: <20210602025803.3TVVfGdaW%akpm@linux-foundation.org>
 <d880c052-e3e3-3af7-040d-7abdc97df1d1@infradead.org>
 <YLcQc0sHBaYViZIN@kroah.com>
 <60B8B189.6060404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60B8B189.6060404@gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jun 03, 2021 at 01:40:09PM +0300, Eli Billauer wrote:
> On 02/06/21 08:00, Greg Kroah-Hartman wrote:
> > > (on i386)
> > > >  >  CONFIG_XILLYBUS_CLASS=y
> > > >  CONFIG_XILLYBUS=m
> > > >  CONFIG_XILLYUSB=y
> > > >  >  ERROR: modpost: "xillybus_cleanup_chrdev"
> > > [drivers/char/xillybus/xillybus_core.ko] undefined!
> > > >  ERROR: modpost: "xillybus_init_chrdev" [drivers/char/xillybus/xillybus_core.ko] undefined!
> > > >  ERROR: modpost: "xillybus_find_inode" [drivers/char/xillybus/xillybus_core.ko] undefined!
> > > >  >  >  Full randconfig file is attached.
> > Sorry about that, I have a fix in my inbox for this that I will push out
> > later today...
> For the record, this is the said pending patch:
> 
> https://lkml.org/lkml/2021/5/28/245
> 
> I've tested this issue, and can confirm the compilation problem and that the
> patch fixes it.

Now queued up, thanks.

greg k-h
