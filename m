Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935C5193
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 01:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716426048; cv=none; b=Sp2fvtkxFE7mOlTKj4Cj62vAUj7mHUAbK5tpTZ0YweyAUSU/Ah+JoL1bhNSUR/6gtxuPmbqUjvCLN86OTdw7QcCAdSqHZSuvxBcFzah7jzW5jTnGWSXSLa+7i+DVQX1kQGYktc/rog5vV/GkU5WwxfW+4+gihmTTTh0cjTfcvD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716426048; c=relaxed/simple;
	bh=Gw+WVBJxe+vZCNHV6OZ1gjiNjyDJbscwJtzWWVksSWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B8WwOibu4DzCAVYRcGdZWTfDs4W4YEZ+LFbNB/nJDQag3hoqDoN+KGD659HkxNks/l5jhdoXNs0BQuueUJqLhaB8fCWvCFVzVrjFgvDvFrBfpDfWolcsh+wjQxGiCNTofx1oo2qZd/Ty3RGasdUT+wn0AaZ+yWsZu1JZV3NCmWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=f6M1bOkC; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="f6M1bOkC"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716426043; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dSxkAUCs8eQaKQK8T9v8od1hNa1cyHujL7Qn7fSEkfI=;
	b=f6M1bOkCEvdNNv5c3mtw3o5bDLpIoXw+re1nBJcrWe0g7uqTb3uF0WrgT2oJJurAp3sjSJNAv1h2pF7mLH5uukrvsJKzbz6C+Qn/siDWWi0FNdlgKMmQZXwti9Q1E2bLRJip+azBO6iBpD6c2XcY0E9viAb7ZNDNHF6P2vQ7OSw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067111;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0W70kmFA_1716426041;
Received: from 30.221.128.145(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W70kmFA_1716426041)
          by smtp.aliyun-inc.com;
          Thu, 23 May 2024 09:00:42 +0800
Message-ID: <47fbfd42-5ed8-407b-a04d-e1dff15b4feb@linux.alibaba.com>
Date: Thu, 23 May 2024 09:00:41 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch added
 to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 piaojun@huawei.com, mark@fasheh.com, llfamsec@gmail.com,
 junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
 mengferry@linux.alibaba.com
References: <20240522221332.7F1FFC3277B@smtp.kernel.org>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20240522221332.7F1FFC3277B@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/24 6:13 AM, Andrew Morton wrote:
> The patch titled
>      Subject: ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch
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
> Subject: ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
> Date: Mon, 20 May 2024 10:40:24 +0800
> 
> xattr in ocfs2 maybe 'non-indexed', which saved with additional space
> requested.  It's better to check if the memory is out of bound before
> memcmp, although this possibility mainly comes from crafted poisonous
> images.
> 
> Link: https://lkml.kernel.org/r/20240520024024.1976129-2-joseph.qi@linux.alibaba.com
> Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
> Signed-off-by-by: Joseph Qi <joseph.qi@linux.alibaba.com>

A typo here.
s/Signed-off-by-by/Signed-off-by

> Reported-by: lei lu <llfamsec@gmail.com>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Jun Piao <piaojun@huawei.com>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/xattr.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> --- a/fs/ocfs2/xattr.c~ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry
> +++ a/fs/ocfs2/xattr.c
> @@ -1068,7 +1068,7 @@ static int ocfs2_xattr_find_entry(struct
>  {
>  	struct ocfs2_xattr_entry *entry;
>  	size_t name_len;
> -	int i, cmp = 1;
> +	int i, name_offset, cmp = 1;
>  
>  	if (name == NULL)
>  		return -EINVAL;
> @@ -1083,10 +1083,15 @@ static int ocfs2_xattr_find_entry(struct
>  		cmp = name_index - ocfs2_xattr_get_type(entry);
>  		if (!cmp)
>  			cmp = name_len - entry->xe_name_len;
> -		if (!cmp)
> -			cmp = memcmp(name, (xs->base +
> -				     le16_to_cpu(entry->xe_name_offset)),
> -				     name_len);
> +		if (!cmp) {
> +			name_offset = le16_to_cpu(entry->xe_name_offset);
> +			if ((xs->base + name_offset + name_len) > xs->end) {
> +				ocfs2_error(inode->i_sb,
> +					    "corrupted xattr entries");
> +				return -EFSCORRUPTED;
> +			}
> +			cmp = memcmp(name, (xs->base + name_offset), name_len);
> +		}
>  		if (cmp == 0)
>  			break;
>  		entry += 1;
> _
> 
> Patches currently in -mm which might be from mengferry@linux.alibaba.com are
> 
> ocfs2-add-bounds-checking-to-ocfs2_xattr_find_entry.patch
> ocfs2-strict-bound-check-before-memcmp-in-ocfs2_xattr_find_entry.patch
