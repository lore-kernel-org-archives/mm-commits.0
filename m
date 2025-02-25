Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2887C14658C
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 15:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740497123; cv=none; b=pkf51WJk4aYBPxLpYR/MGXW7FCpQq4iQ1+gIwoEMQu30ry0vcwf3CHLNU7otkS505Wytg6Tm5RzS7vfXhPe8ulaSNbOR9IG4LDnEWwZlSag7o1vPDZRn7ihfgcsAiRXD2U7dqlYm7ayTk0yoxUfhKKkRY/NBTwSdLyNauiyedMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740497123; c=relaxed/simple;
	bh=3dLGsAoEFCljfS2TEjoEsAp2+oEEB823YWF2gJZBoDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRTBRSGCEIiEGIVdmKbAH8S/r+qysUrCeb4szOyA6oMPnOKpHJo522u4GkYL8qi8pvb5lFl4PnWCzufzACBNugQOzkyku2e8+nUOrsCg3P1ErUYKPwSBUYGuxTDm5yxJuSP0gKtGxGNU9MPmOp+dwmKpSOmA3nfVWRJd0aXzzp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HABDZZB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HABDZZB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59873C4CEDD;
	Tue, 25 Feb 2025 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740497122;
	bh=3dLGsAoEFCljfS2TEjoEsAp2+oEEB823YWF2gJZBoDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HABDZZB4Q/JXtZ4kNAOlbZq9JvOPx8OQuRXOkg8Lpd+ElzXXSYAey8lkWfJFkntDH
	 HQCtcODb32kAQvfJOBW6wn3rBjQnEDDvfOyUnjLTSr24z/Pw6HBYEBWPzfgYVr2MtR
	 puo//d9X2cRt+t6H0EJJ2+FeF9ki88SVL1PDjlmiTGuNvmBdCsr4PexkldbFJ5QSYZ
	 4fYqMGVzxy5D0FUaHskRXoCwJjvd3SJdvqtFRW0EDBonqNPXIaznPofxH+hEA2TpUo
	 pF1TU5b6rZhu+n/jn1UGSV6FlPh/b/Zf+YstFchG8scn29UbkEPHXoyOM5WHd6qXUi
	 d35NoHegCPGPg==
Date: Tue, 25 Feb 2025 10:25:21 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
	anna.schumaker@oracle.com
Subject: Re: +
 nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
 added to mm-hotfixes-unstable branch
Message-ID: <Z73g4bjBLh9SyKUC@kernel.org>
References: <20250225065454.722B4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225065454.722B4C4CEE7@smtp.kernel.org>

Hi Andrew,

Comment and question inlined below.

On Mon, Feb 24, 2025 at 10:54:53PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
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
> Subject: nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
> Date: Mon Feb 24 10:53:31 PM PST 2025
> 
> fix build
> 
> Cc: Anna Schumaker <anna.schumaker@oracle.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/compaction.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/compaction.c~nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
> +++ a/mm/compaction.c
> @@ -3181,7 +3181,7 @@ static int kcompactd(void *p)
>  	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
>  	long timeout = default_timeout;
>  
> -	tsk->flags |= PF_KCOMPACTD;
> +	current->flags |= PF_KCOMPACTD;
>  	set_freezable();
>  
>  	pgdat->kcompactd_max_order = 0;
> @@ -3238,7 +3238,7 @@ static int kcompactd(void *p)
>  			pgdat->proactive_compact_trigger = false;
>  	}
>  
> -	tsk->flags &= ~PF_KCOMPACTD;
> +	current->flags &= ~PF_KCOMPACTD;
>  
>  	return 0;
>  }

I wrote my patch against stable 6.12.16 and didn't think to check
latest code (sorry!).  I can easily see we need your fix given commit
54880b5a2b5e ("mm: Create/affine kcompactd to its preferred node").

Will you fold your fix before sending to Linus or should I send a
proper v3 patch rebased to latest code?

Thanks,
Mike

> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
> mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
> mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
> mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
> lib-plistc-add-shortcut-for-plist_requeue-fix.patch
> 
