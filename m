Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7083D26ACC
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774396575; cv=none; b=L+/UnR5OdV1rFERzZaJ2fD8iSlo+BTu+1aUXgSc3Cy5h47lwmH/HrGjjib8wTUWunP7al4xx7Hi6uIqIPBp1WTbZSWHA+s9r1qig7XbLq/RH8pAYlMyXW9ZRk2suaF4XeLDftJEr0MedBoAw7ZoYMplkeYtptHESkCzF/7E4/qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774396575; c=relaxed/simple;
	bh=bcLWyRI0wMOSOs3bERridl04KoIehqsDxadLLEZVkQ8=;
	h=Date:To:From:Subject:Message-Id; b=IyqmkuFwkJjNtnYKGH5E/8ChKmVEvZBG3auHsi0MoI4C5BWbqi7mbulvGDSoSV/JfqASHbXFq/ZsNFoDXwV6zfSJkd72loCYJ0WHdAQxr9jSDHULsmQ9Odh2O7SXV7IAt/Laoq2HMLBnj8Jk1DPTKzdjPO26g+mNYLSpsBflz1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=slIc19fZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="slIc19fZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D32AC2BCB2;
	Tue, 24 Mar 2026 23:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774396575;
	bh=bcLWyRI0wMOSOs3bERridl04KoIehqsDxadLLEZVkQ8=;
	h=Date:To:From:Subject:From;
	b=slIc19fZPMFGoPrb5u1v0AOcyIa+W2LTmTZZnHRlhY2dzJCV1qe+YMh5M2CM5SlhQ
	 dEAXCD86B8wcwjIfhJOglLLNE/a98yHdbbm4FJoLza6r05u2kVnZ3bhAlP5rgHVEn7
	 dYLM7Wr+7+U4xodTcmkWKJy0WEt+sWpKx2aDQQBg=
Date: Tue, 24 Mar 2026 16:56:14 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch added to mm-unstable branch
Message-Id: <20260324235615.3D32AC2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch

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
Subject: selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix
Date: Tue Mar 24 04:53:21 PM PDT 2026

s/uffd_wp_feature_supported/check_uffd_wp_feature_supported/, per David

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Sayali Patil <sayalip@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-wp-mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,7 +19,7 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
-static void uffd_wp_feature_supported(void)
+static void check_uffd_wp_feature_supported(void)
 {
 	uint64_t features;
 
@@ -347,7 +347,7 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
-	uffd_wp_feature_supported();
+	check_uffd_wp_feature_supported();
 
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

