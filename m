Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EE6155398
	for <mm-commits@vger.kernel.org>; Sat, 16 Nov 2024 01:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731719734; cv=none; b=ITCKX9OD8RO8U2qW76CdOYUjD9u7QiKEzyYQHSSLnTYx60f4ZiVzG6XJGT4PeHGBuH4jFuXepfLzXBLv1JAx69OUuH4UGHO8FTmHpKOtKTnFq7p1gtd5GoFUEbiAppITQfLBTAtONzsQguH/4cat7hyysMgMXtroghvbJ63T5/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731719734; c=relaxed/simple;
	bh=zMUQZOCpZMQ/dKSc6ZVQ1W83Gl82z5d9JySnnvZROUk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=szxRTXdPyuTblgtinlvuEYzs22dr8IQICpcLAZkNAwDxZBCoGowfho1+KjDr5R1BE0v60E8QlStYQFjv6v4M8SjhgIPk1CEnEoQqDRLxzg63rIS9uqLbnp6utnrEqjx3Y7WUzgqMuoMd87eWZ+82WCuOW/TzUkJ4+SnJf7e81Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=og9I91Di; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="og9I91Di"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3e5f533e1c2so1284568b6e.3
        for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 17:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731719732; x=1732324532; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W3QI0B5maEg+/aEXJBItWHclgyMXYLApaat8l+0kJnA=;
        b=og9I91Dir62eotvvSzP8D81HEy2X+v0B/wN/pF1J8N2UjjUOuU8yfCE/UcuRfIVuFp
         4dOeGp4tqK3zzk4bssAs+AE+5t0ZeXAoUaiDhjBYZZVNygm/OV7cNukguADtNUS7KN4+
         j39rzdHDDSFNWOq2oeisZ9vP6QxjO34I7fTkgvol6vhBDrmgoaTUolYIFUiX1ZmV/2u0
         ilJvxM+QaO8upeYwR83Dl2jXJ/2ATdO0NqoDeBO75/OLaK3O2dgDC4zUe1NFfO51ILrh
         PJQxRQnrokNImoBVuD4YBp4nqW5gBPxP1Dj8QkBlPL27jW+DKwT2xHboVr/sVXre2f0g
         ZNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731719732; x=1732324532;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W3QI0B5maEg+/aEXJBItWHclgyMXYLApaat8l+0kJnA=;
        b=tdGtxrrslKrSRDa7n9E2ELtjf3HxBgFvEx04lA/94bJ43JdTw4Bf/Obq3cTOcvnhxE
         Dcm6REB1fVALP6yJC0laZ2SxmKtKUndDU+JAJOtPTlZkj7BG7RDvo8+fklM4VnkJyojh
         +oQRS6qAiHCGxWPGr9jGF7LRO3irrdClHA2Wj/Uwy1nZJcOPGl7QmlOwrNhfwYust2G4
         9kqghXqMlWNDTc+08jFpgZEI+T+EOUf9SFW/eqnSPV+JnpNRGTBsMChOO5ppU3CFNVv/
         97JtyrBR6MfTE87r86hYWEsUzOwJwNp9RoaXWlmdaGJxVMHX0gAor5TbEwYhQx1aI4/X
         Gcpg==
X-Gm-Message-State: AOJu0Yyfiyjk52KLOjB1VmJrEeiyF101jmqaWSOZfp40ikYrCXGk36Me
	v13NZoq9ijGutinS+fQT0DNUzhde+PVtJw2gbx/G7cRr9bggjgTwRg7lvAOk8w==
X-Google-Smtp-Source: AGHT+IFeCD8ZVgWdH34gSgJYIxjLsEKdeBaXUMar4RlXXY3UJD97gcwnL5d0iQyeGaj7c8TVzztT4w==
X-Received: by 2002:a05:6870:50c:b0:288:6644:9c1c with SMTP id 586e51a60fabf-2962dc7dbe7mr4863024fac.6.1731719731855;
        Fri, 15 Nov 2024 17:15:31 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71a781a1b5csm980115a34.48.2024.11.15.17.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 17:15:30 -0800 (PST)
Date: Fri, 15 Nov 2024 17:14:43 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mm-commits@vger.kernel.org, yuzhao@google.com, stable@vger.kernel.org, 
    hughd@google.com, chuck.lever@oracle.com, aha310510@gmail.com
Subject: Re: + mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch added
 to mm-hotfixes-unstable branch
In-Reply-To: <20241116010055.48A67C4CECF@smtp.kernel.org>
Message-ID: <313876af-1755-7a86-60a2-678ffcf34bea@google.com>
References: <20241116010055.48A67C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 15 Nov 2024, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: revert "mm: shmem: fix data-race in shmem_getattr()"
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm: revert "mm: shmem: fix data-race in shmem_getattr()"
> Date: Fri Nov 15 04:57:24 PM PST 2024
> 
> Revert d949d1d14fa2 ("mm: shmem: fix data-race in shmem_getattr()") as
> suggested by Chuck [1].  It is causing deadlocks when accessing tmpfs over
> NFS.
> 
> Link: https://lkml.kernel.org/r/ZzdxKF39VEmXSSyN@tissot.1015granger.net [1]
> Fixes: https://lkml.kernel.org/r/ZzdxKF39VEmXSSyN@tissot.1015granger.net
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

Thanks Andrew, I was just in the course of preparing the same
to rush to Linus: I'll leave that to you now.

> Cc: Jeongjun Park <aha310510@gmail.com>
> Cc: Yu Zhao <yuzhao@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/shmem.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- a/mm/shmem.c~mm-revert-mm-shmem-fix-data-race-in-shmem_getattr
> +++ a/mm/shmem.c
> @@ -1166,9 +1166,7 @@ static int shmem_getattr(struct mnt_idma
>  	stat->attributes_mask |= (STATX_ATTR_APPEND |
>  			STATX_ATTR_IMMUTABLE |
>  			STATX_ATTR_NODUMP);
> -	inode_lock_shared(inode);
>  	generic_fillattr(idmap, request_mask, inode, stat);
> -	inode_unlock_shared(inode);
>  
>  	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
>  		stat->blksize = HPAGE_PMD_SIZE;
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
> mm-revert-mm-shmem-fix-data-race-in-shmem_getattr.patch
