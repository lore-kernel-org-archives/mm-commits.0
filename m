Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A946CC83F2C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 06:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjIDG5W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 02:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343862AbjIDG5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 02:57:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E323D11A
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 23:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693810591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iui/cMfKR07aMfbs/NJj6/2nOIWm7enhjwyf6JBnFyo=;
        b=V7HByigT3SEoRzu8WpW+KAdLAzRXuknkVhnmWsATwBVONQZzv7VliYvcXetJ8QTGr5Gj79
        7zszHoilgV5Ko9B3g66GTEgf0PvwfFMEaAQbifAOAeO4TYO/iNZ5/qhfg8fQh2opP9Swdr
        Ti6e08+SDPvI/VOTXEGvO7tMDskO47I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-yZWLb8KoP0S3b9Fr9KvwsQ-1; Mon, 04 Sep 2023 02:56:30 -0400
X-MC-Unique: yZWLb8KoP0S3b9Fr9KvwsQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 957018008A4;
        Mon,  4 Sep 2023 06:56:29 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.54])
        by smtp.corp.redhat.com (Postfix) with SMTP id C1856400D277;
        Mon,  4 Sep 2023 06:56:28 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon,  4 Sep 2023 08:55:39 +0200 (CEST)
Date:   Mon, 4 Sep 2023 08:55:38 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ebiederm@xmission.com
Subject: Re: + kill-task_struct-thread_group.patch added to mm-nonmm-unstable
 branch
Message-ID: <20230904065538.GA6149@redhat.com>
References: <20230903235057.A7A9EC433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230903235057.A7A9EC433C7@smtp.kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

> From: Oleg Nesterov <oleg@redhat.com>
> Subject: kill task_struct->thread_group
> Date: Sat, 26 Aug 2023 13:14:09 +0200
>
> The last user was removed by the previous patch.

No, no ;)

this series depends on 2 previous patches, see

	https://lore.kernel.org/all/20230824143112.GA31208@redhat.com/

sorry for confusion,

Oleg.


> Link: https://lkml.kernel.org/r/20230826111409.GA23243@redhat.com
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/sched.h |    1 -
>  init/init_task.c      |    1 -
>  kernel/exit.c         |    1 -
>  kernel/fork.c         |    3 ---
>  4 files changed, 6 deletions(-)
> 
> --- a/include/linux/sched.h~kill-task_struct-thread_group
> +++ a/include/linux/sched.h
> @@ -997,7 +997,6 @@ struct task_struct {
>  	/* PID/PID hash table linkage. */
>  	struct pid			*thread_pid;
>  	struct hlist_node		pid_links[PIDTYPE_MAX];
> -	struct list_head		thread_group;
>  	struct list_head		thread_node;
>  
>  	struct completion		*vfork_done;
> --- a/init/init_task.c~kill-task_struct-thread_group
> +++ a/init/init_task.c
> @@ -132,7 +132,6 @@ struct task_struct init_task
>  	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(init_task.pi_lock),
>  	.timer_slack_ns = 50000, /* 50 usec default slack */
>  	.thread_pid	= &init_struct_pid,
> -	.thread_group	= LIST_HEAD_INIT(init_task.thread_group),
>  	.thread_node	= LIST_HEAD_INIT(init_signals.thread_head),
>  #ifdef CONFIG_AUDIT
>  	.loginuid	= INVALID_UID,
> --- a/kernel/exit.c~kill-task_struct-thread_group
> +++ a/kernel/exit.c
> @@ -133,7 +133,6 @@ static void __unhash_process(struct task
>  		list_del_init(&p->sibling);
>  		__this_cpu_dec(process_counts);
>  	}
> -	list_del_rcu(&p->thread_group);
>  	list_del_rcu(&p->thread_node);
>  }
>  
> --- a/kernel/fork.c~kill-task_struct-thread_group
> +++ a/kernel/fork.c
> @@ -2575,7 +2575,6 @@ __latent_entropy struct task_struct *cop
>  	p->dirty_paused_when = 0;
>  
>  	p->pdeath_signal = 0;
> -	INIT_LIST_HEAD(&p->thread_group);
>  	p->task_works = NULL;
>  	clear_posix_cputimers_work(p);
>  
> @@ -2703,8 +2702,6 @@ __latent_entropy struct task_struct *cop
>  			atomic_inc(&current->signal->live);
>  			refcount_inc(&current->signal->sigcnt);
>  			task_join_group_stop(p);
> -			list_add_tail_rcu(&p->thread_group,
> -					  &p->group_leader->thread_group);
>  			list_add_tail_rcu(&p->thread_node,
>  					  &p->signal->thread_head);
>  		}
> _
> 
> Patches currently in -mm which might be from oleg@redhat.com are
> 
> change-thread_group_empty-to-use-task_struct-thread_node.patch
> kill-task_struct-thread_group.patch
> 

