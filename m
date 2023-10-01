Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE85E748F6
	for <mm-commits@archiver.kernel.org>; Sun,  1 Oct 2023 16:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbjJAQwf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Oct 2023 12:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbjJAQwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 1 Oct 2023 12:52:35 -0400
X-Greylist: delayed 566 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 01 Oct 2023 09:52:31 PDT
Received: from out-196.mta1.migadu.com (out-196.mta1.migadu.com [IPv6:2001:41d0:203:375::c4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94C4C6
        for <mm-commits@vger.kernel.org>; Sun,  1 Oct 2023 09:52:31 -0700 (PDT)
Date:   Sun, 1 Oct 2023 09:42:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696178580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EAi9eSgMjQ5ZALDGCBbLWFL0Blz/OIA6LU7+Q6jhV9I=;
        b=Q03R1GN9GYOBBs5vxxO9GGkKM8Et4spEwhIePS7Ch3gkArwW8Mwv5rfbY/CxmLYvWodoHY
        uyfuWl5HDsvVEAg2NJeuHtpiDmYYWg2vuXnxrkQWmCda5AeBaznVz9Fir9Y492c5l5m0dy
        Pp0ZkIeFTGN4QpWwUmf9aBmJjkZg8ao=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, dennis@kernel.org
Subject: Re: + mm-kmem-add-direct-objcg-pointer-to-task_struct.patch added to
 mm-unstable branch
Message-ID: <ZRmhjpGvKIdGj162@P9FQF9L96D.lan>
References: <20230929184249.8F34FC433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929184249.8F34FC433C8@smtp.kernel.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 29, 2023 at 11:42:48AM -0700, Andrew Morton wrote:
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
> Date: Fri, 29 Sep 2023 11:00:52 -0700
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
> Link: https://lkml.kernel.org/r/20230929180056.1122002-3-roman.gushchin@linux.dev
> Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/memcontrol.h |   10 +++
>  include/linux/sched.h      |    4 +
>  mm/memcontrol.c            |  111 ++++++++++++++++++++++++++++++++---
>  3 files changed, 116 insertions(+), 9 deletions(-)
> 
> --- a/include/linux/memcontrol.h~mm-kmem-add-direct-objcg-pointer-to-task_struct
> +++ a/include/linux/memcontrol.h
> @@ -544,6 +544,16 @@ static inline bool folio_memcg_kmem(stru
>  	return folio->memcg_data & MEMCG_DATA_KMEM;
>  }
>  
> +static inline bool current_objcg_needs_update(struct obj_cgroup *objcg)
> +{
> +	return (struct obj_cgroup *)((unsigned long)objcg & 0x1);
> +}
> +
> +static inline struct obj_cgroup *
> +current_objcg_without_update_flag(struct obj_cgroup *objcg)
> +{
> +	return (struct obj_cgroup *)((unsigned long)objcg & ~0x1);
> +}
>  
>  #else
>  static inline bool folio_memcg_kmem(struct folio *folio)
> --- a/include/linux/sched.h~mm-kmem-add-direct-objcg-pointer-to-task_struct
> +++ a/include/linux/sched.h
> @@ -1443,6 +1443,10 @@ struct task_struct {
>  	struct mem_cgroup		*active_memcg;
>  #endif
>  
> +#ifdef CONFIG_MEMCG_KMEM
> +	struct obj_cgroup		*objcg;
> +#endif
> +
>  #ifdef CONFIG_BLK_CGROUP
>  	struct gendisk			*throttle_disk;
>  #endif
> --- a/mm/memcontrol.c~mm-kmem-add-direct-objcg-pointer-to-task_struct
> +++ a/mm/memcontrol.c
> @@ -3041,6 +3041,47 @@ static struct obj_cgroup *__get_obj_cgro
>  	return objcg;
>  }
>  
> +static struct obj_cgroup *current_objcg_update(struct obj_cgroup *old)
> +{
> +	struct mem_cgroup *memcg;
> +	struct obj_cgroup *objcg = NULL, *tmp = old;
> +
> +	old = current_objcg_without_update_flag(old);
> +	if (old)
> +		obj_cgroup_put(old);
> +
> +	rcu_read_lock();
> +	do {
> +		/* Atomically drop the update bit, */
> +		WARN_ON_ONCE(cmpxchg(&current->objcg, tmp, 0) != tmp);

Hi Andrew,

can you please, merge a small fixup here?
I've got a sparse complaint from the Intel's kernel test robot.

Thanks!

--

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 78ab36b5899f..4c762a04a689 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3013,7 +3013,7 @@ static struct obj_cgroup *current_objcg_update(struct obj_cgroup *old)
        rcu_read_lock();
        do {
                /* Atomically drop the update bit, */
-               WARN_ON_ONCE(cmpxchg(&current->objcg, tmp, 0) != tmp);
+               WARN_ON_ONCE(cmpxchg(&current->objcg, tmp, NULL) != tmp);

                /* ...obtain the new objcg pointer */
                memcg = mem_cgroup_from_task(current);
