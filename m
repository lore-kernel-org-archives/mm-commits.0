Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D82C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCD0820707
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598401828;
	bh=ixCG2vKnHUn3IXKUemQTz8B4pSBTiPhOEAgVHjKggTU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:List-ID:
	 From;
	b=MvqWmmo05RP5kTiFilnCqb4eQAwAd9UO4CQEKe6fJTlllZisDP0pHLwmRkJXOV0oE
	 t2SgvgtOG+1Ij1crND/JDfVSe1W30XPKRsXsHLOz2dXEcv9XlIPetc/TEvxp79X5j0
	 1xy5aaeLx4l331o333fWuIUbEstmkLrSndMttZfU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgHZAaW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgHZAaW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:30:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83AFE20707;
        Wed, 26 Aug 2020 00:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598401821;
        bh=ixCG2vKnHUn3IXKUemQTz8B4pSBTiPhOEAgVHjKggTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sGSZuBhDppBOsRS01Xmh/8Wc/SwSYNn/+uSEEE4szFdERhtlnYGqMKE96lSfC+292
         rwmE+pZMBkuyaW27fgSVA4arPDf9E0VDZaaoq9eMPX1g3LjpaxYbDuA+yit8R8Peol
         I3qAlzhzzjsnSVQyeoxmq9OUF+OuzkuW1EJk9rz0=
Date:   Tue, 25 Aug 2020 17:30:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Oscar Salvador <osalvador@suse.de>
Cc:     broonie@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: mmotm 2020-08-24-16-06 uploaded
Message-Id: <20200825173021.fcf20a4f3043ed5d5b4ac3b5@linux-foundation.org>
In-Reply-To: <20200825084543.GA16605@linux>
References: <20200824230725.8gXQoJFD-%akpm@linux-foundation.org>
        <20200825084543.GA16605@linux>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 25 Aug 2020 10:45:48 +0200 Oscar Salvador <osalvador@suse.de> wrote:

> On Mon, Aug 24, 2020 at 04:07:25PM -0700, akpm@linux-foundation.org wrote:
> > A full copy of the full kernel tree with the linux-next and mmotm patches
> > already applied is available through git within an hour of the mmotm
> > release.  Individual mmotm releases are tagged.  The master branch always
> > points to the latest release, so it's constantly rebasing.
> > 
> > 	https://github.com/hnaz/linux-mm
> 
> Is it me or this is out of sync?
> 

Seems that way.  Maybe Johannes's script needs a new battery?
