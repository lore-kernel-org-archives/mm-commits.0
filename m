Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41603C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 01:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbiFQBWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 21:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiFQBWe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 21:22:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC81AEA2
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 972D0B8268D
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 01:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C0EC34114;
        Fri, 17 Jun 2022 01:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655428948;
        bh=85a2vn6BhWeinNV4nEuN55af6ttKXR2CJtcrRXW3cb8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=17dC9DZGFSUPajVRkech+D7NjjKKxSwtfObCJMsyqlhPuW4ATETecITGgbbfqm+Vn
         vtB6JjzkAFQP1MB4+bR8txXj7vLylOu8lQFnEXpff2igtkfYWfWqtWMu0Nh58NQ1+e
         z/xOalIRMwB4baKBhdAq2wNLTMiShRgluSXLDg/I=
Date:   Thu, 16 Jun 2022 18:22:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jaewon31.kim@samsung.com
Cc:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        YongTaek Lee <ytk.lee@samsung.com>,
        Sooyong Suk <s.suk@samsung.com>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "avromanov@sberdevices.ru" <avromanov@sberdevices.ru>
Subject: Re: [to-be-updated]
 zram_drv-add-__gfp_nomemalloc-not-to-use-alloc_no_watermarks.patch removed
 from -mm tree
Message-Id: <20220616182227.c3a06b11a90657120585216b@linux-foundation.org>
In-Reply-To: <20220617010432epcms1p348c725abef40bfd539cc29c82a64f6ef@epcms1p3>
References: <20220608192933.5279DC34116@smtp.kernel.org>
        <CGME20220608192938epcas1p3eb403705cf57aa56be63a19423bbae8c@epcms1p3>
        <20220617010432epcms1p348c725abef40bfd539cc29c82a64f6ef@epcms1p3>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 17 Jun 2022 10:04:32 +0900 Jaewon Kim <jaewon31.kim@samsung.com> wr=
ote:

> Dear Andrew Morton
>=20
> Sorry to bother you
> But I'm confused about the following dropped to be merged thing.
> Can I just wait or I should give up that patch?
>=20
> ...
>
> This=A0patch=A0was=A0dropped=A0because=A0an=A0updated=A0version=A0will=A0=
be=A0merged

The (somewhat confusing) discussion with Minchan led me to believe that
an alternative solution would be implemented.

