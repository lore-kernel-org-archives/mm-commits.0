Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4BA214A89
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188437; cv=none; b=a6pNWSZampPvV+qbM8LR3Fjp0k9KSGnvZv6bz2yzLVaeYBh/rkm8PoNjI8jvm/rIvFhsuowc8RzfEByurg2lqEAnrX6bAVKb4LY5W3ZdRsYn4RKZKmJnglhe6Vph3tBcNG3u9FYzigpn+C1D9rfr0PCs9gP3ewWlpLM0H0Ht+kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188437; c=relaxed/simple;
	bh=loXAK0JuSqthThER/kc11Wqtt9NmFxEmZvBC046JX0c=;
	h=Date:To:From:Subject:Message-Id; b=ErvHyIhIIwxY+RmEtnv6TPqWa+BAMqnAfOCl0MJ1ybVmoAAah7SWIiVN9yswvoqutzBJ4404GpM6UVC79jz3FbiNiHGTub/G57Xz8AsoA70ar9O75uJK4llUjMicxwqJjfIi1rn7q1hBYmscCSBhhTV8CVWZSEEPrx2e6Y8WAn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=clFlcMAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="clFlcMAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32EBC4CEEC;
	Mon, 17 Mar 2025 05:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188437;
	bh=loXAK0JuSqthThER/kc11Wqtt9NmFxEmZvBC046JX0c=;
	h=Date:To:From:Subject:From;
	b=clFlcMAGNukmlzyy0AQuHsUXY71cvmW3ZIavMSOOYfVmfVXrC2wsfDVvDdWmkcwbJ
	 9Pc6475YshWAc+ciRLiprfO7JlYwXHrX/f0mQCxO2gpuXzzx9iYrRjGZcOJaKpbBLq
	 SSOS04Hbl/+BbptcurXgL0kGEVw0k/MGMf0ZIk+8=
Date: Sun, 16 Mar 2025 22:13:57 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch removed from -mm tree
Message-Id: <20250317051357.A32EBC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip uffd-stress if userfaultfd not available
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: skip uffd-stress if userfaultfd not available
Date: Tue, 11 Mar 2025 13:18:13 +0000

It's pretty obvious that the test wouldn't work if you don't have the
feature enabled.  But, it's still useful to SKIP instead of failing so the
reader can immediately tell that this is the reason why.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-2-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-stress-if-userfaultfd-not-available
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -412,8 +412,8 @@ static void parse_test_type_arg(const ch
 	 * feature.
 	 */
 
-	if (uffd_get_features(&features))
-		err("failed to get available features");
+	if (uffd_get_features(&features) && errno == ENOENT)
+		ksft_exit_skip("failed to get available features (%d)\n", errno);
 
 	test_uffdio_wp = test_uffdio_wp &&
 		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

