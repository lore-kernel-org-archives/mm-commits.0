Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD41C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 10:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348612AbiDZKRb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 06:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348680AbiDZKRE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 06:17:04 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6A46D3BF;
        Tue, 26 Apr 2022 02:40:37 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1njHg0-006xZ5-JA; Tue, 26 Apr 2022 19:40:10 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Apr 2022 17:40:08 +0800
Date:   Tue, 26 Apr 2022 17:40:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Conor.Dooley@microchip.com
Cc:     rdunlap@infradead.org, sfr@canb.auug.org.au,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-crypto@vger.kernel.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, mm-commits@vger.kernel.org,
        linux-next@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2022-04-25-17-59 uploaded
 (drivers/char/hw_random/mpfs-rng.c)
Message-ID: <Yme9+HuB2N3KOMf+@gondor.apana.org.au>
References: <20220426005932.848CBC385A4@smtp.kernel.org>
 <6ff380c5-4f2c-44ea-2541-b32733e45ac3@infradead.org>
 <191e32d7-efde-327e-b112-000d8f778996@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <191e32d7-efde-327e-b112-000d8f778996@microchip.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Apr 26, 2022 at 06:36:27AM +0000, Conor.Dooley@microchip.com wrote:
>
> @Herbert, would you rather revert the part of 6a71277ce91e that enables
> compile test or I can send a patch for the stubbed versions now that
> there is a user for them? (My preference would be to keep COMPILE_TEST)

I'll just revert that patch because it turns out the underlying
option already supports COMPILE_TEST so this is redundant.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
