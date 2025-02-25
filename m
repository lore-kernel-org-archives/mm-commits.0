Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3F828E3F;
	Tue, 25 Feb 2025 02:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740450751; cv=none; b=tKlwuzS35nwloO2eqJerOc8eeIXP1osj8N+tN24kte41xe3mCv4RJ5wyr2dCvQSVnM2giNQUUxoYwZcIEFRsQE8kGiAa/DXvU2AeG5Htmo0ppi9pwu5/X4MEO9HXih+ivOah3f/sogLJjAOl9QbTAxgJSR6Bm3/q50p4h3cVrTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740450751; c=relaxed/simple;
	bh=e4auH0yVBTzBKgxXEiQiymraFd0Un++IQSNpEj3Kdaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBzcIdpSpJwOaQkAv+beKDxmjV6V23pjyz2bRDHQrsoFGDAk/yr+7flaLVZFRFlVi3/C4+BUC3JXiTMeQQS/fkpigPxkU11f0Th/oRDZbsPfa8zAWX1kB+mIC3o4xJ5nuARkcQsyWMTOlyLu3q/HGqIOKdFGoU/6YhMdJAOppU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zf8pLezH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zf8pLezH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ABAC4CED6;
	Tue, 25 Feb 2025 02:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740450750;
	bh=e4auH0yVBTzBKgxXEiQiymraFd0Un++IQSNpEj3Kdaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zf8pLezHlw32flnQqIpx4hHoNIPcRiynbGnmkc1OpoPPVHN4Nhtmcyr1lg/ZSZSPx
	 hVaLTqSzc6jEap2oUjyRdSziWkjjUEy1lnP6se8AnKPaR9jgmGbr9P7GKqV7GiNCY4
	 y+T6b4AWIvEMauQYcsBnQAu365tCQtTFwzFmvWTZ+hOXqkVhbnqSDoAVsDbIgXXV6N
	 bgfbTp7Jd2DyJIVSuHy+AS16yn15MDun4TIFYLz5s1+TCoxR1P1PAeekS2T8vOox02
	 5Rq5/TgeKkk7RJ5IMeeqFveTHz7oS7kcLKx/KaM8byzBjK9x7zHwO/RRwf9FVI+cr/
	 GpkAQOKJoRSlg==
Date: Mon, 24 Feb 2025 21:32:29 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
	stable@vger.kernel.org, anna.schumaker@oracle.com
Subject: Re: +
 nfs-fix-nfs_release_folio-to-not-call-nfs_wb_folio-from-kcompactd.patch
 added to mm-hotfixes-unstable branch
Message-ID: <Z70rvb6aEpF3eKJg@kernel.org>
References: <20250225022610.B2EE3C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225022610.B2EE3C4CED6@smtp.kernel.org>

Hi Andrew,

