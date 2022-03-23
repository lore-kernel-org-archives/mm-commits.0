Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB2DC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 14:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiCWOsg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 10:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbiCWOsg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 10:48:36 -0400
X-Greylist: delayed 1386 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Mar 2022 07:47:06 PDT
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199F781645
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 07:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:Cc:
        References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=c+ExfHopgW16KW/FrpCo9RgoUoNpsP1qcv+Xhy92Gl4=; b=K1NXUzDG4LODFazFaaQmzB5fTg
        A2fKXD0zoV+1PBxbpaudEJodhb6274vF0eosjPZjkPdJCN2LrpsDWUaL8LdtlytAs4FYX+YD8nkza
        M4jQavXza6oDEnV2tjXFEfju8S2rCazhFpWl6IFMwxMUH1JHCjL+PLKNsz9vkzvEjJv27wy78u+wu
        Ikh1qciSFfPZAvGKgpIsIQQleK6TkYWA721QgyEmpwi/blhxLtGDRqO3020q0kPCbdJ0OjbL0nPdA
        7ap73/SZNcRqt4//PudAcwCEyOWxVhywYCK+yJKae3FA4pZL2s8OuQ81s011odf71VrurZC5/ggKi
        JFblVPmQ==;
Received: from [187.39.124.208] (helo=[192.168.0.110])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nX1tx-0005Fj-00; Wed, 23 Mar 2022 15:23:53 +0100
Message-ID: <6a5bbbfd-3071-20dd-80b9-0e3bda3122ce@igalia.com>
Date:   Wed, 23 Mar 2022 11:23:39 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: + panic-move-panic_print-before-kmsg-dumpers.patch added to -mm
 tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
References: <20220228185002.EF7D1C340F1@smtp.kernel.org>
Cc:     mm-commits@vger.kernel.org, bhe@redhat.com, feng.tang@intel.com,
        pmladek@suse.com, senozhatsky@chromium.org
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220228185002.EF7D1C340F1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 28/02/2022 15:50, Andrew Morton wrote:
> The patch titled
>      Subject: panic: move panic_print before kmsg dumpers
> has been added to the -mm tree.  Its filename is
>      panic-move-panic_print-before-kmsg-dumpers.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/panic-move-panic_print-before-kmsg-dumpers.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/panic-move-panic_print-before-kmsg-dumpers.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 

Hi Andrew, I'd like to ask you if it's possible to merge this patch (and
also [0]) for 5.18. I've checked Linus tree as for today and it's not
there, I hope there is still time.

Thanks in advance,


Guilherme


[0]
https://ozlabs.org/~akpm/mmotm/broken-out/panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch
