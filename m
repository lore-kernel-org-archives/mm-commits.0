Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A7942A80
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 01:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776216696; cv=none; b=b4NdSMA/KNMIMy5KOyk7Lw2jhFGWt+bCUiOGchvt8OS7Atxqz/AbJCGTV79ouRBbmC8bFl8E2z61zVSFTooYVd8b7CZEyPXr3iqUOKDQksMI1oapQgMypXaH+y8Q84+7nRVU+5DqAm1i7Ds/y8wPRWsRo8wxgfZmKfSE8dPI60g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776216696; c=relaxed/simple;
	bh=zWqV/wFPA1lui55mFnCOenmJKfZ1r7XMn1N8ElqBfPw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=dsyr6DM63KVG+Nj7FfzgSUcfOwpMxtW+QwEGQ7xWW8tJ5Y3RcUqZqSqMtpBjclT7euhsqvKKt/6z3aX0ctwhLDTqOhUuJk2aXLDe6pf6dGcpL+g7Z7bw8p6/8F+QHaP0skM4pLx1G2ZwX4L3XtbzIZzo5AQXsL/JQmdyJZAzGfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pIt542mQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pIt542mQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D19C19425;
	Wed, 15 Apr 2026 01:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776216696;
	bh=zWqV/wFPA1lui55mFnCOenmJKfZ1r7XMn1N8ElqBfPw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pIt542mQl7bAUyks3rHz5xlQld7lqV2pSZLkOu6HcnZ0JQkymFnYoWn+Kp+I1Duru
	 SEN0QA2oDYKS9RxNedItI6QNepCF4hcv7NnGcaWHu/z0eswqUbabJJ1bW/SY+nQLc7
	 o9HjtXYehRcXnyYgU+jOvQxC+WgWnKSMqKjqfKQc=
Date: Tue, 14 Apr 2026 18:31:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com,
 ying.huang@linux.alibaba.com, thomas.hellstrom@linux.intel.com,
 rakie.kim@sk.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 jhubbard@nvidia.com, jgg@ziepe.ca, gourry@gourry.net, byungchul@sk.com,
 balbirs@nvidia.com, apopple@nvidia.com, dave@stgolabs.net
Subject: Re: [merged]
 mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd.patch
 removed from -mm tree
Message-Id: <20260414183130.891b1717c772f044f35ead10@linux-foundation.org>
In-Reply-To: <460b74aa-8840-4390-80de-4ce39251b83d@kernel.org>
References: <20260310201608.E6F5AC19423@smtp.kernel.org>
	<460b74aa-8840-4390-80de-4ce39251b83d@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Apr 2026 12:05:37 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > --- a/mm/migrate_device.c~mm-migrate_device-remove-dead-migration-entry-check-in-migrate_vma_collect_huge_pmd
> > +++ a/mm/migrate_device.c
> > @@ -175,12 +175,6 @@ static int migrate_vma_collect_huge_pmd(
> >  			return migrate_vma_collect_skip(start, end, walk);
> >  		}
> >  
> > -		if (softleaf_is_migration(entry)) {
> > -			migration_entry_wait_on_locked(entry, ptl);
> > -			spin_unlock(ptl);
> > -			return -EAGAIN;
> > -		}
> > -
> >  		if (softleaf_is_device_private_write(entry))
> >  			write = MIGRATE_PFN_WRITE;
> >  	} else {
> > _
> > 
> > Patches currently in -mm which might be from dave@stgolabs.net are
> 
> Andrew, was this patch dropped by mistake?

It might have been.  What can happen is that I was told it was being
taken into a different tree but then it wasn't, (which is why I usually
hang onto things until Mark reports the duplicate).  But I can't
immediately find a thread about that.

I brought it back, thanks.
