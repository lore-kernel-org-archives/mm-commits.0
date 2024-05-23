Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B982C136A
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 01:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716426159; cv=none; b=bidZ/JsU7T43t0GaMrqsLhJrwl8fO4TiSjITBVW2hAhPPLg4p+uWiEzd25Aeln0DfLw2IkZjqU719pkmgzdRSPOPCxslS2sbP161KhrnuxxLijiqIoe+KtW2p66gDQ6jFqSczFyWIPSKsgU7cobf0kMVlhDyhG7eZUi1Q8rE9z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716426159; c=relaxed/simple;
	bh=6xNk563QGtbRp/owTEKFvlW56ArY2Ac2jSPNnUkl5VQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Mu2gkowPyYNVIIXoeB/o7nmli17nQHwsmWDqHw8/XAUgd5O/9tQNP1oyJ5Ds3bRbdxf+krAaP7p0PwzsRlZhtv0psq0O6eHr5avdRfkS2JJ3P8BioN3iMhlWz+NEgVTRyFsWcwnfWOOcvYBNM2U0oZPxC2T2W9XZ5DUUdzJWlrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SH1atWVa; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SH1atWVa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716426154; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Syyssvk6MafiUTHS3t+LSGcAdmH1YyajvMPuYSuAa1I=;
	b=SH1atWVaKMmGqkec8tScpePLZQKK6Z+OjJf6kekBEhc2K6iXYr+nmEQn7m/lja6J3aE/ZnSccbqQrrWEjy3ST/UGf1o6+akxmaznqScSR6VeYUDNPmh2Q5tBH8iy7dms/EK3+IlzLf3NVudR+094+zS+V5tTivNiGT331jje/Hs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067111;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0W70dqR2_1716426152;
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W70dqR2_1716426152)
          by smtp.aliyun-inc.com;
          Thu, 23 May 2024 09:02:33 +0800
Message-ID: <f1d1be10-886e-4abb-898b-b046b98d48f7@linux.alibaba.com>
Date: Thu, 23 May 2024 09:02:32 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch added
 to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 piaojun@huawei.com, mark@fasheh.com, llfamsec@gmail.com,
 junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
 mengferry@linux.alibaba.com
References: <20240522221330.DF107C2BBFC@smtp.kernel.org>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240522221330.DF107C2BBFC@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/24 6:13 AM, Andrew Morton wrote:
> The patch titled
>      Subject: ocfs2: add bounds checking to ocfs2_xattr_find_entry()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch
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
> From: Ferry Meng <mengferry@linux.alibaba.com>
> Subject: ocfs2: add bounds checking to ocfs2_xattr_find_entry()
> Date: Mon, 20 May 2024 10:40:23 +0800
> 
> Add a paranoia check to make sure it doesn't stray beyond valid memory
> region containing ocfs2 xattr entries when scanning for a match.  It will
> prevent out-of-bound access in case of crafted images.
> 
> Link: https://lkml.kernel.org/r/20240520024024.1976129-1-joseph.qi@linux.alibaba.com
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>Reported-by: lei lu <llfamsec@gmail.com>

Seems malformed.

> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Jun Piao <piaojun@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/xattr.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> --- a/fs/ocfs2/xattr.c~ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry
> +++ a/fs/ocfs2/xattr.c
> @@ -1062,7 +1062,7 @@ ssize_t ocfs2_listxattr(struct dentry *d
>  	return i_ret + b_ret;
>  }
>  
> -static int ocfs2_xattr_find_entry(int name_index,
> +static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
>  				  const char *name,
>  				  struct ocfs2_xattr_search *xs)
>  {
> @@ -1076,6 +1076,10 @@ static int ocfs2_xattr_find_entry(int na
>  	name_len = strlen(name);
>  	entry = xs->here;
>  	for (i = 0; i < le16_to_cpu(xs->header->xh_count); i++) {
> +		if ((void *)entry >= xs->end) {
> +			ocfs2_error(inode->i_sb, "corrupted xattr entries");
> +			return -EFSCORRUPTED;
> +		}
>  		cmp = name_index - ocfs2_xattr_get_type(entry);
>  		if (!cmp)
>  			cmp = name_len - entry->xe_name_len;
> @@ -1166,7 +1170,7 @@ static int ocfs2_xattr_ibody_get(struct
>  	xs->base = (void *)xs->header;
>  	xs->here = xs->header->xh_entries;
>  
> -	ret = ocfs2_xattr_find_entry(name_index, name, xs);
> +	ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
>  	if (ret)
>  		return ret;
>  	size = le64_to_cpu(xs->here->xe_value_size);
> @@ -2698,7 +2702,7 @@ static int ocfs2_xattr_ibody_find(struct
>  
>  	/* Find the named attribute. */
>  	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
> -		ret = ocfs2_xattr_find_entry(name_index, name, xs);
> +		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
>  		if (ret && ret != -ENODATA)
>  			return ret;
>  		xs->not_found = ret;
> @@ -2833,7 +2837,7 @@ static int ocfs2_xattr_block_find(struct
>  		xs->end = (void *)(blk_bh->b_data) + blk_bh->b_size;
>  		xs->here = xs->header->xh_entries;
>  
> -		ret = ocfs2_xattr_find_entry(name_index, name, xs);
> +		ret = ocfs2_xattr_find_entry(inode, name_index, name, xs);
>  	} else
>  		ret = ocfs2_xattr_index_block_find(inode, blk_bh,
>  						   name_index,
> _
> 
> Patches currently in -mm which might be from mengferry@linux.alibaba.com are
> 
> ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch
> ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch
