Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAE6C77B73
	for <mm-commits@archiver.kernel.org>; Tue, 23 May 2023 00:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjEWAYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 May 2023 20:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbjEWAIw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2023 20:08:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1F61BD4;
        Mon, 22 May 2023 16:45:43 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1684799141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HNfvfTxVOpl2K7qMYcvndQ8gy3p44IHcsFiRmQKaTzc=;
        b=AFvydX8NJEymHuWzFxfZPZFv1ztDvPqouBElKX2Y7HF7iCDAiERXHOwkVkF5EX4fNoDdk+
        y6ZsOKNdJwnB5FxVei1rtl28M44xGqLVdo6qQB2+MLe6SL2nK2Tb1Lktz5cnZ8jEvdDeQW
        c/Bm3osSWyib/Ey2M3cKvru0cHjUEIXrm1oTQvP180tA1MGaG4NxSqYFnuP6CXi6IF5kWw
        Z1msuSNyTRwL247v233o36LHj7hPLUgGtCjchX3834Y1utR8DeYQyzNMtnmVBEmHAFVJof
        YRgB/H5phw/CCaOWjlqoLIZukt6xLEjfMIdgtPMoNwm5GSfVe9pMSijrIZJCgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1684799141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HNfvfTxVOpl2K7qMYcvndQ8gy3p44IHcsFiRmQKaTzc=;
        b=cq3/O47bFWXIcQtQ6qHObwfC10gVJqO6ukQjwSI4IYk+yhQ7bNJnCfWUa60G6WCLuOJAAx
        SCgZ8RV9vWB0vjBw==
To:     linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        adobriyan@gmail.com, akpm@linux-foundation.org
Subject: Re: + fix-mult_frac-multiple-argument-evaluation-bug.patch added to
 mm-nonmm-unstable branch
In-Reply-To: <20230522211514.E0037C4339C@smtp.kernel.org>
References: <20230522211514.E0037C4339C@smtp.kernel.org>
Date:   Tue, 23 May 2023 01:45:40 +0200
Message-ID: <87ttw4udzv.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, May 22 2023 at 14:15, Andrew Morton wrote:
> ------------------------------------------------------
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Subject: include/linux/math.h: fix mult_frac() multiple argument evaluation bug
> Date: Sat, 20 May 2023 21:25:19 +0300
>
> mult_frac() evaluates _all_ arguments multiple times in the body.

I'm not opposed to the patch, but to the description.

Multiple evaluation is not a bug per se.

Unless there is a reasonable explanation for the alleged bug this is
just a cosmetic exercise.

Changelogs have to be self explanatory and if the shortlog, aka
$subject, claims "bug" then there has to be a reasonable explanation
what the actual bug is.

Seriously.

All this is documented, but obviously documention for changelogs and the
acceptance of patches is just there to be ignored, right?

Thanks,

        tglx
