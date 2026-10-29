Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793297129;
	b=pMrLtnwumwc8XAsjvCYt2pKpjK2mqFLPBWD5RjEqZOZzz6oytwhaICdabZrQbIUTWs94
	 0w1kG8z3ZI/b9A9jqSFADznepNglToKzO+h6nCxzS7qa0d+Bk0FamY5h9KqrkX80Rm1An
	 09lbwr5X7JL70NOvh3H3OLAmpqkQzaL3VJxX1NN9iP1HC/9nVS6AZZ4fY7vJ/sHrHABWK
	 jYqETbsSUUhwArPoNKS5O0/ZZ+hJpYz38BE8u8rQZV5nfQCl9sTRJ9KqBxIzrMxG+sNeh
	 61h/vK1RDFGnoi6hyVREE+S0PzFLr9XeAbWZWvBqGZNhGWHgSr73EEVfQI2HbPPTd3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793297129;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Vu/Uiyl9Wd3werTD34M08bl8mqI4MLW125H+US7fPK0=;
	b=PncJS32MKc7yXBtAw9TXeOoXR2xsfL+ECYFYIvn4b4TNnHmD7N9Y4ahA77b/o/QCt+wU
	 EyY2/7f5CwffAHyQlnEfu12AIQ/penAcf2iS5e9/hRXQPINzIo+kOKbLc2CIXpE+o5aIl
	 6UVANtfu7/Amfe2SYwXiwp6ac/Bx3b1ruhK1MHG9ifWP///NbTGJi6a2x5jJvrsU0HuTh
	 rd30DQplyr3g16KOrWuOnQUAeBaXpmHkbkhpunnKedMlshS4coyY4jODdmq6iA8QyGG6y
	 t9IGg+5CSJg1Tf9Jw6bL1Mov7ZtmLJuZyF3bkrmNTtfcI16EzON8pNH5RKjzty7lZNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1G14uLla;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A199606A31E;
	Thu, 29 Oct 2026 18:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1G14uLla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094FC1F01816;
	Thu, 29 Oct 2026 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793297129;
	bh=Vu/Uiyl9Wd3werTD34M08bl8mqI4MLW125H+US7fPK0=;
	h=Date:To:From:Subject;
	b=1G14uLlaeyrpgMibpyjyXInnRUX7Xo7wvhzjwUL/3Dum9LcLCn9JXYwAedjAS+kd+
	 4zV61+xQQNLlLP+H7umjO2erX713lOuE2N46yjCB+oWd2EFj3C4Pt8yZrwy7G86cSr
	 /1/o7ozaZJ44U2LOEfgoSJgJ7j/xGXLj8PHHnTqE=
Date: Thu, 29 Oct 2026 11:05:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,kas@kernel.org,david@kernel.org,rppt@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20261029180529.094FC1F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/cma: accept memory of CMA areas reserved at a fixed address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/cma: accept memory of CMA areas reserved at a fixed address
Date: Thu, 29 Oct 2026 12:18:38 +0200

CMA areas allocated from memblock have their memory accepted by
memblock_alloc_range_nid(), but areas reserved at a fixed address with
memblock_reserve() are not.

If a fixed CMA area is requested by the cma=<size>@<base> command line
parameter, it may be in regular RAM and on TDX and SEV-SNP guests it
must be accepted.

Accept the memory of fixed CMA areas as well, so that all CMA areas are
accepted regardless of how they were reserved.

Link: https://lore.kernel.org/20261029-cma-multi-v1-2-2cbced8b5cb7@kernel.org
Fixes: 75d090fd167a ("x86/tdx: Add unaccepted memory support")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: <stable@vger.kernel.org>
---

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/cma.c~mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address
+++ a/mm/cma.c
@@ -381,6 +381,8 @@ static int __init cma_fixed_reserve(phys
 		return -EBUSY;
 	}
 
+	accept_memory(base, size);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-cma-accept-memory-of-multi-range-cma-areas.patch
mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch

