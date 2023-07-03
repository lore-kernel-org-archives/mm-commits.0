Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA17FEB64D9
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 00:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjGCAJw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 20:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGCAJv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 20:09:51 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D051B7
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:09:50 -0700 (PDT)
Received: from fsav311.sakura.ne.jp (fsav311.sakura.ne.jp [153.120.85.142])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 36309lrH026535;
        Mon, 3 Jul 2023 09:09:47 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav311.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp);
 Mon, 03 Jul 2023 09:09:47 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 36309lAT026532
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Jul 2023 09:09:47 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <b8c61ac6-220a-fb08-90a6-d14ff7754ab9@I-love.SAKURA.ne.jp>
Date:   Mon, 3 Jul 2023 09:09:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: +
 mm-page_alloc-use-write_seqlock_irqsave-instead-write_seqlock-local_irq_save.patch
 added to mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>, bigeasy@linutronix.de,
        pmladek@suse.com
References: <20230702234049.DCE06C433C8@smtp.kernel.org>
Cc:     will@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, mhocko@suse.com, mgorman@techsingularity.net,
        longman@redhat.com, lgoncalv@redhat.com, john.ogness@linutronix.de,
        david@redhat.com, boqun.feng@gmail.com, mm-commits@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20230702234049.DCE06C433C8@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Nacked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

because of https://lkml.kernel.org/r/a1c559b7-335e-5401-d167-301c5b1cd312@I-love.SAKURA.ne.jp .

On 2023/07/03 8:40, Andrew Morton wrote:
> The patch titled
>      Subject: mm/page_alloc: use write_seqlock_irqsave() instead write_seqlock() + local_irq_save().
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-page_alloc-use-write_seqlock_irqsave-instead-write_seqlock-local_irq_save.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-write_seqlock_irqsave-instead-write_seqlock-local_irq_save.patch
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

