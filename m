Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02D1C00528
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jul 2023 02:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjGTChb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 22:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjGTCha (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 22:37:30 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC032109
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:37:26 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id D880F761071;
        Thu, 20 Jul 2023 02:28:15 +0000 (UTC)
Received: from pdx1-sub0-mail-a313.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 041027607F4;
        Thu, 20 Jul 2023 02:28:14 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1689820095; a=rsa-sha256;
        cv=none;
        b=rXJUFosB2MpLD86AdsOJE5Cbtskqb4RLymgCXkjgBVYwRNTGvyVlJJcb4T5WJQgLGWkdOZ
        /fGJfOwysUyFBKV6Bnal0HuQRvdxsY45yAUGG6/ycmHC5oKAZY/9VmzNS0hrbSM/9wqog4
        ZokwHpwUgz930+I3iuctuEBStz6YFcmT87rIsGFZ7Af3yy7vO7p2X6InS+cdIGcl8JL77U
        DpNy+1VKia0UVjTn2E03nUu7FYUgh7ZmmlnhY1MnJ6l7YN/kOnoubDT3PLKwp8IefI/93P
        AKw/cRR2CEZE/9wyKDDP/xLK/70eI2teZO+f7DXam8LYMPBiEZ+02m3rPK8JDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1689820095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=0lqCSfm5b53euVX7myOo9DZ79cCHk6C2ogOLPxRHUZI=;
        b=X5j+YczfYeA3ExnleqCI00Uc3WtJp9yJDvjaQxkeaOGVQdYTZoj7088Zuhh0cEaJWGkSz2
        9IbXw5kwieAPUIjxBEnZHxTEHrMZCB7StzRRVUo/OWbr2Q0BcFn37tTGjfiHZsQ/AwBrqA
        svSvzs1GjtifvfpieoFhO4cWPhyachnQr9592Ei9Yrh0yCmkSIbjdHtT+RLewwvmnLBCpO
        4/scTdt0dJ/OIUfyh2Breo/RzrBsbgGOvER4vDjbQcww731j5/YflpnLBijXAjeXNSHd5m
        dbUAFDQ7A9c7X9N0DRs6AMX1kobAYywHQT2aO3UXdvVnzNgYMSVjzlct4t7CAQ==
ARC-Authentication-Results: i=1;
        rspamd-965c5b9-2tbml;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Bottle-Befitting: 553d9bb72375246b_1689820095302_2352490082
X-MC-Loop-Signature: 1689820095302:3066224139
X-MC-Ingress-Time: 1689820095302
Received: from pdx1-sub0-mail-a313.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.120.163.38 (trex/6.9.1);
        Thu, 20 Jul 2023 02:28:15 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a313.dreamhost.com (Postfix) with ESMTPSA id 4R5xSG1ccxz6n;
        Wed, 19 Jul 2023 19:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1689820094;
        bh=0lqCSfm5b53euVX7myOo9DZ79cCHk6C2ogOLPxRHUZI=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=H0fslQ6KIJRvh3H46qDbuo13gw3Wk98qCYQKx2cZjmSg+6UHMDHhTyWP74MS+1yXZ
         2HeW30pM27vQ4ffJHVktNYEYKOoZ/v3TSuj6bja/K59CCdrYQ5yJt4RJ91VCAEUBmG
         WANWn2NwlSzyRgXB/JNMI0dhGueCNw8w3E35mSoTa3Llz1JfIlwo6zu7uJATfmTw4Z
         aBqZiReiXOGjkaEjuzuzTxV2ORDI2ShexcbV5eM9yoQUeWd7qkY+ALd/YdozoemxUM
         ZSHsfoO0rxSmmBu1ZOzMj7AhLD06+JN+GP+H7f2RSa45aI23kCY1KxnILi1+R9Pw0x
         3uJM6Y1BCCVcw==
Date:   Wed, 19 Jul 2023 18:51:24 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, manfred@colorfullife.com,
        jannh@google.com, christophe.jaillet@wanadoo.fr
Subject: Re: + ipc-sem-use-flexible-array-in-struct-sem_undo.patch added to
 mm-nonmm-unstable branch
Message-ID: <ilxexxtr2t2xkt57ml3vjgrybth5dl2sat6gv6axjbyaheqftg@4jx2zib7ufxa>
References: <20230710203557.2BBB0C433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230710203557.2BBB0C433C8@smtp.kernel.org>
User-Agent: NeoMutt/20230517
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 10 Jul 2023, Andrew Morton wrote:

>
>The patch titled
>     Subject: ipc/sem: use flexible array in 'struct sem_undo'
>has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>     ipc-sem-use-flexible-array-in-struct-sem_undo.patch
>
>This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-sem-use-flexible-array-in-struct-sem_undo.patch
>
>This patch will later appear in the mm-nonmm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
>The -mm tree is included into linux-next via the mm-everything
>branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>and is updated there every 2-3 working days
>
>------------------------------------------------------
>From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>Subject: ipc/sem: use flexible array in 'struct sem_undo'
>Date: Sun, 9 Jul 2023 18:12:55 +0200
>
>Turn 'semadj' in 'struct sem_undo' into a flexible array.
>
>The advantages are:
>   - save the size of a pointer when the new undo structure is allocated
>   - avoid some always ugly pointer arithmetic to get the address of semadj
>   - avoid an indirection when the array is accessed
>
>While at it, use struct_size() to compute the size of the new undo
>structure.
>
>Link: https://lkml.kernel.org/r/1ba993d443ad7e16ac2b1902adab1f05ebdfa454.1688918791.git.christophe.jaillet@wanadoo.fr
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>Cc: Jann Horn <jannh@google.com>
>Cc: Manfred Spraul <manfred@colorfullife.com>
>Cc: Davidlohr Bueso <dave@stgolabs.net>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
