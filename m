Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322AB3FB7FD
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634358; cv=none; b=P5hStrIj3FVU8wVKfwYaThGU0mWgW4vjR2EQGHW9HEdaaIOdZERNTeCSGptqjtwZhmZnE/F+RZvcYjPVwJ24IQlMaIMYkFnnKP6K2/iC099heyh7gVGLBkAcNfoziIbVUVbsm7oqlMBiRfzAPlc0m1cZ7qDmlPWzt6XrzPLQaqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634358; c=relaxed/simple;
	bh=hJ3h5F0MxVMvrRu4aruBVUK4OUWZerAMykMQxOayZMg=;
	h=Date:To:From:Subject:Message-Id; b=S3mWuXuh1wFXfF2atDgicoVsB6OEJo7+aIxZOlltx7BoYZBX+d8RaOHPgpHSUEaMKl3C6zgL21/koM4bTm22SaUSsNViXGLQVwE36b4o3VEkWW1OfnkViTAp6xUlwoXpaCI9mpfFNnordV4BRCN93hpCerHXyP2HTzdFzC9YiH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m48yrtHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m48yrtHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ED9C19423;
	Fri, 27 Mar 2026 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634357;
	bh=hJ3h5F0MxVMvrRu4aruBVUK4OUWZerAMykMQxOayZMg=;
	h=Date:To:From:Subject:From;
	b=m48yrtHBdqkTC50MY6/+frAzAOdNLZtDhiw5gbMoyZzf8QtHp1QP78HB01fday2Qc
	 xA/+mttYgKiiWOMga0LBf3+kV/Ss+JwantrJRdRbwy0OlgV5pIx3zXQLBb/0sEM4UT
	 obQSq5R7LGjF9opwqyo9JnpDWla4fWmU0P1W90/k=
Date: Fri, 27 Mar 2026 10:59:17 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch removed from -mm tree
Message-Id: <20260327175917.C6ED9C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch

This patch was dropped because an updated version will be issued

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

drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch
a.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

