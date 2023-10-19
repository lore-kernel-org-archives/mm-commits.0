Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF57CDB465
	for <mm-commits@archiver.kernel.org>; Thu, 19 Oct 2023 07:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjJSHOj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Oct 2023 03:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjJSHOi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2023 03:14:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE6DAB
        for <mm-commits@vger.kernel.org>; Thu, 19 Oct 2023 00:14:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E11C11F459;
        Thu, 19 Oct 2023 07:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1697699673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NMSFpfK8QAs1N1QbAPmYlPEZk4QQ0IxeHUoOGfiBKp0=;
        b=Xj7H6qAFM0e0oeGsnrdCO+Rum9gAssmKdW0WHrVaClYd3LpM/yy+TCa72DWmVXyYCNvVvm
        Lhz5ZoqhywvElFtY4uNeVj/xarPFV/5EGiFflY+rcPgL6yFD3TTl7TSfVMEYwu3Hp/Ra47
        ra99yXan0AvjUGd8l3JZnBIvRORW6yg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1697699673;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NMSFpfK8QAs1N1QbAPmYlPEZk4QQ0IxeHUoOGfiBKp0=;
        b=nqiidNrp1W68DHVVXnNDzW1JAM61lbVlhKDpB7tj1dqArnmmpih2O7AB1jT79W4chSV9Y3
        FcXzOeZlN62/drBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B78C5139C2;
        Thu, 19 Oct 2023 07:14:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BPHxK1nXMGUcDwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 19 Oct 2023 07:14:33 +0000
Message-ID: <aad21d82-d6fe-5d33-344f-675244f04c72@suse.cz>
Date:   Thu, 19 Oct 2023 09:14:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: + mm-kmem-add-direct-objcg-pointer-to-task_struct.patch added to
 mm-unstable branch
To:     Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org
References: <20231016225836.501DEC433C7@smtp.kernel.org>
 <ZTAfFOsvlbqPI0Uk@P9FQF9L96D.corp.robot.car>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <ZTAfFOsvlbqPI0Uk@P9FQF9L96D.corp.robot.car>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-7.10 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCPT_COUNT_SEVEN(0.00)[10];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10/18/23 20:08, Roman Gushchin wrote:
