Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFCD24418E
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 20:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740602931; cv=none; b=PtJTk+Eb2NHGPOBbDFuWVjIKIQAKCsFGX29LUG4fCFkrD8y2Jc1VP468fm5GTBzHdSifyPa6Lrib41ltL/Cpkk0Wyz2aYjjS99RpAzXO8cgdXRvQRRW8N4sn2ezf3MtXHzNc3jHXGrxLhsfQ5gDTjElP9+lFt0z6xvvqU6tOL80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740602931; c=relaxed/simple;
	bh=0mfEtegWwLG+rXrXVwLgiqQZQjMnESDG7pv4/BgcQVI=;
	h=Date:To:From:Subject:Message-Id; b=TCQXEc46yFc2kru7sDJ2KZtgUF49a/hUu/W6G13fn7qSKmsOpR5qouj6KAjODvePSOEYCGP6Isz6WN79CT3vNjzYjzwx0KmaWSwDLXCK5ZfFMbPAd5Jg83RYVzuFg0QVV7SRc09odnM786soEPTnVXaKWSjq6p9PuKSsGzK6I4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2OM6fZv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2OM6fZv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773FCC4CED6;
	Wed, 26 Feb 2025 20:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740602930;
	bh=0mfEtegWwLG+rXrXVwLgiqQZQjMnESDG7pv4/BgcQVI=;
	h=Date:To:From:Subject:From;
	b=2OM6fZv9PrgE5mvkjGOwhq/nFBue5XnZuF+S0g+XsaEV4gd14C5Zkv7cRPpM0zzgO
	 KrBvsBKKnv7qZeqSQ9QS5zHR6/1dBYAMsMfY0hv12K01A2V8EU50Oid+Cw0IRYCXtK
	 NuhbxGxYDlMOPrBPrpBhZ0gBM6IYQNefPoJWmZho=
Date: Wed, 26 Feb 2025 12:48:49 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,hannes@cmpxchg.org,david@redhat.com,chengming.zhou@linux.dev,sunk67188@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226204850.773FCC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: use ATOMIC_LONG_INIT to initialize zswap_stored_pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sun YangKai <sunk67188@gmail.com>
Subject: mm: zswap: use ATOMIC_LONG_INIT to initialize zswap_stored_pages
Date: Wed, 26 Feb 2025 23:32:43 +0800

This is currently the only atomic_long_t variable initialized by
ATOMIC_INIT macro found in the kernel by using `grep -r atomic_long_t |
grep ATOMIC_INIT`

This was introduced in 6e1fa555ec77, in which we modified the type of
zswap_stored_pages to atomic_long_t, but didn't change the initialization.

Link: https://lkml.kernel.org/r/20250226153253.19179-1-sunk67188@gmail.com
Fixes: 6e1fa555ec77 ("mm: zswap: modify zswap_stored_pages to be atomic_long_t")
Signed-off-by: Sun YangKai <sunk67188@gmail.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages
+++ a/mm/zswap.c
@@ -43,7 +43,7 @@
 * statistics
 **********************************/
 /* The number of compressed pages currently stored in zswap */
-atomic_long_t zswap_stored_pages = ATOMIC_INIT(0);
+atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
_

Patches currently in -mm which might be from sunk67188@gmail.com are

mm-zswap-use-atomic_long_init-to-initialize-zswap_stored_pages.patch

