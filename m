Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A138C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 05:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiBVF1E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 00:27:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiBVF0n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 00:26:43 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD86145E35
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 21:26:18 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 61DCC210F2;
        Tue, 22 Feb 2022 05:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645507577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vaxo7sdF6/v7pEDMLphMVKhtK/feeKeNlhIGIfy/LlI=;
        b=fTUHCbDPJyJ9N4DT9kXVNYh2te+Od0HV2hCQmDeGolVsLd5bVEPs3cnFZ2nvBFRhgTEJul
        yMeRxL1KJm6xrYzyZEFCuw9AEyJc4TS49o9q9zH6rP9YUuKJThUcxM3/NGeqF8X9bsT4Sy
        uh0wM9vGBHFE9w+kEx/LIlqM6xn8yl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645507577;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vaxo7sdF6/v7pEDMLphMVKhtK/feeKeNlhIGIfy/LlI=;
        b=wBvHkP3y8GGHUuuO1Z1ydvuCD94LTKiXsNX+WkEgs9wvRw+dyszh0v9eSfb59ENOEmRSCk
        RhItEC1dtZ6vS/Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4CE6213BB5;
        Tue, 22 Feb 2022 05:26:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9c4lEvlzFGKJfQAAMHmgww
        (envelope-from <osalvador@suse.de>); Tue, 22 Feb 2022 05:26:17 +0000
MIME-Version: 1.0
Date:   Tue, 22 Feb 2022 06:26:17 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        raquini@redhat.com, mhocko@kernel.org, dennis@kernel.org,
        david@redhat.com, dave.hansen@linux.intel.com, amakhalov@vmware.com
Subject: Re: + arch-x86-mm-numa-do-not-initialize-nodes-twice.patch added to
 -mm tree
In-Reply-To: <20220222044907.E14EAC340E8@smtp.kernel.org>
References: <20220222044907.E14EAC340E8@smtp.kernel.org>
User-Agent: Roundcube Webmail
Message-ID: <c3ce79948c9aadbe036e11447f06712d@suse.de>
X-Sender: osalvador@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022-02-22 05:49, Andrew Morton wrote:
> The patch titled
>      Subject: arch/x86/mm/numa: Do not initialize nodes twice
> has been added to the -mm tree.  Its filename is
>      arch-x86-mm-numa-do-not-initialize-nodes-twice.patch

Hi Andrew,

A new v2, addressing some feedback from Michal, was already posted 
yesterday [1].
So you might want to drop this one and add that one instead.

Thanks

[1] 
https://lore.kernel.org/linux-mm/20220221142649.3457-1-osalvador@suse.de/T/#u

-- 
Oscar Salvador
SUSE Labs
