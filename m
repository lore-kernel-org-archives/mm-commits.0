Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED51B2566D1
	for <mm-commits@vger.kernel.org>; Mon, 24 Feb 2025 10:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740393680; cv=none; b=XUytnMZK4EJrKJMyQGqapDQjHRBYuwqnYGyhhtCTgq01CnbL7+mLVcQoxfnfVLkl5ZHwN6xZ9BwcwgLMVKcUYPc0SZF6hpDJJb3nWefYme9AVszf/FreicM3KQY7i+ss1i4XmgEIt8F+bfQ+04VETrq/boxWCQM7Nlh9AjOvTdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740393680; c=relaxed/simple;
	bh=YH6QkTdlusCIff4K9Hiur1vZjmAmQHvpSXZnk3RKpgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9+XKfEbFfY8a0d6BRDnBUM7XeaQy4jV7rRUTK/EminMZZvfOyEZoO1Idqcr3NbkO/l7WFULjXVX15RHqkf2E3dOanRPKlyxtRBlDTHGdEAM2CCO94qGBFAo1QKCDsPIPPoIPPBG332AuLdXk5C2pirm58Gq+IkJJTv19h4C5nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYYXpH1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYYXpH1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8602DC4CED6;
	Mon, 24 Feb 2025 10:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740393679;
	bh=YH6QkTdlusCIff4K9Hiur1vZjmAmQHvpSXZnk3RKpgk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EYYXpH1TJJ5RCne5HWO8Kvn5JUZrd98GEo4VPS1GLsXSs9qC3EFk8DJHcgP1irfcU
	 jjVyCt1NN9aspbMvyiiFHxP4i6o0v5YFb2g4DEZBokwGbBtZsJG6v/tDyXFw80kgGq
	 Y+176rGV6hZ8IaJXqe35a2lzvCR5idsEv1XELYFNHgj3uUPOH98dBpjreYLETxvgH9
	 FyCA2bWDWEki8EFtvz6CvLBIX+xNY1vWpz9vJ2EIlyKIhO6DwyWBygqLmyI6zLWvrr
	 r7MoJW0ySevGOSAgEBjTL7HQEASNU6ZMfA3bdRwC3cR9gXKKkHixKHs4KjAqrLqwCP
	 DPsqprFC/nzZQ==
Date: Mon, 24 Feb 2025 11:41:14 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, oleg@redhat.com, kees@kernel.org, 
	ebiederm@xmission.com, corbet@lwn.net, alexander@mihalicyn.com, mkoutny@suse.com
Subject: Re: + pid-optional-first-fit-pid-allocation.patch added to
 mm-nonmm-unstable branch
Message-ID: <20250224-gemurmel-gebracht-595943846c93@brauner>
References: <20250222002156.BEE65C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250222002156.BEE65C4CED6@smtp.kernel.org>

On Fri, Feb 21, 2025 at 04:21:56PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: pid: Optional first-fit pid allocation
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      pid-optional-first-fit-pid-allocation.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-optional-first-fit-pid-allocation.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
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
> From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
> Subject: pid: Optional first-fit pid allocation
> Date: Fri, 21 Feb 2025 18:02:49 +0100
> 
> Noone would need to use this allocation strategy (it's slower, pid
> numbers collide sooner). Its primary purpose are pid namespaces in
> conjunction with pids.max cgroup limit which keeps (virtual) pid numbers
> below the given limit. This is for 32-bit userspace programs that may
> not work well with pid numbers above 65536.
> 
> Link: https://lore.kernel.org/r/20241122132459.135120-1-aleksandr.mikhalitsyn@canonical.com/
> Link: https://lkml.kernel.org/r/20250221170249.890014-3-mkoutny@suse.com
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Hm, I've never received this patch yet it reverts something and then
substitutes another approach and has no Acks? Don't get me wrong I'm not
objecting to it per se but I did not have any chance to actually look at
it.

