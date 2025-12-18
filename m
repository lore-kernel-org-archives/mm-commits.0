Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054DE2FBDF5
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 02:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766025030; cv=none; b=ATTBX15/pO3m2F9XA6avas9502OhfaSb3B64cabmXkrhGADonmuZCXW3OqyE2L8tRBg9WXnql5gUkumJ5RbZOY5fHyFUAWgfZw7LftC1VQL/K7ecq9xOOPH9/V1Qhvq58iy+YM7kqK69oQttf2Jf+Kszf6MHl/m2+dlejuUFWnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766025030; c=relaxed/simple;
	bh=AmXDeDGKFkyGM52OE5tb8rXEEYmK6gb/iTRGa1pzEd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=sReYLj/n00hu/72FBh+itfOjdJCKcttTFq3ydNIhN60+aCozas9dNipmWhXCWrS0D+UAQOsmRTwD8tc9aqrlOLxYalH5+Ox/HCWfmaXgfgH84Lfva2d8pA6uu0AoMYeTr1Q2tvUZ9xCubt5jUwQePQkrkkk1xCPOpn5w8S09MUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lgI8O9Ne; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lgI8O9Ne"
Message-ID: <20d511d2-1eed-4896-bd7d-c1e080319f61@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766025021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SAlIX/J5yhYqeG2qEY3VEHKMGe7V5vOj02TmQAI0ZU8=;
	b=lgI8O9NeKwdKXhNhzHbKgwCaCu4yt9wcfMWk+hXDDGAFtVh94/8py9BajAXGjokrSs2ESp
	YCTe1dtcFHkdxg2P4QAzVaMpK8gQIB3EXTIuS4GCyb0Vf1OC8SQZHUpDsqjqYiJUDhTo5J
	As+CGd73PnXgnZxSLqkqZGFtGb/VxyY=
Date: Thu, 18 Dec 2025 10:30:10 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: + hung_task-enable-runtime-reset-of-hung_task_detect_count.patch
 added to mm-nonmm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, pmladek@suse.com,
 atomlin@atomlin.com
References: <20251216033809.8B31AC4CEF5@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Cc: mm-commits@vger.kernel.org, mhiramat@kernel.org,
 gregkh@linuxfoundation.org
In-Reply-To: <20251216033809.8B31AC4CEF5@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Andrew,

Could you please drop this patch from mm-nonmm-unstable?

As Petr pointed out[1], resetting sysctl_hung_task_detect_count has a
serious race condition ...

When check_hung_uninterruptible_tasks() saves prev_detect_count and
iterates through all processes, if userspace resets the counter during
this window, the subtraction will underflow:

	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;

	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
		hung_task_call_panic = true; // false positive!!!
	}

The race window is big (iterating all tasks). We'd need to add a lock
to detector code, but that's risky ...

As Petr said, keeping the detector working correctly matters more than
adding a reset feature. I'm not sure this convenience is worth it either.

[1] https://lore.kernel.org/all/aUKresftPnbndSBo@pathway.suse.cz/

Thanks,
Lance

On 2025/12/16 11:38, Andrew Morton wrote:
> The patch titled
>       Subject: hung_task: enable runtime reset of hung_task_detect_count
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>       hung_task-enable-runtime-reset-of-hung_task_detect_count.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-enable-runtime-reset-of-hung_task_detect_count.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Aaron Tomlin <atomlin@atomlin.com>
> Subject: hung_task: enable runtime reset of hung_task_detect_count
> Date: Mon, 15 Dec 2025 22:00:36 -0500
> 
> Introduce support for writing to /proc/sys/kernel/hung_task_detect_count.
> 
> Writing any value to this file atomically resets the counter of detected
> hung tasks to zero.  This grants system administrators the ability to
> clear the cumulative diagnostic history after resolving an incident,
> simplifying monitoring without requiring a system restart.
> 
> Link: https://lkml.kernel.org/r/20251216030036.1822217-3-atomlin@atomlin.com
> Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   Documentation/admin-guide/sysctl/kernel.rst |    2 -
>   kernel/hung_task.c                          |   29 ++++++++++++++++--
>   2 files changed, 28 insertions(+), 3 deletions(-)
> 
> --- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-enable-runtime-reset-of-hung_task_detect_count
> +++ a/Documentation/admin-guide/sysctl/kernel.rst
> @@ -418,7 +418,7 @@ hung_task_detect_count
>   ======================
>   
>   Indicates the total number of tasks that have been detected as hung since
> -the system boot.
> +the system boot. The counter can be reset to zero when written to.
>   
>   This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
>   
> --- a/kernel/hung_task.c~hung_task-enable-runtime-reset-of-hung_task_detect_count
> +++ a/kernel/hung_task.c
> @@ -375,6 +375,31 @@ static long hung_timeout_jiffies(unsigne
>   }
>   
>   #ifdef CONFIG_SYSCTL
> +
> +/**
> + * proc_dohung_task_detect_count - proc handler for hung_task_detect_count
> + * @table: Pointer to the struct ctl_table definition for this proc entry
> + * @write: Flag indicating the operation
> + * @buffer: User space buffer for data transfer
> + * @lenp: Pointer to the length of the data being transferred
> + * @ppos: Pointer to the current file offset
> + *
> + * This handler is used for reading the current hung task detection count
> + * and for resetting it to zero when a write operation is performed.
> + * Returns 0 on success or a negative error code on failure.
> + */
> +static int proc_dohung_task_detect_count(const struct ctl_table *table, int write,
> +					 void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	if (!write)
> +		return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
> +
> +	WRITE_ONCE(sysctl_hung_task_detect_count, 0);
> +	*ppos += *lenp;
> +
> +	return 0;
> +}
> +
>   /*
>    * Process updating of timeout sysctl
>    */
> @@ -457,8 +482,8 @@ static const struct ctl_table hung_task_
>   		.procname	= "hung_task_detect_count",
>   		.data		= &sysctl_hung_task_detect_count,
>   		.maxlen		= sizeof(unsigned long),
> -		.mode		= 0444,
> -		.proc_handler	= proc_doulongvec_minmax,
> +		.mode		= 0644,
> +		.proc_handler	= proc_dohung_task_detect_count,
>   	},
>   	{
>   		.procname	= "hung_task_sys_info",
> _
> 
> Patches currently in -mm which might be from atomlin@atomlin.com are
> 
> hung_task-introduce-helper-for-hung-task-warning.patch
> hung_task-enable-runtime-reset-of-hung_task_detect_count.patch
> 

