Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA63C7EE23
	for <mm-commits@archiver.kernel.org>; Tue, 23 May 2023 13:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbjEWNOO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 May 2023 09:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbjEWNON (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 May 2023 09:14:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B252B11F
        for <mm-commits@vger.kernel.org>; Tue, 23 May 2023 06:14:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 363532198D;
        Tue, 23 May 2023 13:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1684847647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w7qBFlZCpnNGt4E0ztDvgfltEZq89/t1KMHfJKVt4TU=;
        b=e7SVSV5Twjcr90KSb9I2+Nc3t0Mc2vbqOkDkoIYaHx5Pg8P6J1kkEb6S20ZockwDbLwrhg
        qWluGSqCWoTOrmmQbqrsnyQWoVp7whigWdsLltGBc46zFmu/z++D8QIM5MC/p9UfTFXosN
        zAqmffJiySTrgHbl7rz/EALQmrUPFU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1684847647;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w7qBFlZCpnNGt4E0ztDvgfltEZq89/t1KMHfJKVt4TU=;
        b=WJKKmpcTqpgBALSnaOjDF2ieGWoFAnPBmYe3t1bdZxp1PIcPJ8+40Ut6fjOsG8gncavC+N
        zpSeSTRx6nQcc3Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E75213A10;
        Tue, 23 May 2023 13:14:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NYjPBh+8bGQDQAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 23 May 2023 13:14:07 +0000
Message-ID: <0b58a843-26a4-1b77-9e4e-8bbabec99ce5@suse.cz>
Date:   Tue, 23 May 2023 15:14:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: + mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
 added to mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, rppt@kernel.org, lstoakes@gmail.com,
        liam.howlett@oracle.com
References: <20230522205623.C13ABC433D2@smtp.kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230522205623.C13ABC433D2@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 5/22/23 22:56, Andrew Morton wrote:
> The patch titled
>      Subject: mm/mlock: rename mlock_future_check() to mlock_future_ok()
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
> 
> This patch will later appear in the mm-unstable branch at
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/mlock: rename mlock_future_check() to mlock_future_ok()
> Date: Mon May 22 01:52:10 PM PDT 2023
> 
> It is felt that the name mlock_future_check() is vague - it doesn't
> particularly convey the function's operation.  mlock_future_ok() is a
> clearer name for a predicate function.
> 
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <lstoakes@gmail.com>
> Cc: Mike Rapoport (IBM) <rppt@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

