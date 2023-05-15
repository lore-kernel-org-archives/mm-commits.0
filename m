Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09B6C77B7D
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 09:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240720AbjEOJxy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 05:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240713AbjEOJxR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 05:53:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDA3E7A
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 02:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4671B61128
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 09:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B86C433D2;
        Mon, 15 May 2023 09:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684144384;
        bh=iHsDgeaOaKVhiyRLW9EgJ6wT4O1+YgdPVCO2Vu+CNFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W2Cautz6ztp18RokXZ8bgxDdfdTDHeNjc6PfDyHIq2REzI/E7OcTXJkLONMKz8FVq
         LWRbhKk3BFBoi0F5/75OB/eZQZ8FZm9Rsk7DUXmqsk+Egu8DD6S/nt+LqwVWqLsVvo
         dGWNHfYzeZ8sktYrkLYY0n39Tio7xMfPh1CDfT6MDPXhHxFV1HK6nnYO8k6iSyRnm1
         RvGbY9rkvSsHdQRZ0s76Gv9K8QRNlNo3nQ6YJfX4Jhk0+U1lSE5RIieAZv6rs5BnIv
         8lNhCJ8uLu282rbRj953stM9hF4ngSYlk8Jt7h7gaDASEmojjDu7f0Ca7R7QeRydlQ
         Ut/d/nOF8pXUw==
Date:   Mon, 15 May 2023 10:52:59 +0100
From:   Lee Jones <lee@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, conor.dooley@microchip.com,
        lukas.bulwahn@gmail.com
Subject: Re: +
 maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch added to
 mm-hotfixes-unstable branch
Message-ID: <20230515095259.GF8963@google.com>
References: <20230512235702.13A05C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230512235702.13A05C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 12 May 2023, Andrew Morton wrote:

> 
> The patch titled
>      Subject: MAINTAINERS: repair pattern in DIALOG SEMICONDUCTOR DRIVERS
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Subject: MAINTAINERS: repair pattern in DIALOG SEMICONDUCTOR DRIVERS
> Date: Tue, 9 May 2023 09:48:34 +0200
> 
> Commit 361104b05684c ("dt-bindings: mfd: Convert da9063 to yaml") converts
> da9063.txt to dlg,da9063.yaml and adds a new file pattern in MAINTAINERS. 
> Unfortunately, the file pattern matches da90*.yaml, but the yaml file is
> prefixed with dlg,da90.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken file pattern.
> 
> Repair this file pattern in DIALOG SEMICONDUCTOR DRIVERS.
> 
> Link: https://lkml.kernel.org/r/20230509074834.21521-1-lukas.bulwahn@gmail.com
> Fixes: 361104b05684c ("dt-bindings: mfd: Convert da9063 to yaml")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Cc: Lee Jones <lee@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/MAINTAINERS~maintainers-repair-pattern-in-dialog-semiconductor-drivers
> +++ a/MAINTAINERS
> @@ -6019,7 +6019,7 @@ W:	http://www.dialog-semiconductor.com/p
>  F:	Documentation/devicetree/bindings/input/da90??-onkey.txt
>  F:	Documentation/devicetree/bindings/input/dlg,da72??.txt
>  F:	Documentation/devicetree/bindings/mfd/da90*.txt
> -F:	Documentation/devicetree/bindings/mfd/da90*.yaml
> +F:	Documentation/devicetree/bindings/mfd/dlg,da90*.yaml

Lukas, please submit MFD related changes for me to at least review in
future please.

>  F:	Documentation/devicetree/bindings/regulator/dlg,da9*.yaml
>  F:	Documentation/devicetree/bindings/regulator/da92*.txt
>  F:	Documentation/devicetree/bindings/regulator/slg51000.txt
> _
> 
> Patches currently in -mm which might be from lukas.bulwahn@gmail.com are
> 
> maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch
> 

-- 
Lee Jones [李琼斯]
