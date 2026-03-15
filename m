Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58F17262B
	for <mm-commits@vger.kernel.org>; Sun, 15 Mar 2026 22:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773613712; cv=none; b=rgbkyQlfVNkCKSnMQwYFt9b5bt5mXCmAuiZxfJSV2Fnww3f4WeIEZ06X+/kxSfZ3Sik4IJarcBV0f85W4q7FiPdVB/7C1pmRaRV7F/uiG+f42Tu3HeAdDjwjFZiHHiNJi+2BbL2YOb3zRdSlDWGzrR8Wrnc7JiDM4h7mJBqu9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773613712; c=relaxed/simple;
	bh=Bsj9kfeXKidpffULh3ymzcTHwomo+amtdgpvtlq2rIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=flGe+03zUqTQKL3WZ7KZ3v6OeGLI0CiYUX4NWj006nenkAuyxQjiVXcpCocE/Z3so73VwD/v9O2oViiP0LXtG/SDOMu7o4x2egauFORfzskV94LF9FDsvWlyTBthYUybSp9PyNO2Q8NmNY3HanNGMVjhNh4rVaBfK84VCz/BwcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Zw8/0JNC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zw8/0JNC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
	bh=cf57Hz0JCY3qMX3uDCicuVGXagPrm85jcc9KCVkQjug=; b=Zw8/0JNC5Ss7du2pg4D9pIqmGE
	S1fx+ggYpxHu0CT5XCKWcwp9Rw4qVwdLFs+vp3tNZNHlXZC74VEebPfQE/CalGaKoyuoF67a0J0yp
	jSyjvZ2A9tITV4N3NsJqhPCgGjZmk4J/mp/uLu8r1tv57xheAuYuCeVlA3HM9ma0z7SFCZ2G6EfIn
	sT//vS+iyER3V1yJmOUAx7mAN2hL7VISHdbCUImivmudgt8klfeLlErOd8N56OJ1OuR0qHuvd93MF
	4biriPJN1/k3lG7G+5g7mHXL+BVjKKamn4D0zS1WMyDZEA5gzekKrD9zAISusRJLDZEPuiubINDa0
	SZu83AjQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w1twj-00000002y9j-1ZuP;
	Sun, 15 Mar 2026 22:28:29 +0000
Message-ID: <b8128160-2ff4-4c4b-b307-6bc070514ca6@infradead.org>
Date: Sun, 15 Mar 2026 15:28:29 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-add-mmap_action_map_kernel_pages-fix-2.patch added to mm-new
 branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ljs@kernel.org
References: <20260314232908.73E42C116C6@smtp.kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260314232908.73E42C116C6@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/14/26 4:29 PM, Andrew Morton wrote:
> The patch titled
>      Subject: mm-add-mmap_action_map_kernel_pages-fix-2
> has been added to the -mm mm-new branch.  Its filename is
>      mm-add-mmap_action_map_kernel_pages-fix-2.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_action_map_kernel_pages-fix-2.patch
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
> Subject: mm-add-mmap_action_map_kernel_pages-fix-2
> Date: Sat Mar 14 04:27:41 PM PDT 2026
> 
> randyfy mmap_prepare.rst
> 
> Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

LGTM. Thanks.
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

> 
>  Documentation/filesystems/mmap_prepare.rst |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/Documentation/filesystems/mmap_prepare.rst~mm-add-mmap_action_map_kernel_pages-fix-2
> +++ a/Documentation/filesystems/mmap_prepare.rst
> @@ -130,10 +130,10 @@ pointer. These are:
>  * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
>    physical address and over a specified length.
>  
> -* `mmap_action_map_kernel_pages()` - Maps a specified array of `struct page`
> +* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
>    pointers in the VMA from a specific offset.
>  
> -* `mmap_action_map_kernel_pages_full()` - Maps a specified array of `struct
> +* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
>    page` pointers over the entire VMA. The caller must ensure there are
>    sufficient entries in the page array to cover the entire range of the
>    described VMA.
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
> mm-add-mmap_action_map_kernel_pages-fix-2.patch
> kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
> decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
> 

-- 
~Randy
