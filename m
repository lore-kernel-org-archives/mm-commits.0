Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90721C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347438AbiFCSrV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347971AbiFCSrU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:47:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365B612D3D
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39A7AB8246B
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 18:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2927C385A9;
        Fri,  3 Jun 2022 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654282033;
        bh=ZqmWpMON2La4AkhnaZYYPTTbXBJITq7joCD5diDZx3E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iosQHxbTQMxzUk+rCAODaK5VYxcalppZDjEIOQK2pqLB3OhuEFYj4eSaQipqBtY2a
         +LdWrYtwyZ2d17cp5CQEUf5IdqRUfEUkjEjaINrrUtcNKPEMP6eV0Swj8UQjMIiuMM
         Gm0s8H0UnFt7dRyo256fUwz3RBMs+AWRa2Qidsaw=
Date:   Fri, 3 Jun 2022 11:47:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: + xarray-replace-kernelh-with-the-necessary-inclusions.patch
 added to mm-nonmm-unstable branch
Message-Id: <20220603114712.da849292ea89f5c956967c54@linux-foundation.org>
In-Reply-To: <YppWoUnSxCUljVpS@casper.infradead.org>
References: <20220603183231.15159C385A9@smtp.kernel.org>
        <YppWoUnSxCUljVpS@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 3 Jun 2022 19:44:49 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Jun 03, 2022 at 11:32:30AM -0700, Andrew Morton wrote:
> > ------------------------------------------------------
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Subject: include/linux/xarray.h: replace kernel.h with the necessary inclusions
> > Date: Fri, 3 Jun 2022 20:11:53 +0300
> > 
> > When kernel.h is used in the headers it adds a lot into dependency hell,
> > especially when there are circular dependencies are involved.
> > 
> > Replace kernel.h inclusion with the list of what is really being used.
> > 
> > Link: https://lkml.kernel.org/r/20220603171153.48928-1-andriy.shevchenko@linux.intel.com
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> NAK, breaks the test suite.

The test suite compiled OK for me?
