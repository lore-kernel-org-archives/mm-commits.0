Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C69DC25B0C
	for <mm-commits@archiver.kernel.org>; Sun,  7 Aug 2022 20:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiHGUL3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 7 Aug 2022 16:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiHGUL1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 7 Aug 2022 16:11:27 -0400
Received: from polaris.svanheule.net (polaris.svanheule.net [IPv6:2a00:c98:2060:a004:1::200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BC15FBA
        for <mm-commits@vger.kernel.org>; Sun,  7 Aug 2022 13:11:26 -0700 (PDT)
Received: from [IPv6:2a02:a03f:eaf9:8401:aa9f:5d01:1b2a:e3cd] (unknown [IPv6:2a02:a03f:eaf9:8401:aa9f:5d01:1b2a:e3cd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id 32325307CA8;
        Sun,  7 Aug 2022 22:11:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1659903085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymDkx+JldOv/GZk0PGEetSEs66nYGiv9dNyw1yHkQkA=;
        b=i6qoBe5uS4o90uIM5oc5NYx48rQkiJ+SZuNCfSHaEs8fwZ6MMuiC92BqPs0P/zJCe3TouZ
        g1erSf78m4PWqQrYM+/311l7rUMNolHrD10hQeCBUcDbHI/QH/JcSMGaLMCSxZPqwpTCAs
        N4wYZSv4UbLxMRlJfeYXw3bwLavDe/WLd3ZtGpFyIjJA9ywZmoisvDWFNV4oR14T8LkNJj
        ut0ZwJfAgm9NcaZYoyW2hdvEn3fr7aaLnmN8uTXxt7lZWd2HDVLbZ7Zgl2gN2vwy+b9s0h
        5aK/VF4DKYQSaRiY2sTkqiMWtSJvAnXl6vculfVjnPLWGKIT4hCxisq7QAUWcw==
Message-ID: <9b191d64cc5285eebda1ccf24241bae30c128961.camel@svanheule.net>
Subject: Re: [GIT PULL] MM updates for 5.20-rc1
From:   Sander Vanheule <sander@svanheule.net>
To:     Yury Norov <yury.norov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        linux-mm@kvack.org
Date:   Sun, 07 Aug 2022 22:11:23 +0200
In-Reply-To: <Yu9KPCxGYUUROdlC@yury-laptop>
References: <Yu9KPCxGYUUROdlC@yury-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Yury, Andrew,

On Sat, 2022-08-06 at 22:14 -0700, Yury Norov wrote:
> Hi Andrew,
>=20
> > Sander Vanheule (5):
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 x86/cacheinfo: move shared cache map def=
initions
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpumask: add UP optimised for_each_*_cpu=
 versions
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpumask: Fix invalid uniprocessor mask a=
ssumption
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lib/test: introduce cpumask KUnit test s=
uite
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpumask: update cpumask_next_wrap() sign=
ature
>=20
> I think, Sander has a new version for this:
>=20
> https://lore.kernel.org/all/YuV1J7Zt+NzkrWeV@yury-laptop/T/#ma2d7613315f3=
31fac83d8bd5ae22ef740945569ao

Looks like v4 was merged with the non-MM updates:

https://lore.kernel.org/all/165989506499.6057.14827201987918707189.pr-track=
er-bot@kernel.org/

I'll have to write a follow-up to cover the v4/v5 differences, since there =
were
still some significant changes.

Best,
Sander