> From 14f998a9235fdfa88a4ebfad5802bdde6195bfae Mon Sep 17 00:00:00 2001
> From: Roman Gushchin <roman.gushchin@linux.dev>
> Date: Mon, 19 Dec 2022 15:46:18 -0800
> Subject: [PATCH v4 2/5] mm: kmem: add direct objcg pointer to task_struct
> 
> To charge a freshly allocated kernel object to a memory cgroup, the
> kernel needs to obtain an objcg pointer. Currently it does it
> indirectly by obtaining the memcg pointer first and then calling to
> __get_obj_cgroup_from_memcg().
> 
> Usually tasks spend their entire life belonging to the same object
> cgroup. So it makes sense to save the objcg pointer on task_struct
> directly, so it can be obtained faster. It requires some work on fork,
> exit and cgroup migrate paths, but these paths are way colder.
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
> Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/sched.h |   4 ++
>  mm/memcontrol.c       | 138 +++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 133 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 77f01ac385f7..60de42715b56 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
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
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 16ac2a5838fb..d51b87cc8d97 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -249,6 +249,9 @@ struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr)
>  	return container_of(vmpr, struct mem_cgroup, vmpressure);
>  }
>  
> +#define CURRENT_OBJCG_UPDATE_BIT 0
> +#define CURRENT_OBJCG_UPDATE_FLAG (1UL << CURRENT_OBJCG_UPDATE_BIT)
> +
>  #ifdef CONFIG_MEMCG_KMEM
>  static DEFINE_SPINLOCK(objcg_lock);
>  
> @@ -3001,6 +3004,57 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>  	return objcg;
>  }
>  
> +static struct obj_cgroup *current_objcg_update(void)
> +{
> +	struct mem_cgroup *memcg;
> +	struct obj_cgroup *old, *objcg = NULL;
> +
> +	do {
> +		/* Atomically drop the update bit. */
> +		old = xchg(&current->objcg, NULL);
> +		if (old) {
> +			old = (struct obj_cgroup *)
> +				((unsigned long)old & ~CURRENT_OBJCG_UPDATE_FLAG);
> +			if (old)
> +				obj_cgroup_put(old);
> +
> +			old = NULL;
> +		}
> +
> +		/*
> +		 * Release the objcg pointer from the previous iteration,
> +		 * if try_cmpxcg() below fails.
> +		 */
> +		if (unlikely(objcg))
> +			obj_cgroup_put(objcg);
> +
> +		/* Obtain the new objcg pointer. */
> +		rcu_read_lock();
> +		memcg = mem_cgroup_from_task(current);

Btw, can this return the root_mem_cgroup? If yes, then the for loop below
doesn't do even a single iteration, and we might have a stale pointer in
objcg? Should we set it to NULL after dropping the reference above?
(But even before the series, the similar loop in
__get_obj_cgroup_from_memcg() would mean no objcg is obtained in such case,
I guess that's just a part of the design that root memcg doesn't have an objcg).

> +		/*
> +		 * The current task can be asynchronously moved to another
> +		 * memcg and the previous memcg can be offlined. So let's
> +		 * get the memcg pointer and try get a reference to objcg
> +		 * under a rcu read lock.
> +		 */
> +		for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
> +			objcg = rcu_dereference(memcg->objcg);
> +			if (likely(objcg && obj_cgroup_tryget(objcg)))
> +				break;
> +			objcg = NULL;
> +		}
> +		rcu_read_unlock();
> +
> +		/*
> +		 * Try set up a new objcg pointer atomically. If it
> +		 * fails, it means the update flag was set concurrently, so
> +		 * the whole procedure should be repeated.
> +		 */
> +	} while (!try_cmpxchg(&current->objcg, &old, objcg));
> +
> +	return objcg;
> +}
> +
>  __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
>  {
>  	struct mem_cgroup *memcg;
> @@ -3008,19 +3062,26 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
>  
>  	if (in_task()) {
>  		memcg = current->active_memcg;
> +		if (unlikely(memcg))
> +			goto from_memcg;
>  
> -		/* Memcg to charge can't be determined. */
> -		if (likely(!memcg) && (!current->mm || (current->flags & PF_KTHREAD)))
> -			return NULL;
> +		objcg = READ_ONCE(current->objcg);
> +		if (unlikely((unsigned long)objcg & CURRENT_OBJCG_UPDATE_FLAG))
> +			objcg = current_objcg_update();
> +
> +		if (objcg) {
> +			obj_cgroup_get(objcg);
> +			return objcg;
> +		}
>  	} else {
>  		memcg = this_cpu_read(int_active_memcg);
> -		if (likely(!memcg))
> -			return NULL;
> +		if (unlikely(memcg))
> +			goto from_memcg;
>  	}
> +	return NULL;
>  
> +from_memcg:
>  	rcu_read_lock();
> -	if (!memcg)
> -		memcg = mem_cgroup_from_task(current);
>  	objcg = __get_obj_cgroup_from_memcg(memcg);
>  	rcu_read_unlock();
>  	return objcg;
> @@ -6345,6 +6406,7 @@ static void mem_cgroup_move_task(void)
>  		mem_cgroup_clear_mc();
>  	}
>  }
> +
>  #else	/* !CONFIG_MMU */
>  static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
>  {
> @@ -6358,8 +6420,39 @@ static void mem_cgroup_move_task(void)
>  }
>  #endif
>  
> +#ifdef CONFIG_MEMCG_KMEM
> +static void mem_cgroup_fork(struct task_struct *task)
> +{
> +	/*
> +	 * Set the update flag to cause task->objcg to be initialized lazily
> +	 * on the first allocation. It can be done without any synchronization
> +	 * because it's always performed on the current task, so does
> +	 * current_objcg_update().
> +	 */
> +	task->objcg = (struct obj_cgroup *)CURRENT_OBJCG_UPDATE_FLAG;
> +}
> +
> +static void mem_cgroup_exit(struct task_struct *task)
> +{
> +	struct obj_cgroup *objcg = task->objcg;
> +
> +	objcg = (struct obj_cgroup *)
> +		((unsigned long)objcg & ~CURRENT_OBJCG_UPDATE_FLAG);
> +	if (objcg)
> +		obj_cgroup_put(objcg);
> +
> +	/*
> +	 * Some kernel allocations can happen after this point,
> +	 * but let's ignore them. It can be done without any synchronization
> +	 * because it's always performed on the current task, so does
> +	 * current_objcg_update().
> +	 */
> +	task->objcg = NULL;
> +}
> +#endif
> +
>  #ifdef CONFIG_LRU_GEN
> -static void mem_cgroup_attach(struct cgroup_taskset *tset)
> +static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset)
>  {
>  	struct task_struct *task;
>  	struct cgroup_subsys_state *css;
> @@ -6377,10 +6470,31 @@ static void mem_cgroup_attach(struct cgroup_taskset *tset)
>  	task_unlock(task);
>  }
>  #else
> +static void mem_cgroup_lru_gen_attach(struct cgroup_taskset *tset) {}
> +#endif /* CONFIG_LRU_GEN */
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset)
> +{
> +	struct task_struct *task;
> +	struct cgroup_subsys_state *css;
> +
> +	cgroup_taskset_for_each(task, css, tset) {
> +		/* atomically set the update bit */
> +		set_bit(CURRENT_OBJCG_UPDATE_BIT, (unsigned long *)&task->objcg);
> +	}
> +}
> +#else
> +static void mem_cgroup_kmem_attach(struct cgroup_taskset *tset) {}
> +#endif /* CONFIG_MEMCG_KMEM */
> +
> +#if defined(CONFIG_LRU_GEN) || defined(CONFIG_MEMCG_KMEM)
>  static void mem_cgroup_attach(struct cgroup_taskset *tset)
>  {
> +	mem_cgroup_lru_gen_attach(tset);
> +	mem_cgroup_kmem_attach(tset);
>  }
> -#endif /* CONFIG_LRU_GEN */
> +#endif
>  
>  static int seq_puts_memcg_tunable(struct seq_file *m, unsigned long value)
>  {
> @@ -6824,9 +6938,15 @@ struct cgroup_subsys memory_cgrp_subsys = {
>  	.css_reset = mem_cgroup_css_reset,
>  	.css_rstat_flush = mem_cgroup_css_rstat_flush,
>  	.can_attach = mem_cgroup_can_attach,
> +#if defined(CONFIG_LRU_GEN) || defined(CONFIG_MEMCG_KMEM)
>  	.attach = mem_cgroup_attach,
> +#endif
>  	.cancel_attach = mem_cgroup_cancel_attach,
>  	.post_attach = mem_cgroup_move_task,
> +#ifdef CONFIG_MEMCG_KMEM
> +	.fork = mem_cgroup_fork,
> +	.exit = mem_cgroup_exit,
> +#endif
>  	.dfl_cftypes = memory_files,
>  	.legacy_cftypes = mem_cgroup_legacy_files,
>  	.early_init = 0,

