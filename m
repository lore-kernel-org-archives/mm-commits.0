Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EE0284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126296; cv=none; b=enq3KSvJ3QVEFttrhnM5mSviinl7sYhLngy2IDuoOFE43O1KoGdAaBaxPDg4j1bOKIxAwfPNp/ZuT9Gt0jsmll6hhRScoLqqX7kbXIJkM8hrRczteY6X/Q7jV1Wo7aXrlFfiChfUHmNJVwoEU7qBp60MI5IGmjSS0/91oClb53w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126296; c=relaxed/simple;
	bh=jr40icbIUmT7OirgXbNycmVoZhpv1TfOIfm1BVtae/k=;
	h=Date:To:From:Subject:Message-Id; b=hNFeUnA85z+R1QOwuq/TDIzkKh6FTfwnlJyyPo4o5eM8PL8yJjJKb8ghvfF6fiQYR0ONawBXZmzXpvMWIntWpLW0imct2uUVoyf4ksj5JRc6Aag0sTmnpyXBoAX04rTFNqrPQJ6Vgai4OM/gPBUeC9aq4C5ZL76eZooFi3ShgCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vCjqgt3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vCjqgt3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE451C4CEE3;
	Thu, 10 Jul 2025 05:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126296;
	bh=jr40icbIUmT7OirgXbNycmVoZhpv1TfOIfm1BVtae/k=;
	h=Date:To:From:Subject:From;
	b=vCjqgt3jf+NSt4n9eA0JSPnLp44I4+3qZvMCR8vmzSgJMPS+2hE1ARKdNVoTrRGpk
	 x+QUpNTCtu7Zsb+w5Gv6jB73YYk4fYgtvOdPCqVbwsQChcps4aeujHvyfjoSyqP9K7
	 9hOlAc1RNQV760OIXdG6pI8lX+CUimlfe3/emdEo=
Date: Wed, 09 Jul 2025 22:44:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-shmem-collapse-as-a-default-test-item.patch removed from -mm tree
Message-Id: <20250710054455.EE451C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: add shmem collapse as a default test item
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-shmem-collapse-as-a-default-test-item.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: selftests: mm: add shmem collapse as a default test item
Date: Fri, 13 Jun 2025 09:49:20 +0800

Currently, we only test anonymous memory collapse by default.  We should
also add shmem collapse as a default test item to catch issues that could
break the test cases.

Link: https://lkml.kernel.org/r/a30b1529b399f2e649b5a05c3d352f41a68faeae.1749779183.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-shmem-collapse-as-a-default-test-item
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -485,6 +485,10 @@ CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
 
+CATEGORY="thp" run_test ./khugepaged all:shmem
+
+CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
+
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 # Try to create XFS if not provided
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
khugepaged-kick-khugepaged-for-enabling-none-pmd-sized-mthps.patch
mm-fault-in-complete-folios-instead-of-individual-pages-for-tmpfs.patch

