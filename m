Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55174C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 19:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286062333E
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 19:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbhAITQl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 9 Jan 2021 14:16:41 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:46429 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbhAITQl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 9 Jan 2021 14:16:41 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jan 2021 14:16:41 EST
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id C70EC1EE6;
        Sat,  9 Jan 2021 14:08:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 09 Jan 2021 14:08:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Xm1wgm
        CCn5HiUfvWFYOhn69kG0VEvNVf0OXYNLAhVIM=; b=hvyToIQpVC+B3EV7AkG+o3
        oOqM8HPbruuUGJOSzTLiX7XLnza/X9xP5hfgLfto41DHW/6t2PkTeqFqfA3+6kwr
        DKY+2+ZOqMNLUDZQA35La/8yLuz9Ze37+giA39i9eVKzCTSSbuauXNwGSyp2bF1C
        O7yU+Cd3pTx9N+BMOt5o2CwtIeongCKOl9dJ8pzLH7xmuCu2agYdhv84+ova5MQT
        bUtllC+n5HBJekc9evWVg3CLsEZ0NYakTifrTw5YllSo5ey8bWQGaLc08RwTr+HN
        oo+ip3X1w7xQjB2w/0VzaiJcioOZfhnuCROTWRaZ6R01uDQiSw0TFqcd6+vUL+Rw
        ==
X-ME-Sender: <xms:P__5X_65nJ5kVOp2k5bY-ofKBp-DQunY-3yLEn77Zp02bHDhPOm_7A>
    <xme:P__5X06B81lWTXZyNIScW0pFDDJ741MhlwtmmCjnlitUqTZed5IllR0KvEJQSVYk9
    kSGoHsIDqL_2-UA1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegjedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefrvghkkhgrucfgnhgsvghrghcuoehpvghnsggvrhhgsehi
    khhirdhfiheqnecuggftrfgrthhtvghrnheptdevveffgfffhedvtdeuheeiuedufeeige
    euhfekheduhffgtdetgfduueeuhfejnecuffhomhgrihhnpehoiihlrggsshdrohhrghdp
    khgvrhhnvghlrdhorhhgnecukfhppeeivddrjeekrddujeelrddufedunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepphgvnhgsvghrghesihhk
    ihdrfhhi
X-ME-Proxy: <xmx:P__5X2d6IuI6MpTnffqvbsDZjYOxJwy6JMz_hxXWcaGQajOHQMWKtw>
    <xmx:P__5XwIUfrBVmVd91f4Y7cX9sqmEQTC9Fmy94AHHPpwmStSjDD69kQ>
    <xmx:P__5XzIVxNXq0-KZ0yEGfEPQQI0XRYdYJFr5qxIc2wan4q6H402aDA>
    <xmx:Qf_5XwGNl3IFW8L1xeo-FZpTaCjRv06jpn6XVjqB4c6owojc1bXwLvxFm-U>
Received: from localhost (62-78-179-131.bb.dnainternet.fi [62.78.179.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF6BC1080059;
        Sat,  9 Jan 2021 14:08:46 -0500 (EST)
Date:   Sat, 9 Jan 2021 21:08:45 +0200
From:   Pekka Enberg <penberg@iki.fi>
To:     akpm@linux-foundation.org
Cc:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject: Re: + maintainers-add-myself-as-slab-allocators-maintainer.patch
 added to -mm tree
Message-ID: <20210109190845.GA3514837@nero>
References: <20210109005352.MHc5FVVKk%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109005352.MHc5FVVKk%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jan 08, 2021 at 04:53:52PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: MAINTAINERS: add Vlastimil as slab allocators maintainer
> has been added to the -mm tree.  Its filename is
>      maintainers-add-myself-as-slab-allocators-maintainer.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-myself-as-slab-allocators-maintainer.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-myself-as-slab-allocators-maintainer.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Vlastimil Babka <vbabka@suse.cz>
> Subject: MAINTAINERS: add Vlastimil as slab allocators maintainer
> 
> I would like to help with slab allocators maintenance, from the
> perspective of being responsible for SLAB and more recently also SLUB in
> an enterprise distro kernel and supporting its users.  Recently I've been
> focusing on improving SLUB's debugging features, and patch review in the
> area, including the kmemcg accounting rewrite last year.
> 
> Link: https://lkml.kernel.org/r/20210108110353.19971-1-vbabka@suse.cz
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
