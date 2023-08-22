Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D79EE4993
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 19:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjHVTdw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjHVTdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 15:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66796128
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 12:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F10A760C54
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 19:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29117C433C8;
        Tue, 22 Aug 2023 19:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692732829;
        bh=BNUFT15+bdKzt3V4J+yRP1/SGvTnkZz3QhvGMw6E3hY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G5PnOMcYkEq6N8NXY1Sz0tXoD6k9hVccBN9/juLJMR4QxOru55k+GaWTR0h3b69DR
         77n/Tx1R/ZAznyYI4Gc+ysZJ9Ccn8RAO05jAHGhh1z6PUjRc+waB0mDkLJxUzvSMHW
         CZoKeBIEw1nIXvTOlN7C+/GUvr50f+n/qvggj0gU=
Date:   Tue, 22 Aug 2023 12:33:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        mjguzik@gmail.com
Subject: Re: +
 maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch added
 to mm-unstable branch
Message-Id: <20230822123348.04ac05336b7e81740f1dfeaa@linux-foundation.org>
In-Reply-To: <ZOUDI/w51dJG7hOE@casper.infradead.org>
References: <20230822184454.D1B73C433C7@smtp.kernel.org>
        <ZOUDI/w51dJG7hOE@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 22 Aug 2023 19:49:07 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> Subject: maple_tree: Shrink struct maple_tree
> 
> Pack the members of struct maple_tree to avoid holes on 64-bit.
> The size shrinks from 24 to 16 bytes which will save eight bytes
> in every structure which embeds it.
> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

added, thanks.
