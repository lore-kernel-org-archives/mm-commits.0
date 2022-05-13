Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04F4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 01:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376367AbiEMBb1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 21:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355338AbiEMBb0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 21:31:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F54B59086
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 18:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB00D620D0
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 01:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B12C385B8;
        Fri, 13 May 2022 01:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652405482;
        bh=3uobRtPDqBvGtqFAwoKOd7FeSfjwYpuT1kcYAvNqVsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ze1G4Oguonr1BWuJlD7oG5xi55EUmqNjPyxuejK+OxD02WhC5Y/GkmhT/iiu1OUJp
         E9typCFg3E2MCaPJhw5tFJPRrBePxjfP4SwzmYSrXvsADFiKWQPc3bG9+I2ZkMG5k9
         kiExuff9NYvOaRso7tActWXY/6n+QlWmU0oj9feE=
Date:   Thu, 12 May 2022 18:31:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        rf@opensource.cirrus.com, pmladek@suse.com, jvgediya@linux.ibm.com,
        Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
        andy.shevchenko@gmail.com, adobriyan@gmail.com
Subject: Re: + mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch
 added to mm-unstable branch
Message-Id: <20220512183120.c1c7e83c504d208d5f20f00e@linux-foundation.org>
In-Reply-To: <Yn2xlvFZelucTEVD@casper.infradead.org>
References: <20220513010543.707FEC34113@smtp.kernel.org>
        <Yn2xlvFZelucTEVD@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 13 May 2022 02:17:10 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Thu, May 12, 2022 at 06:05:42PM -0700, Andrew Morton wrote:
> >  {
> > -	if (kstrtobool(buf, &numa_demotion_enabled))
> > -		return -EINVAL;
> > +	ssize_t ret;
> > +
> > +	ret = kstrtobool(buf, &numa_demotion_enabled);
> > +		return ret;
> 
> Umm ... missing if?

doh, thanks.