Please see inlined comment below (I found a bug and replied to the
original patch with v2 but wasn't quick enough).

On Mon, Feb 24, 2025 at 06:26:10PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: NFS: fix nfs_release_folio() to not call nfs_wb_folio() from kcompactd
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      nfs-fix-nfs_release_folio-to-not-call-nfs_wb_folio-from-kcompactd.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-fix-nfs_release_folio-to-not-call-nfs_wb_folio-from-kcompactd.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Mike Snitzer <snitzer@kernel.org>
> Subject: NFS: fix nfs_release_folio() to not call nfs_wb_folio() from kcompactd
> Date: Mon, 24 Feb 2025 19:33:01 -0500
> 
> Add PF_KCOMPACTD flag and current_is_kcompactd() helper to check for it so
> nfs_release_folio() can skip calling nfs_wb_folio() from kcompactd.
> 
> Otherwise NFS can deadlock waiting for kcompactd induced writeback which
> recurses back to NFS (which triggers writeback to NFSD via NFS loopback
> mount on the same host, NFSD blocks waiting for XFS's call to
> __filemap_get_folio):
> 
> 6070.550357] INFO: task kcompactd0:58 blocked for more than 4435 seconds.
> 
> {---
> [58] "kcompactd0"
> [<0>] folio_wait_bit+0xe8/0x200
> [<0>] folio_wait_writeback+0x2b/0x80
> [<0>] nfs_wb_folio+0x80/0x1b0 [nfs]
> [<0>] nfs_release_folio+0x68/0x130 [nfs]
> [<0>] split_huge_page_to_list_to_order+0x362/0x840
> [<0>] migrate_pages_batch+0x43d/0xb90
> [<0>] migrate_pages_sync+0x9a/0x240
> [<0>] migrate_pages+0x93c/0x9f0
> [<0>] compact_zone+0x8e2/0x1030
> [<0>] compact_node+0xdb/0x120
> [<0>] kcompactd+0x121/0x2e0
> [<0>] kthread+0xcf/0x100
> [<0>] ret_from_fork+0x31/0x40
> [<0>] ret_from_fork_asm+0x1a/0x30
> ---}
> 
> Link: https://lkml.kernel.org/r/20250225003301.25693-1-snitzer@kernel.org
> Fixes: 96780ca55e3cb ("NFS: fix up nfs_release_folio() to try to release the page")
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> Cc: Anna Schumaker <anna.schumaker@oracle.com>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/nfs/file.c              |    3 ++-
>  include/linux/compaction.h |    5 +++++
>  include/linux/sched.h      |    2 +-
>  mm/compaction.c            |    3 +++
>  4 files changed, 11 insertions(+), 2 deletions(-)
> 
> --- a/fs/nfs/file.c~nfs-fix-nfs_release_folio-to-not-call-nfs_wb_folio-from-kcompactd
> +++ a/fs/nfs/file.c
> @@ -29,6 +29,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/gfp.h>
>  #include <linux/swap.h>
> +#include <linux/compaction.h>
>  
>  #include <linux/uaccess.h>
>  #include <linux/filelock.h>
> @@ -457,7 +458,7 @@ static bool nfs_release_folio(struct fol
>  	/* If the private flag is set, then the folio is not freeable */
>  	if (folio_test_private(folio)) {
>  		if ((current_gfp_context(gfp) & GFP_KERNEL) != GFP_KERNEL ||
> -		    current_is_kswapd())
> +		    current_is_kswapd() || current_is_kcompactd())
>  			return false;
>  		if (nfs_wb_folio(folio->mapping->host, folio) < 0)
>  			return false;
> --- a/include/linux/compaction.h~nfs-fix-nfs_release_folio-to-not-call-nfs_wb_folio-from-kcompactd
> +++ a/include/linux/compaction.h
> @@ -80,6 +80,11 @@ static inline unsigned long compact_gap(
>  	return 2UL << order;
>  }
>  
> +static inline int current_is_kcompactd(void)
> +{
> +	return current->flags & PF_KCOMPACTD;
> +}
> +
>  #ifdef CONFIG_COMPACTION
>  
>  extern unsigned int extfrag_for_order(struct zone *zone, unsigned int order);
> --- a/include/linux/sched.h~nfs-fix-nfs_release_folio-to-not-call-nfs_wb_folio-from-kcompactd
> +++ a/include/linux/sched.h
> @@ -1701,7 +1701,7 @@ extern struct pid *cad_pid;
>  #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
>  #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
>  #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
> -#define PF__HOLE__00010000	0x00010000
> +#define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
>  #define PF_KSWAPD		0x00020000	/* I am kswapd */
>  #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
>  #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
> --- a/mm/compaction.c~nfs-fix-nfs_release_folio-to-not-call-nfs_wb_folio-from-kcompactd
> +++ a/mm/compaction.c
> @@ -3181,6 +3181,7 @@ static int kcompactd(void *p)
>  	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
>  	long timeout = default_timeout;
>  
> +	tsk->flags | PF_KCOMPACTD;

This should be: tsk->flags |= PF_KCOMPACTD;

Sorry for the trouble, v2 is available here:
https://lore.kernel.org/linux-nfs/20250225022002.26141-1-snitzer@kernel.org/

>  	set_freezable();
>  
>  	pgdat->kcompactd_max_order = 0;
> @@ -3237,6 +3238,8 @@ static int kcompactd(void *p)
>  			pgdat->proactive_compact_trigger = false;
>  	}
>  
> +	tsk->flags &= ~PF_KCOMPACTD;
> +
>  	return 0;
>  }
>  
> _
> 
> Patches currently in -mm which might be from snitzer@kernel.org are
> 
> nfs-fix-nfs_release_folio-to-not-call-nfs_wb_folio-from-kcompactd.patch
> 
