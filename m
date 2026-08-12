Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1832F25771
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786504990; cv=none; b=G25jPsIXAKo5jfpK5qO/CLtHDLaSBlbIoEbx2JzpP8k9vTQrapUVUFeO8pLy4rOgdTiab7LFjzQ/6RX7Fqhq5THYtiJxskIRTi+H0fdiUdsbklJhZJufbI4A+lRY8rMEwcuLS4QHaR1DwIaw3YAmdNOGj2uurB+eW19ZUH8RHUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786504990; c=relaxed/simple;
	bh=E/Ae5/ymG0IC/7636/SxnM2xWBGQzqaWR926HV5acXQ=;
	h=Date:To:From:Subject:Message-Id; b=aTBnovAknmcErDBuXFuIQQF+S6LgK9idXGufcqR3gucH1L200Rea9X5OuX7u30HWEMkwHJYikBGj4O9Z0aRLlgfExzXP8TPzgvC0jXydif+npmFlNBgDbeJbzk8hEEQa2WVAPQCGZG8WRlS2O8i0x4I4rrMX14zYqffIKq7EyvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zBtoua/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zBtoua/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581DE1F00A3A;
	Wed, 12 Aug 2026 03:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786504988;
	bh=PDS68njdzclGq04WE5Bv57y6Jc07JB1orn7ajWTWtbE=;
	h=Date:To:From:Subject;
	b=zBtoua/afMQQFMJqutr/YUTglWKWIcBfxEniSLmG7lohkU1XaGxZa5mds44lHeESz
	 jhglPeSIWgkl81yeqU7hzVPARaj5pJD05EgeS9JEjHcIYPph/LKjn7Pk9G+tUPaUc6
	 2s4F5KPGOIhxBrfVsb4ldb9eN2qYq0XygWWzmB88=
Date: Tue, 11 Aug 2026 20:23:07 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch removed from -mm tree
Message-Id: <20260812032308.581DE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch

This patch was dropped because it was folded into tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix
Date: Tue Aug 11 01:06:31 PM PDT 2026

tweak comment, per David

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix
+++ a/tools/testing/selftests/mm/merge.c
@@ -1324,7 +1324,7 @@ TEST_F(merge, anon_and_page_offset_misma
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/*
-	 * Map another separately, and fault in, at page offset 5:
+	 * Map another separately and trigger a CoW fault, at page offset 5:
 	 *
 	 * |-----------|           |---------|
 	 * | unfaulted |           | faulted |
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

