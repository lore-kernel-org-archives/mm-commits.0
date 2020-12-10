Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921B8C4361B
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 06:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5518A22D02
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 06:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbgLJGvq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Dec 2020 01:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732497AbgLJGvj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2020 01:51:39 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E3DC0613CF
        for <mm-commits@vger.kernel.org>; Wed,  9 Dec 2020 22:50:59 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id CA4D4C009; Thu, 10 Dec 2020 07:50:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1607583057; bh=1TKhmUlUZQd1UYXJLLXRbhC5h+78udzO+7HotZ8tdyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SyT25ECLaAP3ckMnJi1Vg8kHLLQm+GHOKI7OAP7L37w2g5Z//JToxmde3TUyWSRZ+
         LMinp8L+8TwyLuPYGvuaj5PyDfdJAMCyMClPUYHQcAzI+Zro6JLF84tbXf34pc2jdO
         TFPDsvaZF/6xrDWd/28+CdWwEOju8m6nCeDeX/vyoFzHPCNjG/YBFmxo+Adf7YbF9G
         DdGlbWBi0nrPs9xBfHMvGuZYoZwK9rnzOiHzq/sXV/n68gbzWeYhbyx0c9f3n/3dXH
         95QwiN2nPN4HT56MOpqkp4cDGkYmfWdebK2qBQ9bX8tfDSMMcXXW+pkOCjkpfM+dcP
         /4tuZnXFOox7A==
Date:   Thu, 10 Dec 2020 07:50:42 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, masahiroy@kernel.org
Subject: Re: + scripts-ld-versionsh-fix-build.patch added to -mm tree
Message-ID: <20201210065042.GB10169@nautica>
References: <20201210003853.J33XN%akpm@linux-foundation.org>
 <20201209184021.13c340d5b8e15b415f43b521@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201209184021.13c340d5b8e15b415f43b521@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew Morton wrote on Wed, Dec 09, 2020:
> > --- a/scripts/ld-version.sh~scripts-ld-versionsh-fix-build
> > +++ a/scripts/ld-version.sh
> > @@ -1,4 +1,4 @@
> > -#!/usr/bin/env -S awk -f
> > +#!/usr/bin/awk -f
> >  # SPDX-License-Identifier: GPL-2.0
> >  # extract linker version number from stdin and turn into single number
> >  	{
> 
> My /usr/bin/env is from coreutils-8.28-1ubuntu2

Yeah the patch should be dropped soon, I hadn't realised the option was
so new, sorry

A new version is under discussion that hopefully won't be as distruptive..

-- 
Dominique
