Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DD219A
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607065; cv=none; b=AqykcbjbTYmzyDisWQadFwhqJBFxZJY8lNpaB3A32XtsKaUDzx5ojeTmKiCYIxxHCj6SrvkdMGj0/hEy+bPTUbA087IDLkIZUW5BYYH8wLJtgLLRL7rWML4PyeaOtx4YNpNbcEZ5fYgaICeOxcmCEXH3acyaGCEgy872/OVYqik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607065; c=relaxed/simple;
	bh=pPC3TiU48orleYB1hBGzB4in4HpDbNVml+h/584LAXU=;
	h=Date:To:From:Subject:Message-Id; b=j0pFlLOejxXa4eWKopso1w6779GwghVFJ+tNV9flIiuzmhcDgJF7KXoMVtRWIAZvQtwhlltu+sSJlX8EPmtSUmm6/g/Di80op1LGPadlYp7LeXSVNfVWgYytNMR8dryuPmpR0YITDEFvTQm7JBInAYpRG+m4g/A/RNlqbmVxJY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tCtZf2OU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tCtZf2OU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6106C4CEF0;
	Wed, 11 Jun 2025 01:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607063;
	bh=pPC3TiU48orleYB1hBGzB4in4HpDbNVml+h/584LAXU=;
	h=Date:To:From:Subject:From;
	b=tCtZf2OUG9o/M9bgJQhxPCSXakMCnLUSdsvrwnlnT5Vo8Op0rXLarhv4g5isyorJ2
	 K7Wvq0m0Glp9UaxFVQ9HXkYaXDDplFUA+rnNlvB4HxLFUdN8HcfjACTVV0qKNFPmyD
	 O7oEjLdUitmRF1NzbomhuZZ+yOIlUyZV8BGAIosU=
Date: Tue, 10 Jun 2025 18:57:43 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,lkp@intel.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-zblock-allocator-fix-3.patch removed from -mm tree
Message-Id: <20250611015743.C6106C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-zblock-allocator-fix-3
has been removed from the -mm tree.  Its filename was
     mm-add-zblock-allocator-fix-3.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-zblock-allocator-fix-3
Date: Mon May  5 06:06:27 PM PDT 2025

fix kerneldoc for zblock_create_pool()

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505060720.ClN2d7w7-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Igor Belousov <igor.b@beldev.am>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zblock.c~mm-add-zblock-allocator-fix-3
+++ a/mm/zblock.c
@@ -117,7 +117,6 @@ static struct zblock_block *alloc_block(
 /**
  * zblock_create_pool() - create a new zblock pool
  * @gfp:	gfp flags when allocating the zblock pool structure
- * @ops:	user-defined operations for the zblock pool
  *
  * Return: pointer to the new zblock pool or NULL if the metadata allocation
  * failed.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch
mm-add-zblock-allocator.patch
mm-zblock-avoid-failing-the-build-fix.patch

