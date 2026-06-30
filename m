Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6243BC680
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 18:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782844885; cv=none; b=WSmOHDEvn8jkf078OAD05v3Ifx9tUC75g9+qcbYi/DbMUO1uNdWnjmt1zHCXYJNMrE/4HSyAtd4kayB/Q8cqzX485SJyjS5/6lX10Wj4wR49ZMTGlVTCJKC4+21VDGA9VzrUMoaRAOhuIwPU6jA6Lpv0XKtxxJ4PpcMh11jUxA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782844885; c=relaxed/simple;
	bh=6zntXJWALHRBtZU7uqS6TYxDCSsiG9g7MgmT7N5Pk9o=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=DMd3w82mwDAsErr5b29awernUduelFummrHMhAtQEevRa6S9gLwASki8AEAWPpvmed3EmNpqI0Wm4Ht+m2V8rMI6clAjh4r87OLxsL+JpxyALrvArOkqDFVe/9mPk2H738KHwlrUg3R+yo0xZ94ZQMbKd+mvQYB25JeGRFucCms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QzMu861D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QzMu861D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442851F000E9;
	Tue, 30 Jun 2026 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782844883;
	bh=ZxDMLZGmdOwaoXnC4HajV5npir5XPQg4QmBeqMX7AWA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QzMu861Dua4FbzXE9DZsyP5ei5Io6q8jRzzsRAe37WnViSMqxy0N9JmQqLAY7MCze
	 Pqzs/0MSJklW9EKehW17QJurH/ii/CrlCMkrwYkGrkLv2T0fFCS9Bc0Na2ThyaJeMa
	 HuzreYid5aZOtgxUIwl98dYNTY+CSvyY5eLS9ES8=
Date: Tue, 30 Jun 2026 11:41:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Barry Song (Xiaomi)
 <baohua@kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 15654b0268cd65b4e673510c0377774e61b86397
Message-Id: <20260630114122.2a7202249ff0bc6f32df708b@linux-foundation.org>
In-Reply-To: <202607010249.92RC46mZ-lkp@intel.com>
References: <202607010249.92RC46mZ-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 01 Jul 2026 02:30:11 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 15654b0268cd65b4e673510c0377774e61b86397  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com
> 
>     mm/vmalloc.c:3590:16: warning: unused variable 'start' [-Wunused-variable]
>     mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]

Sigh, OK, I surrender.  Below.

>     mm/zsmalloc.c:1480:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]

hm, I think I (re)fixed that one.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
Date: Tue Jun 30 11:35:55 AM PDT 2026

avoid warnings on architectures whose flush_cache_vmap() don't reference
their args

Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwen6@xiaomi.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
+++ a/mm/vmalloc.c
@@ -3629,6 +3629,7 @@ static int vmap_batched(unsigned long ad
 				prot, pages + idx, prev_shift);
 
 out:
+	(void)start;	/* several archs use a macro for flush_cache_vmap() */
 	flush_cache_vmap(start, end);
 	return err;
 }
_

