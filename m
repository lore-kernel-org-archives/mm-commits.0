Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE153C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 12:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbiDYMmZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 08:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiDYMmZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 08:42:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4901B1A9C
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 05:39:21 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650890360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rytu/Ro7RTKr+m6epUnnU5W6eoQHe57+9qxRIK+DI+o=;
        b=rxaTgjm0uL+2ma7XYE8eOOyO4IhpuovIKk//oFnC5xZMDFFx/w2UmganUMl4eHioChofQ3
        7E/ftZPH8M+dOjwX4bLZ72bkH8gaMpeUB0vw0oN7xxL08pLIV30Aetxtp/tkH71Uu1ObB8
        RpvWZooewVkgT2Df3aQZkUVOZCcrvJbtE0hox8H4K7CqVuNMpdjZ+jWTgElYA9fmXnsrqp
        /JIkPF0M9dNGG2Ohwr80yYCb9ClNA/j8xPkXiWyaz50yjrVQzyEg2UbeR2pt0e4jNDm0d8
        m4sb3DUcjbRwudn/Z8yg3cPqPRVHyoMBqcIB+pVlWAJRVpugcpPsHJCCjKunXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650890360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rytu/Ro7RTKr+m6epUnnU5W6eoQHe57+9qxRIK+DI+o=;
        b=PqkfqN3d66U0WfWXD3As+tI0X5a5GL/xk3ghtr9E3MvFFKuddIgea2RKq9/M2UFqlzetI1
        iATBCdgix4ajwnBA==
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, sboyd@kernel.org,
        john.stultz@linaro.org, wangqing@vivo.com,
        akpm@linux-foundation.org
Subject: Re: +
 timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch
 added to -mm tree
In-Reply-To: <20220422203732.C76E7C385A0@smtp.kernel.org>
References: <20220422203732.C76E7C385A0@smtp.kernel.org>
Date:   Mon, 25 Apr 2022 14:39:20 +0200
Message-ID: <87v8ux1gnb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 22 2022 at 13:37, Andrew Morton wrote:
> From: Wang Qing <wangqing@vivo.com>
> Subject: timekeeping: use time_is_before_jiffies() instead of open coding it
>
> Use the helper function time_is_{before,after}_jiffies() to improve code
> readability.
>
> Link: https://lkml.kernel.org/r/1650621172-66967-10-git-send-email-wangqing@vivo.com
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/time/timekeeping.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/kernel/time/timekeeping.c~timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it
> +++ a/kernel/time/timekeeping.c
> @@ -216,7 +216,7 @@ static void timekeeping_check_update(str
>  	}
>  
>  	if (tk->underflow_seen) {
> -		if (jiffies - tk->last_warning > WARNING_FREQ) {
> +		if (time_is_before_jiffies(tk->last_warning + WARNING_FREQ)) {

I have a hard time to see how this improves anything. The least thing it
improves is readability.

Yeah, I know some script told so....

Thanks,

        tglx


