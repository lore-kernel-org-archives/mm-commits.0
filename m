Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9339C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 02:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8170423D20
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 02:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgLJClE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:41:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbgLJClE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 21:41:04 -0500
Date:   Wed, 9 Dec 2020 18:40:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607568023;
        bh=885TQ2O9/BsQY33AeXk3pK2HTCIOdRtdB+ch631RgOE=;
        h=From:To:Subject:In-Reply-To:References:From;
        b=Zeoe6xnM3MUN+pD6KyY9z8KIaTiLY5wIsE5lc+MMdy/wulGwQTnzHASTicR7wS44w
         Quz1NuOUfYjFQYlpC2T7g34DniMQ8Ug+jxL0ZQCOsOV8XUrpzU2GzgllHURz4o+0Mb
         gl/USQfkUhoMkSN8gWDLYel73UGicsywV0b4PIk8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, masahiroy@kernel.org,
        asmadeus@codewreck.org
Subject: Re: + scripts-ld-versionsh-fix-build.patch added to -mm tree
Message-Id: <20201209184021.13c340d5b8e15b415f43b521@linux-foundation.org>
In-Reply-To: <20201210003853.J33XN%akpm@linux-foundation.org>
References: <20201210003853.J33XN%akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 09 Dec 2020 16:38:53 -0800 akpm@linux-foundation.org wrote:

> i386:
> 
> X1:/usr/src/25> make allmodconfig
> /usr/bin/env: invalid option -- 'S'
> Try '/usr/bin/env --help' for more information.
> init/Kconfig:39: syntax error
> init/Kconfig:38: invalid statement
> 
> ...
>
> --- a/scripts/ld-version.sh~scripts-ld-versionsh-fix-build
> +++ a/scripts/ld-version.sh
> @@ -1,4 +1,4 @@
> -#!/usr/bin/env -S awk -f
> +#!/usr/bin/awk -f
>  # SPDX-License-Identifier: GPL-2.0
>  # extract linker version number from stdin and turn into single number
>  	{

My /usr/bin/env is from coreutils-8.28-1ubuntu2
