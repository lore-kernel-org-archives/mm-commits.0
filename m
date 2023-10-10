Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 451E0CD98CA
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 22:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjJJWUi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 18:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjJJWUh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 18:20:37 -0400
X-Greylist: delayed 309 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Oct 2023 15:20:35 PDT
Received: from out-191.mta0.migadu.com (out-191.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182278F
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 15:20:34 -0700 (PDT)
Date:   Tue, 10 Oct 2023 15:15:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696976124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fMOrH7Sx+hPKZAEnH9jiqGcpCwPpn3/by071li49tCg=;
        b=ajH+tnF2syS0zFZHCkXGslvrFhbe3eZVEwADhH0RTmUr5RJquC2VBzdg0gLqQNlO0rkH5i
        uHnWZCUgHR62HSejjKUPjqJwSqHVU2JGY/OxPier5ZwYnNTypSbnPVKvDNW47S/HtdJB3O
        XwaYlmh54BPbc8/U2OiOW2eZfb73mHs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org
Subject: Re: + mm-kmem-add-direct-objcg-pointer-to-task_struct.patch added to
 mm-unstable branch
Message-ID: <ZSXM50e0iYOhm306@P9FQF9L96D.corp.robot.car>
References: <20231010182008.5441AC433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010182008.5441AC433C7@smtp.kernel.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Oct 10, 2023 at 11:20:00AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: kmem: add direct objcg pointer to task_struct
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
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
> From: Roman Gushchin <roman.gushchin@linux.dev>
> Subject: mm: kmem: add direct objcg pointer to task_struct
> Date: Mon, 9 Oct 2023 17:09:26 -0700
> 
> To charge a freshly allocated kernel object to a memory cgroup, the kernel
> needs to obtain an objcg pointer.  Currently it does it indirectly by
> obtaining the memcg pointer first and then calling to
> __get_obj_cgroup_from_memcg().
> 
> Usually tasks spend their entire life belonging to the same object cgroup.
> So it makes sense to save the objcg pointer on task_struct directly, so
> it can be obtained faster.  It requires some work on fork, exit and cgroup
> migrate paths, but these paths are way colder.
> 
> To avoid any costly synchronization the following rules are applied:
> 1) A task sets it's objcg pointer itself.
> 
> 2) If a task is being migrated to another cgroup, the least
>    significant bit of the objcg pointer is set atomically.
> 
> 3) On the allocation path the objcg pointer is obtained locklessly
>    using the READ_ONCE() macro and the least significant bit is
>    checked. If it's set, the following procedure is used to update
>    it locklessly:
>        - task->objcg is zeroed using cmpxcg
>        - new objcg pointer is obtained
>        - task->objcg is updated using try_cmpxchg
>        - operation is repeated if try_cmpxcg fails
>    It guarantees that no updates will be lost if task migration
>    is racing against objcg pointer update. It also allows to keep
>    both read and write paths fully lockless.
> 
> Because the task is keeping a reference to the objcg, it can't go away
> while the task is alive.
> 
> This commit doesn't change the way the remote memcg charging works.
> 
> Link: https://lkml.kernel.org/r/20231010000929.450702-3-roman.gushchin@linux.dev
> Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Andrew, can you, please, add
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
here?

Thanks!
