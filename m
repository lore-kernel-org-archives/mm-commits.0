Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078E95B1E0
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422256; cv=none; b=HezDY0AVvDJAfUXxBDpZT9nDPzpFaorrr92ssEjt5UbYPSXxMN6DvZvTDXgeMNSrseFiEToMQWSo6X9Xu/UhTW9WvqYnXFoLpSECTHTsZ5z9xGxcuRR7baPo3xmJw07nKWr0+W1QBhmParYtZFJjaMQR2XNrrtikbuFBCFpBT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422256; c=relaxed/simple;
	bh=ustuoMiBChXR9Sqn0LnEvgJML0k0fi+jbLz0kv6xpYc=;
	h=Date:To:From:Subject:Message-Id; b=nZkKzeM/lFWZqMZuQJs2Vip/Ajis+awceOi7EtzWsOEVNBRVNEEm9owaeVmNUSCfja3go4znIyruFrrz5aYi6nv33TEddFvcM92UIMgpqsfmawQv8HAOX49UF6tKr8s+vOuqlYOx1txFCwud0BTO4K1QGJd4XdgVISkzjEOW7xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WuiXhEaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WuiXhEaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72382C4CEC2;
	Wed,  4 Sep 2024 03:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422255;
	bh=ustuoMiBChXR9Sqn0LnEvgJML0k0fi+jbLz0kv6xpYc=;
	h=Date:To:From:Subject:From;
	b=WuiXhEajYUHCrh0K1yVvEEljRUInWDUk9bP/pAmcwmEUudt6pgnmdIeOLqI2cnfkb
	 LoxgcmRbXg0DxbbtV5j4MPr9Ssuubzqs0vrdnBTiAOSEW8D6OLmv9NBxVIHDTZWG0x
	 NVQVzEcoSnFl6i5xhSCrXwASgxMVj/bOT5MNFkRk=
Date: Tue, 03 Sep 2024 20:57:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-more-mseal-traversal-tests-fix-2.patch removed from -mm tree
Message-Id: <20240904035735.72382C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix mseal's length
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-more-mseal-traversal-tests-fix-2.patch

This patch was dropped because it was folded into selftests-mm-add-more-mseal-traversal-tests.patch

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: selftests/mm: fix mseal's length
Date: Thu, 22 Aug 2024 00:20:19 +0100

We accidentally msealed too much, which could overrun and try to mseal
other regions.  This seems to be harmless (at least on top-down
architectures) due to various reasons all aligning, but may very well
cause spurious test failures to e.g bottom-up mmap architectures.

Link: https://lkml.kernel.org/r/vc4czyuemmu3kylqb4ctaga6y5yvondlyabimx6jvljlw2fkea@djawlllf45xa
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-more-mseal-traversal-tests-fix-2
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -783,7 +783,7 @@ static void test_seal_mprotect_partial_m
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
-		ret = sys_mseal(ptr + page_size, size);
+		ret = sys_mseal(ptr + page_size, page_size);
 		FAIL_TEST_IF_FALSE(!ret);
 	}
 
@@ -1031,7 +1031,7 @@ static void test_seal_munmap_partial_acr
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
-		ret = sys_mseal(ptr + page_size, size);
+		ret = sys_mseal(ptr + page_size, page_size);
 		FAIL_TEST_IF_FALSE(!ret);
 	}
 
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch

