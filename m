Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5D71D5CEA
	for <mm-commits@vger.kernel.org>; Mon,  2 Feb 2026 03:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770001306; cv=none; b=PL3PMKcIAK2I0BLHONuK8o32931IbjrsIU3R6ja0tdpC57tVZYazjAB0/MLZ1gTldDFqLJ4QyuivK8NdjWHdjjf3/CG2bdmwRifxW+5KNQJPeA9JCYhdt5er+lZHdeo4TyErZnovNr6aSXtpacZ1Rl1jCN7qVpaTktsvNM9JD5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770001306; c=relaxed/simple;
	bh=vmtkan5sP5l9llZplvdAavrlmmvhsUKqqMITpUxGe3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=p/NQZaP0TWKB0dfJ2BoAMqVfFPu4sFXl5bzzQmpf2vU+vvgQyUW32rVIbuXSobmsArWvDCvmHDpNN4IRPWXPHoUm6xz7M9mjbU5whR6/NK31Q9//ZiLHm8N3e3Mcp48YgV7mPKqChFxsvE5c8nMx7AR8Vd2sbuzpKnAtmJ85JHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mdl7YIG5; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mdl7YIG5"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c65822dead7so1521246a12.3
        for <mm-commits@vger.kernel.org>; Sun, 01 Feb 2026 19:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770001304; x=1770606104; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ZqgtgUHkqRMpwNIOeIJntJiuuNaTyYu4y8n2nppDOA=;
        b=Mdl7YIG5bwA2NNxB4HUhnJN62X6bij5OXM8asmAxHPq0cXYxvnx+am/djxc5D0FZ7A
         kLqHm7nAQ4fTiEvOQoMNHwKQZXRD/ic0hCGEtBqvBplhn3uduv6KG2w+xFlla8fjGDHo
         gUE66CXjpL+bL/8Skg2R5JivFEGXzrIlktIjnlAInPRrkDrdU29N/3xo/UMRqG71eCbU
         xmfxZcmEDNC3jy4lA8Q8O5Ao1L0LyuQpDAenRaqZlfIAKDRxgsZzo/XWlsYQ8Bo83v/g
         EeKaIz5b9oBF6rnofaEoVnBW2GitfEwj/38+73xpft8xUNuIkrDJtai3NUtyf4pEqcQY
         otrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770001304; x=1770606104;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ZqgtgUHkqRMpwNIOeIJntJiuuNaTyYu4y8n2nppDOA=;
        b=UVCE2GdbSvZ4vdzFRkJo84OJi9KNwhq1xvSDR5WwtsPn5aBCpb4eQM33tvC/EuK7p0
         CRedOmz4v0bKguwyPlDOUdp3S3R4326vMsYiUQjUHesktgUvxI2XKPByBb+jL6iFjCEo
         8hdzjOtn4D+Xp1bEu4bDZxjZiP0nO9LVP55hr23/pcn813/za8vBYgmLMqCHXmRQl9GZ
         sDdGlrrHjwj0XuGOKs9YmIebKaGYx8pWcBMS1sbEU4sPHUf/gOKzigP2OlK/Y4/30B0Y
         O2KtPAdH6IqOH5cNcAA53nBsplYwQvaNrP/sewTX2ifdxDKtMrwQBf5KhfDLUZpdbz1S
         CrYw==
X-Gm-Message-State: AOJu0YxnfhLBrE9YU6fHmmDLBqn9bWSYJsIKtmKSZPzsILz5m7K3ANgC
	aqFmopKBSBJ5OeiKoB1c1JntKQw0WXxONC685a9SWMB1h6nWoPZf9X9G
X-Gm-Gg: AZuq6aJJJGedYEOeG7kDcvhRsFPRHJvStDAgPwTXEJtsQOYKAT4OboTrsjjLK8sLBKv
	yHCb+q++bbwJNzlGYe+eHrk5dmxgZNrFaWVyAuHhUAIx9CWovR8lkRLJJlfSpb4iZm5Kk2ASGyK
	XB7UCQyi9NVEU1foAtOPy/Qt7be1ITdvk7/d8Khcx0JDD7GwZGp+n7SBQQa3sSPosYzInLNI2VC
	5vkkY0tFs7j2VE2T/Qawfe8X6/oKCC+RLL6dJMD9aQQmWP+LdnRr9dEu75Skn7SSeAZjdc2zVUc
	k4hPk5CxNOU130jQ0sTyYYPJ79YWopZia8AjEbfr8GgJXOq5CqOuTeBRpB7vJGhYO721Qri5BX1
	QExJ/roLsAajL9YHRCm2KOWYMn+erhHJHcOf+H7x6ecsVwOHG65rdDJtOiwanswQfpk+3RINUUc
	5HPTrn7KFUYdirPuWNm8iAujtz4g==
X-Received: by 2002:a05:6300:404c:b0:35d:d477:a7d6 with SMTP id adf61e73a8af0-392e0000552mr8846286637.13.1770001304136;
        Sun, 01 Feb 2026 19:01:44 -0800 (PST)
Received: from [30.221.131.71] ([47.246.101.55])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c642add5199sm12174435a12.31.2026.02.01.19.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Feb 2026 19:01:43 -0800 (PST)
Message-ID: <dd7c7aaa-a08a-4706-9570-b34dd313f667@gmail.com>
Date: Mon, 2 Feb 2026 11:01:38 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch added to
 mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, swilczek.lx@gmail.com
