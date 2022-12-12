Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4463AC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 22:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiLLWQ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Dec 2022 17:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiLLWQz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2022 17:16:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF771ADA5;
        Mon, 12 Dec 2022 14:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23317B80E81;
        Mon, 12 Dec 2022 22:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291EBC433F1;
        Mon, 12 Dec 2022 22:16:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Q+Rfj5ew"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670883405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7KeoIAPwed+d+SzN4UkTZwHoxhIIXfI6f+Yf3pSqxKA=;
        b=Q+Rfj5ewra5XXnQpyA7n+18Qu2K2ZugC7OkRrwFah5fQMsg8ftMud2ZGE9HZa2tJEhIMSX
        F82tmd3j74afr/gIeQuIMtlDng477nNYzda8gL+fY7cbSOiBoCi2uAL2Vs3Yj76atFQiVg
        +pyicwHyodR7MdlR7e1bpzIRmfbFGek=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c9e2c4e0 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 12 Dec 2022 22:16:44 +0000 (UTC)
Date:   Mon, 12 Dec 2022 15:16:43 -0700
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] non-MM commits for 6.2-rc1
Message-ID: <Y5eoS/UfBhovR70j@zx2c4.com>
References: <20221212134425.b20b80955e5e8a4a36ce1b9a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221212134425.b20b80955e5e8a4a36ce1b9a@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 12, 2022 at 01:44:25PM -0800, Andrew Morton wrote:
>       wifi: rt2x00: use explicitly signed or unsigned types

Why is this part of your PULL? This was a netdev/wireless tree fix which
was in 6.1-rc5. Kalle wrote that he took it on 21 Oct 2022 in:
https://lore.kernel.org/all/166633563389.6242.13987912613257140089.kvalo@kernel.org/

Jason
