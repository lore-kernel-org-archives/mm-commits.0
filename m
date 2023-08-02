Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE03C001DF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 17:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjHBRLJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjHBRLA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 13:11:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7756730E8
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 10:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4D0861949
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 17:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF36C433C7;
        Wed,  2 Aug 2023 17:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690996236;
        bh=ULe6PKfZ1MHqSq1Tmuu5xMDfhjqDe+4RMm07DXoWAzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tnCRcAd2WZKBORPWpFj8q71nHh+ewSgQgFMHwfl5mD5B3RlWQsvNGjXL5r6MCgDdd
         4trHb9qdW35FZ8MZvJtK/Qza2xlkWPaCFpBZERZRbA/FtmoKtRQGFQk8713/5iX4x8
         yxKTu7+Kn33JEBmJJRtLg24LhL/9+J71i1YEUrk0=
Date:   Wed, 2 Aug 2023 10:10:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Kemeng Shi <shikemeng@huaweicloud.com>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org,
        shikemeng@huawei.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com
Subject: Re: +
 mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.p
 atch added to mm-unstable branch
Message-Id: <20230802101035.9fc9442a1d4b449462f2f257@linux-foundation.org>
In-Reply-To: <2912c26f-7a7f-f08d-4e54-50eb793c2cb3@huaweicloud.com>
References: <20230801191357.F0A8BC433C7@smtp.kernel.org>
        <2912c26f-7a7f-f08d-4e54-50eb793c2cb3@huaweicloud.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 2 Aug 2023 15:56:43 +0800 Kemeng Shi <shikemeng@huaweicloud.com> wrote:

> Hi Andrew, sorry for bother. As Baolin menthioned in [1], no real issue will be triggered
> after change in commit 9fcd6d2e052ee ("mm, compaction: skip compound pages by order in free
> scanner"), this patch is not needed indeed. But other patches seems fine, is it OK for you
> to drop this one or should I send a v2 series with this dropped.

It seems that a new series would be best, thanks.
