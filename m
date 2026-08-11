Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E073FCB0C
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 20:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786478924; cv=none; b=NqNaenNB8ONxrtkvbITPfB2U4ivIX0PunA/coQm6zQ1e+UuR4060m5WNNQWUb4SzgokEiN/edKZPsUsUImMoCiMvarziLnByT2eTXiUFqSKTI2edmRe5siUsIUD/lMwD4R/N6FJLWimdqvDAE+6NGeV4++qJqB3vS2Sp8DTDImQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786478924; c=relaxed/simple;
	bh=zWgrKKYoAtMmaN4djjt2Z+Rv8EvwAs6vBWQ1Ok/u/n8=;
	h=Date:To:From:Subject:Message-Id; b=XtpqS3ZcdcrqiofF+LytqRnkMBgNkGmP2tMfKug0qI0hFdNsJUU7wr0UYUYdvNAyH4STS+Pu0bSB0j8h0UGM2duwvzbXdFjslID7C/FJHVHf56kJQKb07BaY/w7IvZufuTVIRZI55Nbxur+Q93EGA4tSW/KeiT6ZS1EtWXyTgP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYNTU1lf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYNTU1lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452921F00A3D;
	Tue, 11 Aug 2026 20:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786478921;
	bh=Kdkc742Z0ZjmprK1P6xqEhYoiq2gC8aJXQ1u1zLbgMo=;
	h=Date:To:From:Subject;
	b=dYNTU1lfy9OaINNUDEX9q9bXucETtpHLypYNiW7bCEoJg57PPblLeUBjAohGX6b7e
	 pgwHSzF1UmJkDyPECceotw5u8KnRQp07RbLNPUghghRzsQgJam0fXt7IvWJ6Z12wGh
	 KJWs5J/ZelwffKJx4N9ZpfS25OH6W+5yyDpXFew0=
Date: Tue, 11 Aug 2026 13:08:40 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch added to mm-unstable branch
Message-Id: <20260811200841.452921F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix
has been added to the -mm mm-unstable branch.  Its filename is
     tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch

This patch will later appear in the mm-unstable branch at
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

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

