Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F8B4A0F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 03:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742269644; cv=none; b=YAbQCwwvCR6sT5ermb9n1V5ZYuOktm6DEHGY5iUVJlMm9LyPSwKP+g0ctaVQmAR38/V/e8MkI/KnDmHmoi9oYovnGzllnuMp0QObyDa9o9/wKO8ZAui2/rlAp6l51HiipJhA3tx0nBSA1USkvWk5uJWtPYRe7r+ptAxjpbI+2jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742269644; c=relaxed/simple;
	bh=V3WFFsVvdhrpGe9zukluETViijZcorRabc8Hd74YAnw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RQH0h9TQpmloN3v9EuwblKT2XvUwE9Vz6J8WyzRx5WbfgMc6FFBHlBLOMXakRUVL4ASknkH3m6M735WUO1FS9xGc3sJTKLkt1uO6RP9VJgpOtTuCe5z32Ggk0kInVepQAfZB3fB/rOzI4zs9qM9F7rWkXdwv6g5+ZXSdnepj3Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UY4Mstym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UY4Mstym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF108C4CEDD;
	Tue, 18 Mar 2025 03:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742269643;
	bh=V3WFFsVvdhrpGe9zukluETViijZcorRabc8Hd74YAnw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UY4Mstymj8KxlIj6jFzImsdy7Ou6BQK4lhfR0DpUWOl/ljBUHN2NL4PiEQCROjmtB
	 xSEiXL4UiJ8yvV3uUOn+YWjQeD7kLddgOcwMUijExYEuyMzN8jEJQzdIBTwJAzUn0I
	 UAvEUYG9CUyc7zlVbL8lh8Km1STR3JJg9786gLzCrQY2e7RWRv3TPgljkM5SC7+NGG
	 hnXHEJMaupLosMzFWpAZ9xfKLIfsZxwm/pZ+QiBbEyWSFuAwRZj1S7JT7wIcf90Vdn
	 jtsn+kM7Lx9wdfaspljdTHXrguWTEbZ23Vob8weqlB1iVeFbVPe+Z1DT4+px5dC/2T
	 epnVp5v+yky9A==
Date: Tue, 18 Mar 2025 12:47:21 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, lkp@intel.com
Subject: Re: +
 samples-add-hung_task-detector-mutex-blocking-sample-fix.patch added to
 mm-nonmm-unstable branch
Message-Id: <20250318124721.a9927cece4c76695b5414cf3@kernel.org>
In-Reply-To: <20250318025452.85C43C4CEE3@smtp.kernel.org>
References: <20250318025452.85C43C4CEE3@smtp.kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Mar 2025 19:54:51 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: samples-add-hung_task-detector-mutex-blocking-sample-fix
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      samples-add-hung_task-detector-mutex-blocking-sample-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-add-hung_task-detector-mutex-blocking-sample-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: samples-add-hung_task-detector-mutex-blocking-sample-fix
> Date: Mon Mar 17 07:53:34 PM PDT 2025
> 
> make `hung_task_dir' static
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202503180827.4StpuFrD-lkp@intel.com/
> Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thanks for fixing.

Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thank you!

> ---
> 
>  samples/hung_task/Makefile          |    2 +-
>  samples/hung_task/hung_task_mutex.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/samples/hung_task/hung_task_mutex.c~samples-add-hung_task-detector-mutex-blocking-sample-fix
> +++ a/samples/hung_task/hung_task_mutex.c
> @@ -22,7 +22,7 @@
>  
>  static const char dummy_string[] = "This is a dummy string.";
>  static DEFINE_MUTEX(dummy_mutex);
> -struct dentry *hung_task_dir;
> +static struct dentry *hung_task_dir;
>  
>  static ssize_t read_dummy(struct file *file, char __user *user_buf,
>  			  size_t count, loff_t *ppos)
> --- a/samples/hung_task/Makefile~samples-add-hung_task-detector-mutex-blocking-sample-fix
> +++ a/samples/hung_task/Makefile
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_mutex.o
> \ No newline at end of file
> +obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_mutex.o
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
> hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch
> samples-add-hung_task-detector-mutex-blocking-sample-fix.patch
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
