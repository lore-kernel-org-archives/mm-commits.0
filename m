Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD837C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 05:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EEBA611C8
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 05:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhISFv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 01:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhISFv0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 19 Sep 2021 01:51:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EB3C061757
        for <mm-commits@vger.kernel.org>; Sat, 18 Sep 2021 22:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E3rd3KADJWQAhsyRplis+MnRXcN0aH9q8GGj5fGIDLI=; b=qltiX7BqihdZf7GQs/ju5BOdky
        wMsmBDJEWOmlAS7IrwZnaoW/888bXPb7V54Xhw101O0Dul3r7hCm74OhhCVz+VtWKuKgBKrtnpRZu
        GAk1p2dEraxztuxa2s4oHrj3npZPjP4451Iz4+usDOZjKzKzugVZeIwmGX4T5dJLEmxxRBH3gUsBn
        7GRfkO2T/KXeLVk2aVbyGZN0G1HWMS7OMAkwqd1HnvzNuNqo2MCV06tY93Dhwq8vLSEOBs0cPJz8E
        NN1noLNqx6nbqUnBPCUX/R0xqP376uEE8oA9SMa1yBR+HYcARVlPNbTiFXHbxErlzaFdKyb8GHbQw
        mobI4RQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mRpgs-001f7i-Fr; Sun, 19 Sep 2021 05:48:43 +0000
Date:   Sun, 19 Sep 2021 06:48:38 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     akpm@linux-foundation.org
Cc:     davem@davemloft.net, horms@verge.net.au, kuba@kernel.org,
        liumh1@shanghaitech.edu.cn, marcelo.leitner@gmail.com,
        mm-commits@vger.kernel.org, pshelar@ovn.org,
        ulf.hansson@linaro.org, vyasevich@gmail.com
Subject: Re: +
 include-linux-mmh-move-nr_free_buffer_pages-from-swaph-to-mmh.patch added to
 -mm tree
Message-ID: <YUbPNoDr/YHNDy4l@casper.infradead.org>
References: <20210915033747.w8w89QJxl%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915033747.w8w89QJxl%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 14, 2021 at 08:37:47PM -0700, akpm@linux-foundation.org wrote:
> ------------------------------------------------------
> From: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> Subject: include/linux/mm.h: move nr_free_buffer_pages from swap.h to mm.h
> 
> nr_free_buffer_pages could be exposed through mm.h instead of swap.h.  The
> advantage of this change is that it can reduce the obsolete includes.  For
> example, net/ipv4/tcp.c wouldn't need swap.h any more since it has already
> included mm.h.  Similarly, after checking all the other files, it comes
> that tcp.c, udp.c meter.c ,...  follow the same rule, so these files can
> have swap.h removed too.
> 
> Moreover, after preprocessing all the files that use nr_free_buffer_pages,
> it turns out that those files have already included mm.h.Thus, we can move
> nr_free_buffer_pages from swap.h to mm.h safely.  This change will not
> affect the compilation of other files.

i don't think that moving more crap into mm.h is an improvement.
if anything, we should be moving more things out of mm.h.
