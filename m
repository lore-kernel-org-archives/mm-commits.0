Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC0FC6FD1C
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 17:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjCXRau (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 13:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCXRat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 13:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C15AF12
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 10:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56C3C62BFE
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 17:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3AFC433EF;
        Fri, 24 Mar 2023 17:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679679047;
        bh=D3YNAp6FdGWUGCJQVtW0iJZ7jA4Ys0zRQ+mfGC6eiic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lWXfbAD8tspGM2fcCbyMzdOQGzCsnV1X6jNyovY4jKpGj2D/BB1wUcbnGh20nevlh
         JPLGPbBKNYgBYbSNMLn3R92g8Qem8qzhewrM017j/mA4LeDiWv7eh5SfnP7e9Kk0jv
         b+JFxEHRqWIRHvMrkwvLUB4pflShTjNBx4DE2pIY1myDRDzOfdeV7PTDaX3TkQHpHN
         t3OOpx7QHyJnl7oGmMnyLKRGdJ4IjD79VfqXDN0xzcnE7fyXEuc7QJ3kEsJeT5h5/b
         cU+1p6z307OcRylOopfG+lqxXipZdSuwdi78DufKR+oa8MHAWiRRvINyxYdnQyksBy
         fuTrlV1wWuByw==
Date:   Fri, 24 Mar 2023 17:30:41 +0000
From:   Will Deacon <will@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        robin.murphy@arm.com, quic_pkondeti@quicinc.com,
        mark.rutland@arm.com, jianyong.wu@arm.com, james.morse@arm.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, quic_zhenhuah@quicinc.com
Subject: Re: +
 mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch added
 to mm-unstable branch
Message-ID: <20230324173040.GA27948@willie-the-truck>
References: <20230317190042.32FC0C4339C@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317190042.32FC0C4339C@smtp.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On Fri, Mar 17, 2023 at 12:00:41PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm,kfence: decouple kfence from page granularity mapping judgement
> has been added to the -mm mm-unstable branch.  Its filename is
>      mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmkfence-decouple-kfence-from-page-granularity-mapping-judgement.patch

Do you mind if I pick this one up via -arm64? It's pretty much all arch
changes, and I'd like to avoid any cross-tree conflicts in the mm/ code
if possible.

Cheers,

Will
