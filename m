Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCEC320F
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 03:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729913684; cv=none; b=qqqhnxVGw6M1cwAcTrtm8/fa1tLKR1zybCOso1phXwhShlVi+K7ocwGMGxv/qRQ0FCT797bUpnVnOfbCyMfbY3u+9PZFN48VVk8RPHWircda+89j4IRlzdMQ4yW5RwcH8GMd/l1cnkGjok22pcXm/xWD+7f7iZAEl2Xj91luLH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729913684; c=relaxed/simple;
	bh=oEeqUTpnsSbds/Pw88qyWAEJl5/tk6ze0ISMgOsFmoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OD1yqNBEkfdaeBbqBrs05j1ldbMMIa3SnMDrQRSChf5c4r6f2L8ci/vuR1ut7QCZYtQ6urTvd79tHdLJK71JESbaaI4NJt7ITZap5YBtH9iV+sGGnCYgHyV/4eW7B7Z2HWkeZY5V0sHFzkGJbb9tqmxfMuevBgGoh8VHs4l2TzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=by48URWf; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="by48URWf"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5cb72918bddso3433849a12.3
        for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 20:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729913680; x=1730518480; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AQL9xvWMJSlhkbFPcmaC7OwddoMW6CvC6pSsRHlz5c=;
        b=by48URWf2zJNXw0OROsDIof9GCifpEapm3I7tSUmzsKYpKiybu3tQZpY7fUVTkYa7n
         zIY/MGdsM7TNVOM6XdNVJ0+ZkRT1i6HAXBUt1bFQf30qEWqT0eclPcXTastvAB7Qvhvy
         mZyV5690Nmqhs29sVk1daa0jYrzPIpKj7lXIrCi9YS+YyoEcfTq9Lnzl4OxyCfxymCC+
         MJQZ44YiHI08PJoFkvOD7AHf7HNVmVe/Pwp66tdsEJZYbMTli1EBCISKO4IO87LGpEZC
         3wokrN/aLcJH7ppj1IQkFbkFoC8oGFJ+MzdoGi5PXbhKK0tj+ycALmDc0WGQfDwn4Ffn
         ub7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729913680; x=1730518480;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/AQL9xvWMJSlhkbFPcmaC7OwddoMW6CvC6pSsRHlz5c=;
        b=cMCenPBP1iuf4DJOLsjb7kab8vdzVg7e19UZ2R+23Lb5q1BWb6v94At8iLxg5NBoYM
         7HAG12IQlOe2JOUladXmxUeUv67vEQNTnWUG9G81wHCxFRED8Wni6TvIu3Mn7uGl7YTc
         LGkI/emofo8I61zE3iLBufmCPgtfC1mTtOOnp+Co0fF4lZEFpeuo6I+t85d4hSYI0/11
         sJ7BC4OPeBm7UyncQNWNajTkCkIP7ULNK5qu8adTJKDGRnaYDgqQm6VEFYSdqUxuWF+Q
         xLmLx5jG1+XAvy4XkiKzMep69lshNFNcEjSGjahWocHGRvtxYTIMtZwP2Dthpa6jHAjj
         QoIg==
X-Gm-Message-State: AOJu0YwP0dinLDgED7OZcDTht286/jsK0RMElDPriJQST2XoieOuN+1B
	Vd2P31SKnpauDJCNm+8ZR+rgMLn36GazS7Y/8t/gVGIHpNWi34IM
X-Google-Smtp-Source: AGHT+IF/zCiX0LTfXbr5RBbUrKsTnhFWRC7llBURJot934EtqKvzgHhvBobyEgoPISsN1kvwtKQDng==
X-Received: by 2002:a17:906:dacd:b0:a9a:59f:dfb9 with SMTP id a640c23a62f3a-a9de5cfedb1mr94618466b.5.1729913680005;
        Fri, 25 Oct 2024 20:34:40 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b1f02954esm130497466b.68.2024.10.25.20.34.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Oct 2024 20:34:38 -0700 (PDT)
Date: Sat, 26 Oct 2024 03:34:36 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, richard.weiyang@gmail.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	jannh@google.com
Subject: Re: + mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch added
 to mm-unstable branch
Message-ID: <20241026033436.hfb73whfbeypxj5r@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20241026024123.B621BC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026024123.B621BC4CEC3@smtp.kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)

On Fri, Oct 25, 2024 at 07:41:23PM -0700, Andrew Morton wrote:
>
>The patch titled
>     Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
>has been added to the -mm mm-unstable branch.  Its filename is
>     mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
>
>This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
>
>This patch will later appear in the mm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
>The -mm tree is included into linux-next via the mm-everything
>branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>and is updated there every 2-3 working days
>
>------------------------------------------------------
>From: Andrew Morton <akpm@linux-foundation.org>
>Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
>Date: Fri Oct 25 07:39:41 PM PDT 2024
>
>remove now-unused local
>
>mm/vma.c: In function 'vma_merge_new_range':
>mm/vma.c:965:23: error: unused variable 'start' [-Werror=unused-variable]
>  965 |         unsigned long start = vmg->start;
>      |                       ^~~~~

Andrew

The removal of start usage maybe come from another patch.

If my understanding is correct, 'start' would be used to restore the state on
expansion failure.

Just reply in case it would conflict with other commit.

>Cc: Jann Horn <jannh@google.com>
>Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Cc: Vlastimil Babka <vbabka@suse.cz>
>Cc: Wei Yang <richard.weiyang@gmail.com>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>---
>
> mm/vma.c |    1 -
> 1 file changed, 1 deletion(-)
>
>--- a/mm/vma.c~mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
>+++ a/mm/vma.c
>@@ -962,7 +962,6 @@ struct vm_area_struct *vma_merge_new_ran
> {
> 	struct vm_area_struct *prev = vmg->prev;
> 	struct vm_area_struct *next = vmg->next;
>-	unsigned long start = vmg->start;
> 	unsigned long end = vmg->end;
> 	bool can_merge_left, can_merge_right;
> 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
>_
>
>Patches currently in -mm which might be from akpm@linux-foundation.org are
>
>mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
>mm-memoryc-remove-stray-newline-at-top-of-file.patch
>bootmem-stop-using-page-index-fix.patch
>mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
>tools-mm-free-the-allocated-memory-fix.patch
>memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
>mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch

-- 
Wei Yang
Help you, Help me
