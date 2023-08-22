Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36C2EE49AB
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 18:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjHVStL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 14:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjHVStK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 14:49:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DBB10B
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 11:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AjxFPODvZFawZdqL9KxTCo1iPo/FAjjtYHWCDfEik9U=; b=gc6Yvfg5mMIjO9FhfSN9kfUqri
        Ry3V9/AbWEkXP2qunIfJNF6Egli6xS+yCgbMcPhok371eOs9fj2uOOJ5EWa+T2H5ESe/BlxHDxSZQ
        JY9qONp5pNHgxfsSm2+ZIGe6PD+e3s+CHDwTzA2FNdqHMQBLmfrdyJZwPGhhAXTAng/++op8RJEf5
        qSXOwvsM79yzyhCEelyW1h8HB0IB/txGas+jJY0g0tsrb5Mx5O2mqL6i3sK4VwiVWBtMYYIniXYsE
        Nc6KLcVvtNsWrNI4I1G0DS7Eh+D047pyLV5TFhHMHGJjUwOFTjO1phcTw3oPWvrJcA02TWbQMZrF5
        LvIu6LeQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qYWR9-000KXL-Cq; Tue, 22 Aug 2023 18:49:07 +0000
Date:   Tue, 22 Aug 2023 19:49:07 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        mjguzik@gmail.com
Subject: Re: +
 maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch added
 to mm-unstable branch
Message-ID: <ZOUDI/w51dJG7hOE@casper.infradead.org>
References: <20230822184454.D1B73C433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822184454.D1B73C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Aug 22, 2023 at 11:44:54AM -0700, Andrew Morton wrote:
> ------------------------------------------------------
> From: Mateusz Guzik <mjguzik@gmail.com>
> Subject: maple_tree: shrink struct maple_tree from 24 to 16 bytes on LP64
> Date: Tue, 22 Aug 2023 00:51:45 +0200
> 
> by plugging a padding hole.
> 
> Link: https://lkml.kernel.org/r/20230821225145.2169848-1-mjguzik@gmail.com
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Could we perhaps amend the commit log?

Subject: maple_tree: Shrink struct maple_tree

Pack the members of struct maple_tree to avoid holes on 64-bit.
The size shrinks from 24 to 16 bytes which will save eight bytes
in every structure which embeds it.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

