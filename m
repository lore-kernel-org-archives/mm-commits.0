Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A29C47087
	for <mm-commits@archiver.kernel.org>; Fri, 28 May 2021 08:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 575C5613E5
	for <mm-commits@archiver.kernel.org>; Fri, 28 May 2021 08:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhE1IrZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 May 2021 04:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhE1IrZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 28 May 2021 04:47:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EA9961278;
        Fri, 28 May 2021 08:45:50 +0000 (UTC)
Date:   Fri, 28 May 2021 09:45:48 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     sh_def@163.com, mm-commits@vger.kernel.org, linuxarm@openeuler.org,
        linuxarm@huawei.com
Subject: Re: [PATCH v2] mm,kmemleak-test: add the dependency on CONFIG_SAMPLES
Message-ID: <20210528084547.GA1371@arm.com>
References: <1622168190-16160-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622168190-16160-1-git-send-email-chenxiang66@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 28, 2021 at 10:16:30AM +0800, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> As kmemleak-test.c is moved to samples dir, it is not compiled if just
> setting CONFIG_DEBUG_KMEMLEAK_TEST as module and enabling
> CONFIG_DEBUG_KMEMLEAK.
> So move the DEBUG_KMEMLEAK_TEST option to samples dir as well and rename 
> it to SAMPLE_KMEMLEAK_TEST. And also replace DEBUG_KMEMLEAK_TEST with
> SAMPLE_KMEMLEAK_TEST in some other places.
> 
> Fixes: 1abbef4f5172 ("mm,kmemleak-test.c: move kmemleak-test.c to samples dir")
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
