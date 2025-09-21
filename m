Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D720D28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489810; cv=none; b=lc2B8reMNPcMT172ZUnvhDANlYibSKkmlU+zPPcEvf7200U7tltGaIWlk93lI5XeooaOFmZ5r7wO4tgw6fXbZr6+bUOVH7sUcjTZ13v7K4fjHWwgGXKAxAccKgwZxm+EPJpVekqC22QZIkvVrViYWQLY95e89M8OqxGi8SFpxH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489810; c=relaxed/simple;
	bh=rNN05+TMKSYoRMb7jWciVT+QyoiQSGBU22U2N64jlOw=;
	h=Date:To:From:Subject:Message-Id; b=eEdiE8m6vcVRnMV35x2vWySO9kCSogCTWiZqreNRqAyCxnkXTnQSOl8tQRdga6yfbRk7hRJo3mJXS4+WAnSTrcbzFNfBiuQ9qT5hnJkTuNKk3DhqWOrDZq6dOrgYzZTKuuaNaL/QoNmJ4S3RXw+1IfP6mxXbHCXIWM+vdwlOATk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkaZdV6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkaZdV6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F342C4CEE7;
	Sun, 21 Sep 2025 21:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489810;
	bh=rNN05+TMKSYoRMb7jWciVT+QyoiQSGBU22U2N64jlOw=;
	h=Date:To:From:Subject:From;
	b=QkaZdV6zW718VbaaSRhN4rFQ9ncL1xWmWUIlz6Fk/1j+DN44ZhMHv0EERbkitnJUD
	 mfkUjFR8Y0E885DC1iklet7wa4z+SA0PHX9sjPd214835LZkC9NLV/ZGheUvZxIQO/
	 MXPpCol3P9GISoEJ5N7C4PUIZgQ391aCxW9YbwTI=
Date: Sun, 21 Sep 2025 14:23:29 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,rppt@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch removed from -mm tree
Message-Id: <20250921212330.6F342C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
has been removed from the -mm tree.  Its filename was
     s390-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Mon, 1 Sep 2025 17:03:24 +0200

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE is
selected.

Link: https://lkml.kernel.org/r/20250901150359.867252-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/Kconfig~s390-kconfig-drop-superfluous-select-sparsemem_vmemmap
+++ a/arch/s390/Kconfig
@@ -710,7 +710,6 @@ menu "Memory setup"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
_

Patches currently in -mm which might be from david@redhat.com are


