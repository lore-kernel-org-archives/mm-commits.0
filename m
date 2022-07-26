Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9B5C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jul 2022 11:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbiGZLbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiGZLbk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 07:31:40 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E6F2873B
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 04:31:40 -0700 (PDT)
Received: from fsav118.sakura.ne.jp (fsav118.sakura.ne.jp [27.133.134.245])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26QBVHaw054373;
        Tue, 26 Jul 2022 20:31:17 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav118.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp);
 Tue, 26 Jul 2022 20:31:17 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26QBVHmF054370
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 26 Jul 2022 20:31:17 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <ac3a7af1-08c6-e2de-b93c-327ce6839830@I-love.SAKURA.ne.jp>
Date:   Tue, 26 Jul 2022 20:31:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: + mm-memcontrol-fix-potential-oom_lock-recursion-deadlock.patch
 added to mm-unstable branch
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     mm-commits@vger.kernel.org,
        syzbot+2d2aeadc6ce1e1f11d45@syzkaller.appspotmail.com,
        shakeelb@google.com, roman.gushchin@linux.dev, hannes@cmpxchg.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20220725220032.B4C30C341C8@smtp.kernel.org>
 <Yt+iWGnA06DjsHz9@dhcp22.suse.cz>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <Yt+iWGnA06DjsHz9@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022/07/26 17:14, Michal Hocko wrote:
> As we have concluded there are two issues possible here which would be
> great to have reflected in the changelog.
> 
> On Mon 25-07-22 15:00:32, Andrew Morton wrote:
>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Subject: mm: memcontrol: fix potential oom_lock recursion deadlock
>> Date: Fri, 22 Jul 2022 19:45:39 +0900
>>
>> syzbot is reporting GFP_KERNEL allocation with oom_lock held when
>> reporting memcg OOM [1].  Such allocation request might deadlock the
>> system, for __alloc_pages_may_oom() cannot invoke global OOM killer due to
>> oom_lock being already held by the caller.
> 
> I would phrase it like this:

This report is difficult to explain correctly.

> syzbot is reporting GFP_KERNEL allocation with oom_lock held when
> reporting memcg OOM [1].

Correct. But

>                          This is problematic because this creates a
> dependency between GFP_NOFS and GFP_KERNEL over oom_lock which could
> dead lock the system.

oom_lock is irrelevant when trying GFP_KERNEL allocation from GFP_NOFS
context. Therefore, something like:

----------
syzbot is reporting GFP_KERNEL allocation with oom_lock held when
reporting memcg OOM [1]. If this allocation triggers the global OOM
situation then the system can livelock because the GFP_KERNEL allocation
with oom_lock held cannot trigger the global OOM killer because
__alloc_pages_may_oom() fails to hold oom_lock.

Fix this problem by removing the allocation from memory_stat_format()
completely, and pass static buffer when calling from memcg OOM path.

Note that the caller holding filesystem lock was the trigger for syzbot
to report this locking dependency. Doing GFP_KERNEL allocation with
filesystem lock held can deadlock the system even without involving OOM
situation.
----------

