Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F5F14265A
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274073; cv=none; b=euyvG7jlqA2twFtHL3ebA/hWhMyNFvH6XCK+pS/PHzX+vmYLjNeirNjzLZSxpKzaRb3dvQ2/K/ORRVDPVY4RsdHZimtV1PXV6/RfN5mJz1jho1XHFxsfZCXjk2kbtSR3IcXkVLDeaumpGv/j3tqNHQ9dPiztef0tE5Y4uVHNaBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274073; c=relaxed/simple;
	bh=JZGjJfwGmE56gNPghgZkOMwTT3FhQHNSo2GN6k4ZMHU=;
	h=Date:To:From:Subject:Message-Id; b=L8CplvymZ4KhXRPiEkH3R8sP2P8Bt3Mdl3C6oSr2CmgDW2ogLRroTrk0q1cg2zUdO1PiA06INTUJB5NdA40/jWzQSrkfujd2QAb38625eJhYPV3/VIu5TD8pwise8qQkZh3zSseWWFJvF6QCZOwxCNCeU8UEdFQYvK5Jo7xMl8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=olWlZHGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="olWlZHGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355ACC433B1;
	Tue, 12 Mar 2024 20:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274073;
	bh=JZGjJfwGmE56gNPghgZkOMwTT3FhQHNSo2GN6k4ZMHU=;
	h=Date:To:From:Subject:From;
	b=olWlZHGBmo+NIblEoJDu5wVXT02/lUuyHpO29mJLtVp+D0gUJ6bNpjIJz2w/WFJkT
	 bWKhZj4StGnHqRtl02YHngAf+Ryc6vNtAu/EJAPzNtO3VE5amI3gmcFyE6tl3PyCcN
	 aj/Jg/w/xG7UHKFNJ+Y3F76c1q70ky98JNTo39fI=
Date: Tue, 12 Mar 2024 13:07:52 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,muchun.song@linux.dev,ben@decadent.org.uk,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements.patch removed from -mm tree
Message-Id: <20240312200753.355ACC433B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip the hugetlb-madvise tests on unmet hugepage requirements
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: selftests/mm: skip the hugetlb-madvise tests on unmet hugepage requirements
Date: Wed, 6 Mar 2024 15:37:14 -0700

Now that run_vmtests.sh does not guarantee that the correct hugepage count
is available, skip the hugetlb-madvise test if the requirements are not
met rather than failing.

Link: https://lkml.kernel.org/r/20240306223714.320681-4-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-skip-the-hugetlb-madvise-tests-on-unmet-hugepage-requirements
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -19,6 +19,7 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include "vm_util.h"
+#include "../kselftest.h"
 
 #define MIN_FREE_PAGES	20
 #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
@@ -78,7 +79,7 @@ int main(int argc, char **argv)
 	free_hugepages = get_free_hugepages();
 	if (free_hugepages < MIN_FREE_PAGES) {
 		printf("Not enough free huge pages to test, exiting!\n");
-		exit(1);
+		exit(KSFT_SKIP);
 	}
 
 	fd = memfd_create(argv[0], MFD_HUGETLB);
_

Patches currently in -mm which might be from npache@redhat.com are


