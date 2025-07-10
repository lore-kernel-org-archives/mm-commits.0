Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA212285CA6
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126380; cv=none; b=WpXOUBV8yk1ImTKYxk4gTH0wBriZ/bHXBVQj/gRa6YCKSHRwlGLl07rRnNZsoFSBI9h+lPr6hzKRtc7J7DhHd7bn0UVNd6/Z/aVoCn6xzsEcjSK+mGnDYnAoa8AcaAaimxi/9bsyJ/9kNwmBpXLTfD/bpjoLq/G1Tv3sRERSyi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126380; c=relaxed/simple;
	bh=449hAv4tv7coFzZ1ALIz2AdbnBD8Z68zxX0ImLi5qdg=;
	h=Date:To:From:Subject:Message-Id; b=R9KW5e05M6aFCaj0aCQ4xmMZLE2xuGqQKmTjDH6q0Zefy6z2rleQdzH8r/m1C07lEtm8Q8TLy4MFdIhL86QmhSz6Og720pIMiZGRZptSyRqmAokIFJaH2WOGjUX+E3LhXRz30drKQ850a0Zr6JC+w22xgyu2OBPvDxQOymqXXlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ey6kIDwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ey6kIDwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD3EC4CEE3;
	Thu, 10 Jul 2025 05:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126380;
	bh=449hAv4tv7coFzZ1ALIz2AdbnBD8Z68zxX0ImLi5qdg=;
	h=Date:To:From:Subject:From;
	b=Ey6kIDwmqj34n+F9dTXukol0EI3DVMBe+r+6RGWmljv8ZDoFHyc8LO6l5nUjhY1dF
	 jFV6VcJ8KytZqVV2S/SdSgtUcidYabg/lxARzeDN8CXz1yUsGNQ7A5a+I4DFqx/lHz
	 VyqLGiTpX4bD1lpzEHWg5bpso5E4fN/4oOa8oA+A=
Date: Wed, 09 Jul 2025 22:46:19 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dev.jain@arm.com,moonhee.lee.ca@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-duplicate-gitignore-entries.patch removed from -mm tree
Message-Id: <20250710054620.3AD3EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove duplicate .gitignore entries
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-duplicate-gitignore-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Subject: selftests/mm: remove duplicate .gitignore entries
Date: Wed, 25 Jun 2025 19:07:58 -0700

Remove redundant entries in .gitignore confirmed by:

$ sort tools/testing/selftests/mm/.gitignore | uniq -d
hugetlb_dio
pkey_sighandler_tests_32
pkey_sighandler_tests_64

These entries were originally added by [1], and later duplicated by [2].

[1] https://lore.kernel.org/all/20240924185911.117937-1-lorenzo.stoakes@oracle.com/
[2] https://lore.kernel.org/all/20241125064036.413536-1-lizhijian@fujitsu.com/

Link: https://lkml.kernel.org/r/20250626020758.163243-1-moonhee.lee.ca@gmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-remove-duplicate-gitignore-entries
+++ a/tools/testing/selftests/mm/.gitignore
@@ -38,9 +38,6 @@ map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
 memfd_secret
-hugetlb_dio
-pkey_sighandler_tests_32
-pkey_sighandler_tests_64
 soft-dirty
 split_huge_page_test
 ksm_tests
_

Patches currently in -mm which might be from moonhee.lee.ca@gmail.com are

selftests-ptrace-add-set_syscall_info-to-gitignore.patch

