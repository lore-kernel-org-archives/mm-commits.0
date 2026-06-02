Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449E2BEC2A;
	Tue,  2 Jun 2026 00:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780361446; cv=none; b=FFvN3rlEqXwXc1nFkXn0DXBKBMdI2y8pPTu1iYM4SGgRlGKO5m+bNCDu0hMTXgSzyi1f519tISgldc2Qg2vlskDP3VgqH/pn+BiOG4lCGzk1CyBdzATsz/2m9nUjB6p19EIJktxuTVtpnIa5FSjkrv+Xc4Kd1tuaDXUfXSldbqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780361446; c=relaxed/simple;
	bh=TzklarHP5Cwz1/QNZC76PClbA2rfaX//E32jzT2Wlk4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=V1JfDiXEnTg6nV25vxJnoL7JndGXpBUZxrvSgDWBiuVaARpvKcjqKy6O8Lhw7IGUo2AbOa7L94rvH5DpxB14TFKuhAEQWGqSdWuZp99/h+yIkAx42Fvcel/U2+/06Z11DwgZ5EhyJPL+1G8bcErTQ/phB9w/pXeUyLX/24duZrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0jvQxyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0jvQxyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C80C1F00893;
	Tue,  2 Jun 2026 00:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780361443;
	bh=RmCDHQKxGmU0NXkOYJU/o1U/xmaSHU/e02onfhGC6hw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=J0jvQxyUfDbgy8KBUh51Eoa4t4LKTT618EtplWjVH0iJBGkxHNpre1o4dUGVHSRYZ
	 CrTYRzlqBMYT5EKyNl3BwL2qve5jb/cnRH/D4RnLUPrXHijDk14/PTvXhHGqjmGEpd
	 nyuzpDwWARFe81Wl4qTEPwOeoCmx6cknORySJwK8=
Date: Mon, 1 Jun 2026 17:50:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Qiang Liu <liuqiang@kylinos.cn>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 386/420] lib/test_hmm.c:1170:21: sparse:
 sparse: incorrect type in assignment (different base types)
Message-Id: <20260601175042.97c9e6372cb3e9f23f4a0f62@linux-foundation.org>
In-Reply-To: <202606011329.zWs2BKy4-lkp@intel.com>
References: <202606011329.zWs2BKy4-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 01 Jun 2026 13:13:42 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   d97bc98dadda29f23540b8490592962ebcf545ff
> commit: d4ab4875497b1659c6c56dd9faefcb4a41c566e4 [386/420] lib/test_hmm: check alloc_page_vma() return value and handle OOM
> config: s390-randconfig-r111-20260601 (https://download.01.org/0day-ci/archive/20260601/202606011329.zWs2BKy4-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260601/202606011329.zWs2BKy4-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> lib/test_hmm.c:1170:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int [assigned] ret @@     got restricted vm_fault_t @@

yup, the code is confused.

>   1165			ret = migrate_vma_setup(&args);
>   1166			if (ret)
>   1167				goto out;
>   1168	
>   1169			pr_debug("Migrating from device mem to sys mem\n");
> > 1170			ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
>   1171			if (ret) {
>   1172				migrate_vma_finalize(&args);
>   1173				goto out;
>   1174			}

How does this look?

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
+++ a/lib/test_hmm.c
@@ -1167,9 +1167,9 @@ static int dmirror_migrate_to_system(str
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-		if (ret) {
+		if (dmirror_devmem_fault_alloc_and_copy(&args, dmirror)) {
 			migrate_vma_finalize(&args);
+			ret = -ENOMEM;
 			goto out;
 		}
 
_

