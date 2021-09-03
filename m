Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617DEC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 07:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B7360F9C
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 07:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347516AbhICHE4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 03:04:56 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48152 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347087AbhICHE4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2021 03:04:56 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 17FA9221B3;
        Fri,  3 Sep 2021 07:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630652636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CAm+yUedEll3+jHg2E06Q7Z+88FC6ohCxlncYCLEcyU=;
        b=WefZjKOf+O9R18/jcRSs0PCVxvgnLWzPaWetD+9iY5KHvqGVrllQ2zFCDS/X2C/HPjQUIt
        xP8nj1eNCPObzunyJPHy+wZNQPLahb3L8S87J0gO1EjTtStUrdMhM9IxdSc4yaFTpWADKC
        LztSCUNKtOWVXRm2EMQ1qBuKdydQoPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630652636;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CAm+yUedEll3+jHg2E06Q7Z+88FC6ohCxlncYCLEcyU=;
        b=NS/PJbwHl+g9xNqobzNEW8v9Xcwt2keS7cA5ECHqmnDtRtq6MMAl00aV6ZIL7zGOJPSPKU
        0fztORjoehoRFgDg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id AD260136BF;
        Fri,  3 Sep 2021 07:03:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id M8n3KNvIMWFgXAAAGKfGzw
        (envelope-from <vbabka@suse.cz>); Fri, 03 Sep 2021 07:03:55 +0000
Message-ID: <4d2bdf47-618e-40cd-d7c2-4a06a4b28335@suse.cz>
Date:   Fri, 3 Sep 2021 09:03:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [patch 036/212] mm, slab: make flush_slab() possible to call with
 irqs enabled
Content-Language: en-US
To:     Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
 <20210902215152.ibWfL_bvd%akpm@linux-foundation.org>
 <CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ@mail.gmail.com>
 <CAHk-=wiz+vp1k1Ag+fD57P4ehOpTAc=A9zT7YbGENUu57azeuQ@mail.gmail.com>
 <CAHk-=wiX77e3G-cOP+OLPzf8krQXgyiz7PikurJYa0fsDhS34Q@mail.gmail.com>
 <ec75906a-bf4d-cad0-dd66-cdf2b7d35b1e@suse.cz>
 <d406ebb42fb9914d1a6f2fe9f26bf083612ec796.camel@gmx.de>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <d406ebb42fb9914d1a6f2fe9f26bf083612ec796.camel@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 9/3/21 08:22, Mike Galbraith wrote:
>> > so that when you read that function on its own, it's clear that the
>> > lock is always held over that critical section - and the issue is that
>> > perhaps the lock was already taken by the caller.
>> 
>> Actually that "already taken" becomes "caller does not need it/can't

Meant to say "... later in the series becomes ...".

>> even take the local lock as it's not local" (it's a cpu hot remove
>> handler on behalf of another, dead cpu).
>> 
>> So would it work with something like the following cleanup on top later
>> after proper testing? (now just compile tested).
> 
> To my eyeballs, below duplication of a couple lines of initialization
> needed by the lockless function is less icky than the double return.

Yeah, that's better, thanks Mike.
