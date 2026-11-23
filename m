Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415112;
	b=L14wfR+7vfbIua38DZ2/4uoK7W5ShrJk+W20hVCoXvwu2tLInynWMamz0ndo2oEVLgLz
	 QAAdlX3xnew1Iz8GkZfjFYy+eXw0bdQRKC7r/BkBbDXhrU0VaiVATLQTTjZQgSKVbYvow
	 D2jWapsp0+tIzcUzQ4+kUmnEZnMJmbP008lawPXak71LhNkn7eWt27uNtRDUEFh+knzQJ
	 Kb9DUqjsTCx59us0B37aHufPBVmhU9sih14CL5ziWhfsnLcC3BJE7BWbVmoSMzEO1SSIE
	 qNjnbiIK6ghUCK3NU8t8RLuOnxtNPwI/fvmTKntAH9ZBwDLBuW1DpxExa89Es0s31xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415112;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=stcLyFlVGCUzMc/1JkRtmUbriyH+lTTWKKLgq5Z10s4=;
	b=g4rkrpcj+yg/M/UMP0PbBBtHa3X9A/MA+DKZqd5wxegl9ddvJoSlzktuIcctDtCM3U1x
	 QQ9QhfDFqhcV7oHTCPnQs1Fb+GMIvHr/3qoVHllIyMWTDrsYNbTtGiETfQgzilchzxPWi
	 lJCld5ayMUNc7k6szHv/UDLbfhyK6dMoU1ruo7gvrDn+z4s7o3dJvjlLkuK81F+jbUuYS
	 uJ2DIq1QwPh9VRIl5vHmclzTp2mYNZ7ZQ0lU+9QeVbWEuVvIdKHJEAv4wY1JU1Yav8o3q
	 zBJczVCG7MUJCGgsEZAMjCIt79k31SyZ+CcyPqPJ0XfFyJOq+W0Yxtk5RHi8XvKzA7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XRXaPIhN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1125D606A327;
	Mon, 23 Nov 2026 06:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XRXaPIhN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48F81F000C6;
	Mon, 23 Nov 2026 06:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415111;
	bh=stcLyFlVGCUzMc/1JkRtmUbriyH+lTTWKKLgq5Z10s4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=XRXaPIhNxRj2ZgHf2Iq3jiFii6z+cXGzdtTa78QL0qMR28HP2sfWF6jWgTQOkCVQz
	 jRVylxNfkOWuHtDAZwH6ArpVJE8e26Bft1JPH3mAcLFqlyMm1ejqd+xVbMDwlvetZj
	 olD6TDmGt6gaMkfd4+DtHoAl5cSwOjXZL5oVQFoo=
Date: Sun, 22 Nov 2026 22:25:11 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,
	ivanrwcm25@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
References: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
Subject: [merged mm-hotfixes-stable] mm-use-pfn_phys-in-phys_mem_access_prot.patch removed from -mm tree
Message-Id: <20261123062511.A48F81F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: use PFN_PHYS() in phys_mem_access_prot()
has been removed from the -mm tree.  Its filename was
     mm-use-pfn_phys-in-phys_mem_access_prot.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Subject: mm: use PFN_PHYS() in phys_mem_access_prot()
Date: Fri, 13 Nov 2026 16:38:12 -0300

phys_mem_access_prot() stores "pfn << PAGE_SHIFT" in a phys_addr_t.  The
shift is evaluated as unsigned long, so on a 32-bit kernel with
CONFIG_PHYS_ADDR_T_64BIT an address above 4 GiB is truncated before
uncached_access() compares it with __pa(high_memory).

mmap_mem_prepare() already shifts in phys_addr_t, so the mapping is
accepted and then left cacheable.  PFN_PHYS() casts before the shift.

On a MIPS32 XPA Malta guest, mmap of /dev/mem at 0xf00000000 without
O_DSYNC used the boot CCA.  The same mapping with O_DSYNC was uncached. 
With PFN_PHYS() both are uncached.

Link: https://patch.msgid.link/20261113193812.1239880-1-ivanrwcm25@gmail.com
Fixes: 7e6735c3578e ("/dev/mem: use phys_addr_t for physical addresses")
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>

 mm/char-mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/char-mem.c~mm-use-pfn_phys-in-phys_mem_access_prot
+++ a/mm/char-mem.c
@@ -272,7 +272,7 @@ static pgprot_t phys_mem_access_prot(str
 				     unsigned long size, pgprot_t vma_prot)
 {
 #ifdef pgprot_noncached
-	phys_addr_t offset = pfn << PAGE_SHIFT;
+	phys_addr_t offset = PFN_PHYS(pfn);
 
 	if (uncached_access(file, offset))
 		return pgprot_noncached(vma_prot);
_

Patches currently in -mm which might be from ivanrwcm25@gmail.com are


