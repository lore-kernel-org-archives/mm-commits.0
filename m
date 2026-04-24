Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48614145B11
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777054755; cv=none; b=YTgSaHcclg6gtxZ4eNRgsdcJ4zvqZeajXZYMh5aewCbriXox+uE39VCvVg0wXU4S4z6kz71N4bQSRmUaU4Rmi1nsm3PEU9fYN0VeTiICM7swkB4fHZ11hZD78iYNTYkadwDZot9CFZVKAOu+9gSopTA5iV9gPBDH3smcreTcSQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777054755; c=relaxed/simple;
	bh=7D2dFh1+XrD6M5Q8Z9C6vKYG0TSUM82bqK9jxBJLvSQ=;
	h=Date:To:From:Subject:Message-Id; b=KsyCTQz4CR9AMou8/HOxVYbMi4oh87t2MH/LsgI2M+ualRt62A/yVwfQy/HDtSr9vfirKEIS2nv7PNk6usRfwlV98nf/TqNHjEgSH6FxPTmtOTDsKKs9jMBMYa64u/4jqMtRZ3cHG9yfi99e9geymaL0+TrWMvSZDl3LygnaTsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HM7hRMa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HM7hRMa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081B7C19425;
	Fri, 24 Apr 2026 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777054755;
	bh=7D2dFh1+XrD6M5Q8Z9C6vKYG0TSUM82bqK9jxBJLvSQ=;
	h=Date:To:From:Subject:From;
	b=HM7hRMa2SpEVAlAy2ae3zB2Ep2XRmNOy6GpVUpzQb/4twvB5ajSBu5qbt11CUPIdv
	 ZRX2PcUzF6qNMLsPaH/TTPiuvk6fFelA7MNao0mlWhKp+UdlyTsOSli4FVt5A9JjIO
	 8OaAK3eFd78hUPHD0RGdzF1cqSo527eku+F/21PQ=
Date: Fri, 24 Apr 2026 11:19:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch added to mm-new branch
Message-Id: <20260424181915.081B7C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: refactor defrag_show() to use defrag_flags[]
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: huge_memory: refactor defrag_show() to use defrag_flags[]
Date: Wed, 08 Apr 2026 08:47:01 -0700

Replace the hardcoded if/else chain of test_bit() calls and string
literals in defrag_show() with a loop over defrag_flags[] and
defrag_mode_strings[] arrays introduced in the previous commit.

This makes defrag_show() consistent with defrag_store() and eliminates the
duplicated mode name strings.

Link: https://lore.kernel.org/20260408-thp_defrag-v2-2-bc544c1bde4e@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-defrag_show-to-use-defrag_flags
+++ a/mm/huge_memory.c
@@ -455,24 +455,30 @@ static const enum transparent_hugepage_f
 static ssize_t defrag_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
 {
-	const char *output;
+	int active = DEFRAG_NEVER;
+	int len = 0;
+	int i;
 
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
-		     &transparent_hugepage_flags))
-		output = "[always] defer defer+madvise madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always [defer] defer+madvise madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always defer [defer+madvise] madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always defer defer+madvise [madvise] never";
-	else
-		output = "always defer defer+madvise madvise [never]";
+	for (i = 0; i < ARRAY_SIZE(defrag_flags); i++) {
+		if (test_bit(defrag_flags[i], &transparent_hugepage_flags)) {
+			active = i;
+			break;
+		}
+	}
 
-	return sysfs_emit(buf, "%s\n", output);
+	for (i = 0; i < ARRAY_SIZE(defrag_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+					     defrag_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+					     defrag_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
+
+	return len;
 }
 
 static ssize_t defrag_store(struct kobject *kobj,
_

Patches currently in -mm which might be from leitao@debian.org are

kho-fix-error-handling-in-kho_add_subtree.patch
mm-memory-failure-report-mf_msg_kernel-for-reserved-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-regression-test-for-panic_on_unrecoverable_memory_failure.patch
mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch
mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

