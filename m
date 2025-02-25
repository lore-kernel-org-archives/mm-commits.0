Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE143146A69
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 03:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740454803; cv=none; b=BIl+4k2ns1YRDNs0uO7JdbdF25wylDm8vLSIkSxRMHJ/VuLlsZ0LzTq3QsI0/bdeawNhyb3+JVbK0HYrbSdgN/McKIQdJN1Ucn5Cx1RTpfJY+MOPJ3Z5GE3t35WEPOyyueXFZ6Wbhrn/HkSLCUQbDETzAs/JA8jhPQi0Go/bLLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740454803; c=relaxed/simple;
	bh=JMTQnn4LV3T+par/2lypidKGe6hWEmxUQXoPeJfYL9o=;
	h=Date:To:From:Subject:Message-Id; b=ccDMGwrf8Tnd2EOHheC7DnL7CZV+lQPxcazRbFsadQutJ8xRlOUEXvrLAC83gTfq76WQm4zy4rXqs2FMyd5hBgddW9pb8D2KY69nlI55HZ8G52V985HRxe9VyoBWyUyfsSEcgGnr0eW0lPmVU6KwH/F2+88ud8h/pJ5zf2FMoVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mzf1mMxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mzf1mMxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9D9C4CEE6;
	Tue, 25 Feb 2025 03:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740454802;
	bh=JMTQnn4LV3T+par/2lypidKGe6hWEmxUQXoPeJfYL9o=;
	h=Date:To:From:Subject:From;
	b=mzf1mMxaetyi8ER5pEEgShW57vlxPC00ZbUSRsp45amjAbZyz/WGmbAx4OzsgO0au
	 nkoPMhJTsmd1Ax/1hyza45PoGM2lRFWE09YVFMHZ01aX35/B+GZQLrZVJc+v/UO0ro
	 el+DOLz33xmhBNVIL7iHhXHxu505Np0kv6T4ncqo=
Date: Mon, 24 Feb 2025 19:40:01 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,fvdl@google.com,david@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-support-multiple-contiguous-ranges-if-requested-fix.patch added to mm-unstable branch
Message-Id: <20250225034002.4A9D9C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, cma: fix 32-bit warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-support-multiple-contiguous-ranges-if-requested-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-support-multiple-contiguous-ranges-if-requested-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm, cma: fix 32-bit warning
Date: Mon, 24 Feb 2025 15:07:35 +0100

clang warns about certain always-true conditions, like this one on 32-bit
builds:

mm/cma.c:420:13: error: result of comparison of constant 4294967296 with expression of type 'phys_addr_t' (aka 'unsigned int') is always true [-Werror,-Wtautological-constant-out-of-range-compare]
  420 |                 if (start < SZ_4G)
      |                     ~~~~~ ^ ~~~~~

Replace this one with an equivalent expression that does not cause a warning.

Link: https://lkml.kernel.org/r/20250224141120.1240534-1-arnd@kernel.org
Fixes: 4765deffa0f7 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-support-multiple-contiguous-ranges-if-requested-fix
+++ a/mm/cma.c
@@ -378,7 +378,7 @@ int __init cma_declare_contiguous_multi(
 	 * Create a list of ranges above 4G, largest range first.
 	 */
 	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
-		if (start < SZ_4G)
+		if (upper_32_bits(start) == 0)
 			continue;
 
 		start = ALIGN(start, align);
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-cma-support-multiple-contiguous-ranges-if-requested-fix.patch
reboot-add-support-for-configuring-emergency-hardware-protection-action-fix.patch

