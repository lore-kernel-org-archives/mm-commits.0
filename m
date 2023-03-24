Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D7FC6FD1C
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 18:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjCXSw0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjCXSwW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 14:52:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FACA9EDF
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 11:52:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56E2FB825E1
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 18:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86695C433EF;
        Fri, 24 Mar 2023 18:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679683938;
        bh=sk9phskm/TcePFgfuSFlvzVsoIsb1JCUIFd8IL+elgU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fLfXNrs4ywFfAzgPuKZ1CHDfCIY0JQmP2FKakRgTGQXJQpl7WipCK7zRvw8zefUJT
         cJ0a0pEYQSUctPAthU1xSYVAYnfoA16FuDBoKtLBcSMyTnGmDgESECiyKQRQ6+JI97
         BRm54DgT1ZNoOWLvscK9hHXnud8GxaIatA48X944=
Date:   Fri, 24 Mar 2023 11:52:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        robin.murphy@arm.com, quic_pkondeti@quicinc.com,
        mark.rutland@arm.com, jianyong.wu@arm.com, james.morse@arm.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, quic_zhenhuah@quicinc.com
Subject: Re: +
 mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch
 added to mm-unstable branch
Message-Id: <20230324115216.fd75af1ef4c95e16c34aa57b@linux-foundation.org>
In-Reply-To: <20230324173040.GA27948@willie-the-truck>
References: <20230317190042.32FC0C4339C@smtp.kernel.org>
        <20230324173040.GA27948@willie-the-truck>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 24 Mar 2023 17:30:41 +0000 Will Deacon <will@kernel.org> wrote:

> Hi Andrew,
> 
> On Fri, Mar 17, 2023 at 12:00:41PM -0700, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: mm,kfence: decouple kfence from page granularity mapping judgement
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch
> 
> Do you mind if I pick this one up via -arm64? It's pretty much all arch
> changes, and I'd like to avoid any cross-tree conflicts in the mm/ code
> if possible.
> 

Sure, go for it.
