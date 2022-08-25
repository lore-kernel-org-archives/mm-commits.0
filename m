Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA11AC04AA5
	for <mm-commits@archiver.kernel.org>; Thu, 25 Aug 2022 00:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiHYAes (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 20:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiHYAer (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 20:34:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A78713B
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 17:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA9FF618F4
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 00:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2375C433D7;
        Thu, 25 Aug 2022 00:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661387683;
        bh=ILzuyv7qLWJ0Ecv2ge5Dlk9avRE3IuYnxXKkEIHZm04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A9femYOjB5TnxboUTjyzSwuOt2qA2ePHLBFgwTTsEjFDMiQJVmpdvJY9cfhYt7vu7
         9g4unse37yQOzHTp3f3uArsJA/H365scFbb/CV+ZIlgIALgmU9R5QGfiwZu5fKzdDl
         COwbU0x7msMF0RDyCffmUTw3EvfgwwN0iZ9C/CDY=
Date:   Wed, 24 Aug 2022 17:34:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     mm-commits@vger.kernel.org
Subject: Re: + mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
 added to mm-unstable branch
Message-Id: <20220824173442.3e1ef843cc48fb26ba89a513@linux-foundation.org>
In-Reply-To: <87sfllf9il.fsf@nvdebian.thelocal>
References: <20220824211152.ECB61C433C1@smtp.kernel.org>
        <87sfllf9il.fsf@nvdebian.thelocal>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 25 Aug 2022 10:29:56 +1000 Alistair Popple <apopple@nvidia.com> wrote:

> Ugh. Thanks Andrew, and sorry for missing this. As this is mm-unstable
> is the expected process that I should send a new version of the original
> series with this fix?

Nope, I'll fold the fix into the base patch before moving into mm-stable.
