Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19A57262B
	for <mm-commits@vger.kernel.org>; Sun, 15 Mar 2026 22:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773613708; cv=none; b=IHk4S/KQ4g7pn/TUfKqr8Zf2MzUkedCaqXkycBIGuzJ0WFvLdaBSC39glaIVHkyBl1eXBow0xaVGUD8aHlkrglOQWkBhLbVqPLaLGxDCo7f3VW9zqbPWWWVmSBjLlFyathLh32lmOQCMJRXG9H5AQJPyquek+q+eUbgoQLxcous=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773613708; c=relaxed/simple;
	bh=7CwVkOCfIT05S84MkZXqul+2LwH554vcW5JzOBj9MSA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=ez/LM67jT0slR2GyRmE/Pj1xmSX+ykVw79xa2UhlN9qUtbRs9io8V6B5ha6lg+7yCKPN/ecJGkGskbEypdn0c3aEf39tojrGulm05FiszKIto8VBzmoT89ejNtM5d6UdN4qbVTy6hh75LoL19vHoulQtA1+ygkicai+DslYeSJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iivkr75O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iivkr75O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:References:To:Subject:From:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=uMfej4JBii9T5tXlHy8c12EEC95/Ulg6vSlYq0DZYYo=; b=iivkr75OORN1eOFoISSLe+XF1/
	CKyGfNSDmpribDUlTzjxjZw8HBQyiLrXmWuHs/MKXWyNz3sa/k2QBLMhfMtWLcJYvYUbpVJtTH+cN
	FsPpPJpD9uUVFp0UwjrwNN6ph53FyXaHz8yIBrbHn9O8AYziHITwegEATzEYneN5qr6s9tXbVmMRF
	LnoHuqL/yjn3WqB+Uae9pJYBxL4nFcRZm/VEHH4Fw3RIS22OxFYw7rH86fRv2C2Ux2HKRPAM2DTwv
	eJhd+ykH+LuqQqvJ9cr1DIvTInY+owxmV2wBFNWX//6zDg6W9X8GzyyfVIN1yeY1TJQ8WkP3lmCHA
	GzvBMlMw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w1twc-00000002y9C-2Kw9;
	Sun, 15 Mar 2026 22:28:22 +0000
Message-ID: <cbaec2e4-9d53-417d-bfec-6a0a40e86553@infradead.org>
Date: Sun, 15 Mar 2026 15:28:21 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: + mm-add-mmap_action_simple_ioremap-fix.patch added to mm-new
 branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ljs@kernel.org
References: <20260314232107.C989EC116C6@smtp.kernel.org>
Content-Language: en-US
In-Reply-To: <20260314232107.C989EC116C6@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/14/26 4:21 PM, Andrew Morton wrote:
> The patch titled
>      Subject: mm-add-mmap_action_simple_ioremap-fix
> has been added to the -mm mm-new branch.  Its filename is
>      mm-add-mmap_action_simple_ioremap-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_action_simple_ioremap-fix.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> The mm-new branch of mm.git is not included in linux-next
> 
> If a few days of testing in mm-new is successful, the patch will me moved
> into mm.git's mm-unstable branch, which is included in linux-next
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-add-mmap_action_simple_ioremap-fix
> Date: Sat Mar 14 04:19:36 PM PDT 2026
> 
> randyfy mmap_prepare.rst
> 
> Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

That change LGTM.
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>


Not related to this patch, but at line 98 of
mmap_prepare.rst I now see a reference to
struct vma_area_desc. I think that should be
struct vm_area_desc. (?)

For some reason 'git grep vma_area_desc' does not even
find one occurrence of that string for me, while
good ole 'grep -rs vma_area_desc' does find it.

> 
>  Documentation/filesystems/mmap_prepare.rst |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/Documentation/filesystems/mmap_prepare.rst~mm-add-mmap_action_simple_ioremap-fix
> +++ a/Documentation/filesystems/mmap_prepare.rst
> @@ -127,7 +127,7 @@ pointer. These are:
>  * mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remaps
>    the entire mapping from ``start_pfn`` onward.
>  
> -* `mmap_action_simple_ioremap()` - Sets up an I/O remap from a specified
> +* mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
>    physical address and over a specified length.
>  
>  **NOTE:** The ``action`` field should never normally be manipulated directly,
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
> maple_tree-add-cp_is_new_root-helper-fix-fix.patch
> mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
> mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
> mm-rename-zone-lock-to-zone-_lock-fix.patch
> mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
> mm-various-small-mmap_prepare-cleanups-fix.patch
> mm-add-mmap_action_simple_ioremap-fix.patch
> mm-add-mmap_action_map_kernel_pages-fix.patch
> kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
> decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
> 

-- 
~Randy