References: <20260131235655.23B43C4CEF1@smtp.kernel.org>
From: Joseph Qi <jiangqi903@gmail.com>
Cc: mm-commits@vger.kernel.org, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20260131235655.23B43C4CEF1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Andrew,
As discussed in v1 thread, I also have questions for this solution.

Thanks,
Joseph

On 2/1/26 7:56 AM, Andrew Morton wrote:
> The patch titled
>      Subject: ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch
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
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Szymon Wilczek <swilczek.lx@gmail.com>
> Subject: ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
> Date: Thu, 8 Jan 2026 15:19:31 +0100
> 
> Move ocfs2_extend_no_holes() and ocfs2_start_trans() to execute before
> ocfs2_lock_global_qf() to fix a circular locking dependency reported by
> syzbot.
> 
> The issue occurs because ocfs2_start_trans() acquires sb_internal (via
> sb_start_intwrite) while already holding quota file locks (ip_alloc_sem
> and sysfile_lock_key).  This conflicts with freeze/dismount paths that
> acquire sb_internal first, creating the following circular dependency:
> 
>   sb_internal -> sysfile_lock_key -> ip_alloc_sem (freeze/dismount)
>   ip_alloc_sem -> sysfile_lock_key -> sb_internal (quota acquire)
> 
> Fix this by reordering the operations:
> 1. Speculatively extend quota file (uses need_alloc estimate)
> 2. Start transaction
> 3. Acquire global quota file lock
> 4. Perform quota operations
> 5. Release lock
> 6. Commit transaction
> 
> This ensures sb_internal is acquired before quota file locks, matching
> the expected kernel lock order.
> 
> Link: https://lkml.kernel.org/r/20260108141931.67110-1-swilczek.lx@gmail.com
> Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug\?extid\=51244a05705883616c95
> Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Joseph Qi <jiangqi903@gmail.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Jun Piao <piaojun@huawei.com>
> Cc: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/quota_global.c |   49 ++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 22 deletions(-)
> 
> --- a/fs/ocfs2/quota_global.c~ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot
> +++ a/fs/ocfs2/quota_global.c
> @@ -821,13 +821,35 @@ static int ocfs2_acquire_dquot(struct dq
>  	trace_ocfs2_acquire_dquot(from_kqid(&init_user_ns, dquot->dq_id),
>  				  type);
>  	mutex_lock(&dquot->dq_lock);
> +
> +	/*
> +	 * Speculatively extend quota file before acquiring any locks or
> +	 * starting transaction to avoid lock inversion. sb_start_intwrite
> +	 * (via ocfs2_start_trans) ranks above quota file locks.
> +	 */
> +	if (need_alloc) {
> +		WARN_ON(journal_current_handle());
> +		status = ocfs2_extend_no_holes(gqinode, NULL,
> +			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
> +			i_size_read(gqinode));
> +		if (status < 0)
> +			goto out;
> +	}
> +
> +	handle = ocfs2_start_trans(osb,
> +				   ocfs2_calc_global_qinit_credits(sb, type));
> +	if (IS_ERR(handle)) {
> +		status = PTR_ERR(handle);
> +		goto out;
> +	}
> +
>  	/*
>  	 * We need an exclusive lock, because we're going to update use count
>  	 * and instantiate possibly new dquot structure
>  	 */
>  	status = ocfs2_lock_global_qf(info, 1);
>  	if (status < 0)
> -		goto out;
> +		goto out_trans;
>  	status = ocfs2_qinfo_lock(info, 0);
>  	if (status < 0)
>  		goto out_dq;
> @@ -843,29 +865,12 @@ static int ocfs2_acquire_dquot(struct dq
>  	OCFS2_DQUOT(dquot)->dq_use_count++;
>  	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
>  	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
> -	if (!dquot->dq_off) {	/* No real quota entry? */
> +	if (!dquot->dq_off)	/* No real quota entry? */
>  		ex = 1;
> -		/*
> -		 * Add blocks to quota file before we start a transaction since
> -		 * locking allocators ranks above a transaction start
> -		 */
> -		WARN_ON(journal_current_handle());
> -		status = ocfs2_extend_no_holes(gqinode, NULL,
> -			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
> -			i_size_read(gqinode));
> -		if (status < 0)
> -			goto out_dq;
> -	}
>  
> -	handle = ocfs2_start_trans(osb,
> -				   ocfs2_calc_global_qinit_credits(sb, type));
> -	if (IS_ERR(handle)) {
> -		status = PTR_ERR(handle);
> -		goto out_dq;
> -	}
>  	status = ocfs2_qinfo_lock(info, ex);
>  	if (status < 0)
> -		goto out_trans;
> +		goto out_dq;
>  	status = qtree_write_dquot(&info->dqi_gi, dquot);
>  	if (ex && info_dirty(sb_dqinfo(sb, type))) {
>  		err = __ocfs2_global_write_info(sb, type);
> @@ -873,10 +878,10 @@ static int ocfs2_acquire_dquot(struct dq
>  			status = err;
>  	}
>  	ocfs2_qinfo_unlock(info, ex);
> -out_trans:
> -	ocfs2_commit_trans(osb, handle);
>  out_dq:
>  	ocfs2_unlock_global_qf(info, 1);
> +out_trans:
> +	ocfs2_commit_trans(osb, handle);
>  	if (status < 0)
>  		goto out;
>  
> _
> 
> Patches currently in -mm which might be from swilczek.lx@gmail.com are
> 
> ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch
> 

