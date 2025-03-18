Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAF31CB51F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274658; cv=none; b=Ib3464Hwk3WC4zmD7Chwi8csIIMh373efMKZNfMWTtxZfgAUQjbVhoca6/IjcAFGgiMrWkn1Kx1lYpXVItL1ngdskWlt40S22APLPo+sfjKgRsqtXfI/UDUItZAg6nQkcI4cEaSDNSieQTotlS5xQfQi/miUfYc0jWn60AZbKHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274658; c=relaxed/simple;
	bh=P+ll0ImRxv6CmW6YOAVkWLo6XQId4J0+nnCbcSkFVkI=;
	h=Date:To:From:Subject:Message-Id; b=CinSN56WUmdUu85D9ox3/6j4g2yHUlgmDnXElRlft0hWf3vnqzJLdDwZZln54rJDq0ZX5YqBDuoBw1liYWoN5BaRClvyKkZ1FSa7iPyPzJPeQVmZgqLS8VV3sNuQqeWt4MAI26ogypO0iHBkbDhINWTaaFl+D5yM64QnkJNLH7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sCbQzAkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sCbQzAkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFADAC4CEDD;
	Tue, 18 Mar 2025 05:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274657;
	bh=P+ll0ImRxv6CmW6YOAVkWLo6XQId4J0+nnCbcSkFVkI=;
	h=Date:To:From:Subject:From;
	b=sCbQzAkvEwhsQv4FBHbOpJBWTFvp/x9nK492itSlv7fiq11EDue0NhtDT7qfSp4lQ
	 dMUGjwoArTkBkwT+RMoUzAmpfXF/bKQ0ZbPE1V5SA1MKJ15Hp3CgM04ytAsV+RsfH3
	 OeguHnRkGDQQvNfMmLK/s7IJjOdoTFxdg5VV4cSo=
Date: Mon, 17 Mar 2025 22:10:57 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,dev.jain@arm.com,david@redhat.com,cyan.yang@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-cow-fix-the-incorrect-error-handling.patch removed from -mm tree
Message-Id: <20250318051057.BFADAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/cow: fix the incorrect error handling
has been removed from the -mm tree.  Its filename was
     selftests-mm-cow-fix-the-incorrect-error-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cyan Yang <cyan.yang@sifive.com>
Subject: selftests/mm/cow: fix the incorrect error handling
Date: Wed, 12 Mar 2025 12:38:40 +0800

Error handling doesn't check the correct return value.  This patch will
fix it.

Link: https://lkml.kernel.org/r/20250312043840.71799-1-cyan.yang@sifive.com
Fixes: f4b5fd6946e2 ("selftests/vm: anon_cow: THP tests")
Signed-off-by: Cyan Yang <cyan.yang@sifive.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-fix-the-incorrect-error-handling
+++ a/tools/testing/selftests/mm/cow.c
@@ -876,7 +876,7 @@ static void do_run_with_thp(test_fn fn,
 		mremap_size = thpsize / 2;
 		mremap_mem = mmap(NULL, mremap_size, PROT_NONE,
 				  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-		if (mem == MAP_FAILED) {
+		if (mremap_mem == MAP_FAILED) {
 			ksft_test_result_fail("mmap() failed\n");
 			goto munmap;
 		}
_

Patches currently in -mm which might be from cyan.yang@sifive.com are


