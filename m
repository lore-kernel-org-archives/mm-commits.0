Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C623A4A2E1E
	for <mm-commits@vger.kernel.org>; Tue, 22 Sep 2026 19:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790104688; cv=none; b=g9dojPzDX1PyXj0eZ7cFg+VjUHYtw2yBvM0a+1UdYvRIjrx37FGdxp2jNnPsmRBvFoguOHl4eL8vj20+EE+yPzqE06KPvD4ibdBc5grgc0UTzgQrcG7+ZnYKQw7oN7kmBnjtv2quoutezzBcQttlrXyZht0wK8dqgYvFF4RmPfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790104688; c=relaxed/simple;
	bh=RWvZHLicJLLvwF8axCF4aM9fY/X4QuFcnfJaR8Me23Q=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=uD04Hq4e7T5CHDYApR5fjgE4wWq/D6ERVirdQ/HKlHeKjxkKFr2dppK097/AZmg7gYPVkOqNoKaWyRa+HfItE+OVF8G+wrKiDe7Wk8Wl8rEZemeagq4gwVN9R6CRmaM+AJLZFiF0WefTBtcGTcZcNk/6d5NzWxYSZMxYM7WBmmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BcLnScW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BcLnScW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C539E1F000FF;
	Tue, 22 Sep 2026 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790104680;
	bh=EbwsGYcKEUQhlPO0JG4qgWNNDjb8XtGskMwmQwSyxvY=;
	h=Date:From:Subject:To:Cc;
	b=BcLnScW2dcDDboL3NqWfj5cR/FcnYUEUHeQ2O0fmN9YzkBFKTsNj2heJCSTcGOYR0
	 OLjCMnNcvk7Iguc2Fgw7EcsojNkO7yCj52lWpFtCMga58Nm3DDAtTPejl9pbIklg9y
	 xSMuSvshLFxw37Zz27F04/rdcZFV8Oq6rLIUSkeQqMZVx4sIxq5iAN+1UukbZ6lqW2
	 jhz2BrTrdnUKD+YtFb1x/6YfmIpRekc25DZi3l7tDioAl8IbDmUe42x4M/q7JA3XzB
	 3vwKnnwz3GMepbBAvkQ9Q52jKmDjo9zWb9Qqkbh9Kot321KhLG68TKDffgwrxvdRi6
	 QfEP9XSLQzcGQ==
Message-ID: <0eff7de9-b379-472b-a1c3-07b55758b389@kernel.org>
Date: Tue, 22 Sep 2026 21:17:56 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm-next: manual merge of the akpm/mm-unstable branch
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

today's (well, and the last couple of days) mm-next merge of the
akpm/mm-unstable branch tree got a conflict in:

  drivers/infiniband/hw/hfi1/file_ops.c

between the commit:

  62f0f34fbd2b ("IB/hfi1: Fix the PIO_CRED credit-return mmap")

from Linus' tree and commit:

  e7d9f14bb73b ("infiniband: update hfi1 to use remap_vmalloc_range()")

from the akpm/mm-unstable branch.

I resolved the conflicts manually:

diff --cc drivers/infiniband/hw/hfi1/file_ops.c
index 1a36f995c4f6,b02d1f1dbb27..680364fda856
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@@ -325,8 -320,7 +320,8 @@@ static int hfi1_file_mmap(struct file *
  		memaddr = 0;
  	void *memvirt = NULL;
  	dma_addr_t memdma = 0;
- 	u8 subctxt, mapio = 0, vmf = 0, type;
+ 	u8 subctxt, mapio = 0, is_vmalloc = 0, type;
 +	size_t memdmalen = 0;
  	ssize_t memlen = 0;
  	int ret = 0;
  	u16 ctxt;
@@@ -569,16 -546,13 +556,14 @@@
  	}
  
  	vm_flags_reset(vma, flags);
- 	mmap_cdbg(ctxt, subctxt, type, mapio, vmf, memaddr, memvirt, memdma, 
+ 	mmap_cdbg(ctxt, subctxt, type, mapio, is_vmalloc, memaddr, memvirt, memdma,
  		  memlen, vma);
- 	if (vmf) {
- 		vma->vm_pgoff = PFN_DOWN(memaddr);
- 		vma->vm_ops = &vm_ops;
- 		ret = 0;
+ 	if (is_vmalloc) {
+ 		ret = remap_vmalloc_range(vma, memvirt, 0);
  	} else if (memdma) {
  		ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
 -					memvirt, memdma, memlen);
 +					memvirt, memdma,
 +					memdmalen ? memdmalen : memlen);
  	} else if (mapio) {
  		ret = io_remap_pfn_range(vma, vma->vm_start,
  					 PFN_DOWN(memaddr),
-- 
Cheers,

David

