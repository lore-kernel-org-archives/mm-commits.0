Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07FA4689
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 06:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744612015; cv=none; b=ZuJFYjn8S7dx+77Q10mSWCN/BlohAwKrCgcEJOUuT2FOTSBqQV93de8vXV9OePR2nRvlksjj+8DIBpmzo0ki21sy02iYyGEiSmgnlkT/TumdyXfRtOQfs/aFOrR64yMyG5lfSbMQlu82kyuULkTYVi5lklMfHk09psL+rlBQO9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744612015; c=relaxed/simple;
	bh=vFnm8orqzbodLJ/XAC+7DhDJNSt64eLSEdZT4XzfGWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=q/bsxO8rjY8PkT/pl4H7rTwQO2GeGOWaCtRXVs2iSqT3IRyLCnIvqtoJNdb2zCgLR5ht3qZsdVnaEma3ZC22M2m3aQ3RzV1ciSz2ozbxOs2Ff7iufICVPJd4gqmdoK1fP7PbRyXbNireDjtX6ZF9h8+7Wtrsv2IDMcp/EfvisJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=R36bA5tE; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="R36bA5tE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1744612002; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bxMC4o4H91rdZCu7k5HvvDdsWg/lx9mQWR9UN/rmakg=;
	b=R36bA5tEXGSj3r2GRenrjHhtlBZ0CRYt8Y68YuqVYkl7ZxtZsJ0HpjqQqDm5ygcbUReJMUiR61W6+utTHP9Y64xHuM0gJxb0BufCKiMEZA3LXJaqjCSozVgzZAQZYjdrHTHHANczLsHhWBzinyFDPgECzOXVeCOZskZzZu/hywI=
Received: from 30.221.129.33(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WWhBelc_1744612000 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Apr 2025 14:26:41 +0800
Message-ID: <b6344c04-1c75-431f-b8df-b7058c5ba039@linux.alibaba.com>
Date: Mon, 14 Apr 2025 14:26:40 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch added
 to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20250402222518.28BBBC4CEDD@smtp.kernel.org>
Cc: mm-commits@vger.kernel.org, piaojun@huawei.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Changwei Ge <gechangwei@live.cn>,
 Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250402222518.28BBBC4CEDD@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Andrew,
Could you please drop this patch?
Since it couldn't cover all cases and Heming will post a new version.

Thanks,
Joseph

On 2025/4/3 06:25, Andrew Morton wrote:
> The patch titled
>      Subject: ocfs2: fix global bitmap allocating failure for discontig type
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch
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
> From: Heming Zhao <heming.zhao@suse.com>
> Subject: ocfs2: fix global bitmap allocating failure for discontig type
> Date: Tue, 1 Apr 2025 22:26:21 +0800
> 
> commit 4eb7b93e0310 ("ocfs2: improve write IO performance when
> fragmentation is high") introduced a regression.  In the discontiguous
> extent allocation case, ocfs2_cluster_group_search() is comparing with the
> wrong target length, which causes allocation failure.
> 
> Call stack:
> ocfs2_mkdir()
>  ocfs2_reserve_new_inode()
>   ocfs2_reserve_suballoc_bits()
>    ocfs2_block_group_alloc()
>     ocfs2_block_group_alloc_discontig()
>      __ocfs2_claim_clusters()
>       ocfs2_claim_suballoc_bits()
>        ocfs2_search_chain()
>         ocfs2_cluster_group_search()
> 
> Link: https://lkml.kernel.org/r/20250401142623.31223-1-heming.zhao@suse.com
> Fixes: 4eb7b93e0310 ("ocfs2: improve write IO performance when fragmentation is high")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reported-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> Tested-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Jun Piao <piaojun@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/suballoc.c |   10 ++++++++--
>  fs/ocfs2/suballoc.h |    1 +
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> --- a/fs/ocfs2/suballoc.c~ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type
> +++ a/fs/ocfs2/suballoc.c
> @@ -698,10 +698,12 @@ static int ocfs2_block_group_alloc(struc
>  
>  	bg_bh = ocfs2_block_group_alloc_contig(osb, handle, alloc_inode,
>  					       ac, cl);
> -	if (PTR_ERR(bg_bh) == -ENOSPC)
> +	if (PTR_ERR(bg_bh) == -ENOSPC) {
> +		ac->ac_which = OCFS2_AC_USE_MAIN_DISCONTIG;
>  		bg_bh = ocfs2_block_group_alloc_discontig(handle,
>  							  alloc_inode,
>  							  ac, cl);
> +	}
>  	if (IS_ERR(bg_bh)) {
>  		status = PTR_ERR(bg_bh);
>  		bg_bh = NULL;
> @@ -2365,7 +2367,8 @@ int __ocfs2_claim_clusters(handle_t *han
>  	BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
>  
>  	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL
> -	       && ac->ac_which != OCFS2_AC_USE_MAIN);
> +	       && ac->ac_which != OCFS2_AC_USE_MAIN
> +	       && ac->ac_which != OCFS2_AC_USE_MAIN_DISCONTIG);
>  
>  	if (ac->ac_which == OCFS2_AC_USE_LOCAL) {
>  		WARN_ON(min_clusters > 1);
> @@ -2429,6 +2432,9 @@ int ocfs2_claim_clusters(handle_t *handl
>  {
>  	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
>  
> +	if (ac->ac_which == OCFS2_AC_USE_MAIN_DISCONTIG)
> +		bits_wanted = min_clusters;
> +
>  	return __ocfs2_claim_clusters(handle, ac, min_clusters,
>  				      bits_wanted, cluster_start, num_clusters);
>  }
> --- a/fs/ocfs2/suballoc.h~ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type
> +++ a/fs/ocfs2/suballoc.h
> @@ -29,6 +29,7 @@ struct ocfs2_alloc_context {
>  #define OCFS2_AC_USE_MAIN  2
>  #define OCFS2_AC_USE_INODE 3
>  #define OCFS2_AC_USE_META  4
> +#define OCFS2_AC_USE_MAIN_DISCONTIG  5
>  	u32    ac_which;
>  
>  	/* these are used by the chain search */
> _
> 
> Patches currently in -mm which might be from heming.zhao@suse.com are
> 
> ocfs2-fixing-global-bitmap-allocating-failure-for-discontig-type.patch

