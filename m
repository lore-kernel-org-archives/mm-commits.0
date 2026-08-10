Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05858284880
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 20:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393417; cv=none; b=hLNVXBtpzDN2x6u0CAqqjg9Xw/Rf9pE9ffa3jS+n8Xf8lymI6n2+p7xOpL6M+acsSsCZAyiqJq6X70hQXJ72OCRWCcrwhqFRl6OYNbdA7Dv6esDCEscUdkZuDol7FjRWwd1jxPatwuXu9BpN1uLHQRG6DWdu/rjVH2Pv4I7Pieg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393417; c=relaxed/simple;
	bh=OemExdP0ZG84LSgIQPiZJZv7P1Vpy+YkKStw1lKUiAo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=RPwMb81zac46pr7TZ3dmK1Dorn2A+TtxCCXG7GXDTiFsY/tbLVWIW65g7TvTft/Bz2L5H1GqH8G2fNE9uMvRSfbA8bF9Zv1BRBySEAjimRc8et06K9XEOukdeWu7oZAeBFyrfLCTd57MZSOD/EITvhKfUCuAKWBRoRC0kBRcdbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPO+gtNs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPO+gtNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9231F000E9;
	Mon, 10 Aug 2026 20:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786393415;
	bh=nqOA+3smWlYmWZnKA+ZlQGSHPttzuKCyY9xCjtxixKo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QPO+gtNsFr3mhwBGxeMw2VpABTVOyrysbpkvdqWcmpGnvPQyOOkxUkdYvxiR2i+Gx
	 S7I2fmr9RncPOQU8Q5pnKg2U5eKlbWiIACs8PCewD65+Z1h43EgCVu5Ya2BitLmULj
	 am4pe5Mf3aHDbEKo6bn4kNMCeYCzRhjiEiZ5BUpM=
Date: Mon, 10 Aug 2026 13:23:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Stanislav Kinsburskii
 <skinsburskii@gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-Id: <20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
In-Reply-To: <202608101053.PhnVUM4u-lkp@intel.com>
References: <202608101053.PhnVUM4u-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 10:44:13 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: e0ffd277b09a7c9f1a436e5f75be37ac490bc59f  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> 
>     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> 
> Warning ids grouped by kconfigs:

Thanks.  I assume this warning was produced by sparse?  The report
doesn't tell us this, and I suggest that it do so.

> recent_errors
> `-- s390-randconfig-r071-20260809
>     `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

Caused by

	121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")


Stanislaw, you've previously said that this is a can't-happen, but boy
I'm getting tired of seeing this warning report.  Would the below change
hurt anything?  I can't immediately think of a cost-free way of doing
this.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hmm.c:hmm_do_fault(): suppress sparse warning
Date: Mon Aug 10 01:16:37 PM PDT 2026

mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Stanislav says this can't happen.  Waste a few cycles to make the warning
go away.

Fixes: 121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202608101053.PhnVUM4u-lkp@intel.com
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-hmm_do_fault-suppress-sparse-warning
+++ a/mm/hmm.c
@@ -670,7 +670,8 @@ static int hmm_do_fault(struct mm_struct
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			*hmm_vma_walk->locked = false;
+			if (hmm_vma_walk->locked)	/* needed by sparse */
+				*hmm_vma_walk->locked = false;
 			return HMM_FAULT_UNLOCKED;
 		}
 
_

