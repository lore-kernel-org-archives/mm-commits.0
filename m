Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88D527FB1C
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774407118; cv=none; b=OCbdrAOPrVccNOw+B785jPGf2Gp8O94ZYBS3xja0MubYqk6SH2RklYnyI5AzH7rJX7qmyFU5YWUgLX9psCSDf3Bg3gvZrd/JcVTb3QoSGUsymtnYmVFJViMql5AamDn081xV2JYQm17uPvjillFxIErs58ObIKWzBXeQx0xnoo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774407118; c=relaxed/simple;
	bh=9GJwGM8SXOPKdNw/NfU7rSchOjqu3Qx8BaVa/UP3ajQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BuxYTbw3Zg+pn/4I9df9eO6B3EzbHx2QHEa4e+CH0/TGYsLsJTuBF63RQZdrhJt1p7arXtuPbQzvIjxivKlwmfABKTwQxnPPVd1zvF+PY9WLgfzjqPI7sEEItCnWim5aRvaaM1H/JOgCaGXi3NuKI9eSqHSpmU24JtDY0gNVxnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l9XQwH7q; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l9XQwH7q"
Message-ID: <7b0c168c-818e-47bc-80f6-578409ddd82c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774407115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhkzMKaPKmS1z4O/DpHPH8S5wgOs8URpmsgIfuq/7aw=;
	b=l9XQwH7ql21n+L+Z90YLCawhrzZcR4q2DoHb9Lj07Jxku1CENGog6MWh1tAqZZ/baafZ1j
	lGEOpuk+I0Od2BsEvMIJ6mrnBQDMF+sTc/IIEK0dnbmN+QoUmVE9/A0lJzMz7tVmWbBoMs
	ehKubFWkvw1fi7VOzQPFxtVavym2yjs=
Date: Wed, 25 Mar 2026 10:51:40 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [folded-merged]
 mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 zhengqi.arch@bytedance.com, devnexen@gmail.com
References: <20260324231614.EFAC3C19424@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260324231614.EFAC3C19424@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 3/25/26 7:16 AM, Andrew Morton wrote:
> The quilt patch titled
>       Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
> has been removed from the -mm tree.  Its filename was
>       mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch
> 
> This patch was dropped because it was folded into mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch
> 
> ------------------------------------------------------
> From: David Carlier <devnexen@gmail.com>
> Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
> Date: Mon, 23 Mar 2026 06:30:06 +0000
> 
> add newline, per Qi Zheng
> 
> Link: https://lkml.kernel.org/r/20260323063007.7783-1-devnexen@gmail.com
> Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/memcontrol.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> --- a/mm/memcontrol.c~mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
> +++ a/mm/memcontrol.c
> @@ -4058,6 +4058,7 @@ free_objcg:
>   	for_each_node(nid) {
>   		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];

The newline should be here. ;)

>   		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
> +
>   		if (objcg)
>   			percpu_ref_kill(&objcg->refcnt);
>   
> _
> 
> Patches currently in -mm which might be from devnexen@gmail.com are
> 
> mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
> mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch
> mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch
> 