> 
>  Documentation/admin-guide/sysctl/kernel.rst |    2 +
>  include/linux/pid_namespace.h               |    3 +
>  kernel/pid.c                                |   12 ++++++-
>  kernel/pid_namespace.c                      |   28 +++++++++++++-----
>  4 files changed, 36 insertions(+), 9 deletions(-)
> 
> --- a/Documentation/admin-guide/sysctl/kernel.rst~pid-optional-first-fit-pid-allocation
> +++ a/Documentation/admin-guide/sysctl/kernel.rst
> @@ -1043,6 +1043,8 @@ The last pid allocated in the current (t
>  lives in) pid namespace. When selecting a pid for a next task on fork
>  kernel tries to allocate a number starting from this one.
>  
> +When set to -1, first-fit pid numbering is used instead of the next-fit.
> +
>  
>  powersave-nap (PPC only)
>  ========================
> --- a/include/linux/pid_namespace.h~pid-optional-first-fit-pid-allocation
> +++ a/include/linux/pid_namespace.h
> @@ -41,6 +41,9 @@ struct pid_namespace {
>  #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
>  	int memfd_noexec_scope;
>  #endif
> +#ifdef CONFIG_IA32_EMULATION
> +	bool pid_noncyclic;
> +#endif
>  } __randomize_layout;
>  
>  extern struct pid_namespace init_pid_ns;
> --- a/kernel/pid.c~pid-optional-first-fit-pid-allocation
> +++ a/kernel/pid.c
> @@ -191,6 +191,10 @@ struct pid *alloc_pid(struct pid_namespa
>  
>  	for (i = ns->level; i >= 0; i--) {
>  		int tid = 0;
> +		bool pid_noncyclic = 0;
> +#ifdef CONFIG_IA32_EMULATION
> +		pid_noncyclic = READ_ONCE(tmp->pid_noncyclic);
> +#endif
>  
>  		if (set_tid_size) {
>  			tid = set_tid[ns->level - i];
> @@ -235,8 +239,12 @@ struct pid *alloc_pid(struct pid_namespa
>  			 * Store a null pointer so find_pid_ns does not find
>  			 * a partially initialized PID (see below).
>  			 */
> -			nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
> -					      pid_max, GFP_ATOMIC);
> +			if (likely(!pid_noncyclic))
> +				nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
> +						      pid_max, GFP_ATOMIC);
> +			else
> +				nr = idr_alloc(&tmp->idr, NULL, pid_min,
> +						      pid_max, GFP_ATOMIC);
>  		}
>  		spin_unlock_irq(&pidmap_lock);
>  		idr_preload_end();
> --- a/kernel/pid_namespace.c~pid-optional-first-fit-pid-allocation
> +++ a/kernel/pid_namespace.c
> @@ -114,6 +114,9 @@ static struct pid_namespace *create_pid_
>  #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
>  	ns->memfd_noexec_scope = pidns_memfd_noexec_scope(parent_pid_ns);
>  #endif
> +#ifdef CONFIG_IA32_EMULATION
> +	ns->pid_noncyclic = READ_ONCE(parent_pid_ns->pid_noncyclic);
> +#endif
>  	return ns;
>  
>  out_free_idr:
> @@ -260,7 +263,7 @@ void zap_pid_ns_processes(struct pid_nam
>  	return;
>  }
>  
> -#ifdef CONFIG_CHECKPOINT_RESTORE
> +#if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_IA32_EMULATION)
>  static int pid_ns_ctl_handler(const struct ctl_table *table, int write,
>  		void *buffer, size_t *lenp, loff_t *ppos)
>  {
> @@ -271,12 +274,23 @@ static int pid_ns_ctl_handler(const stru
>  	if (write && !checkpoint_restore_ns_capable(pid_ns->user_ns))
>  		return -EPERM;
>  
> -	next = idr_get_cursor(&pid_ns->idr) - 1;
> +	next = -1;
> +#ifdef CONFIG_IA32_EMULATION
> +	if (!pid_ns->pid_noncyclic)
> +#endif
> +		next += idr_get_cursor(&pid_ns->idr);
>  
>  	tmp.data = &next;
>  	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> -	if (!ret && write)
> -		idr_set_cursor(&pid_ns->idr, next + 1);
> +	if (!ret && write) {
> +		if (next > -1)
> +			idr_set_cursor(&pid_ns->idr, next + 1);
> +		else if (!IS_ENABLED(CONFIG_IA32_EMULATION))
> +			ret = -EINVAL;
> +#ifdef CONFIG_IA32_EMULATION
> +		WRITE_ONCE(pid_ns->pid_noncyclic, next == -1);
> +#endif
> +	}
>  
>  	return ret;
>  }
> @@ -288,11 +302,11 @@ static const struct ctl_table pid_ns_ctl
>  		.maxlen = sizeof(int),
>  		.mode = 0666, /* permissions are checked in the handler */
>  		.proc_handler = pid_ns_ctl_handler,
> -		.extra1 = SYSCTL_ZERO,
> +		.extra1 = SYSCTL_NEG_ONE,
>  		.extra2 = &pid_max,
>  	},
>  };
> -#endif	/* CONFIG_CHECKPOINT_RESTORE */
> +#endif	/* CONFIG_CHECKPOINT_RESTORE || CONFIG_IA32_EMULATION */
>  
>  int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
>  {
> @@ -449,7 +463,7 @@ static __init int pid_namespaces_init(vo
>  {
>  	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC | SLAB_ACCOUNT);
>  
> -#ifdef CONFIG_CHECKPOINT_RESTORE
> +#if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_IA32_EMULATION)
>  	register_sysctl_init("kernel", pid_ns_ctl_table);
>  #endif
>  
> _
> 
> Patches currently in -mm which might be from mkoutny@suse.com are
> 
> revert-pid-allow-pid_max-to-be-set-per-pid-namespace.patch
> pid-optional-first-fit-pid-allocation.patch
> 
