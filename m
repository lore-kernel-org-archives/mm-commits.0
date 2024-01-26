Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4998FD310
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255766; cv=none; b=DEElUa5xGrsTN9b3AgDHQnODB7OBJoTZk2ZrSnwpe+DlS9AeyeXshKQl4lmaavbcfqVvKBVrZ16k3c8Gvr5uyJq5rcytMN74uYJFYXrFbCa5eJ6oZB3OTgQQXBL8B15K0z7FK4I4p6cHaMbySu2NqN3gEj29Wo7HBaSwkvwwmJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255766; c=relaxed/simple;
	bh=cfjNeNsoSg+Tshi1d4sWK918LEOU3XD9mt5Vqxws/Z4=;
	h=Date:To:From:Subject:Message-Id; b=lxyxLHVDg/g6bhq8B5/hyJTfw5jt7y//rGJMaTgJYxHlaVq+wblvy66nifEx0bXBzERN8ZW1UXpAbu85Wk+GSYwInsH10nH3PqbHvEtLGwUegCkPEfbuaD0+WplPutWoLWUQqC6ZFYQDJkn4wJOBZg5N4P94ePWjoabmKRUGw0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j8Y7JefQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j8Y7JefQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D703C433C7;
	Fri, 26 Jan 2024 07:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255765;
	bh=cfjNeNsoSg+Tshi1d4sWK918LEOU3XD9mt5Vqxws/Z4=;
	h=Date:To:From:Subject:From;
	b=j8Y7JefQ2sQSc2f3UHh0OW5fwDsYnD9y8Op6XANelj6iwcAjT1qorqZ5JUYdQ7ac+
	 OXL8uxKS2BctNZxFwPp0QiJD7r6R3fQ/fGOaBMqn2HM6zCRcV1zlaWvgzS4PMGI0dE
	 J72JhsrP271zdABIVOkHsZHFtc5I3tMxIEoic1cY=
Date: Thu, 25 Jan 2024 23:56:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,riel@surriel.com,muchun.song@linux.dev,lstoakes@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch removed from -mm tree
Message-Id: <20240126075605.6D703C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: add hugetlb_madv_vs_map
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: run_vmtests.sh: add hugetlb_madv_vs_map
Date: Wed, 17 Jan 2024 09:10:58 -0800

hugetlb_madv_vs_map selftest was not part of the mm test-suite since we
didn't have a fix for the problem it found.

Now that the problem is already fixed (see previous commit), let's
enable this selftest in the default test-suite.

Link: https://lkml.kernel.org/r/20240117171058.2192286-2-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-hugetlb_madv_vs_map
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -253,6 +253,7 @@ nr_hugepages_tmp=$(cat /proc/sys/vm/nr_h
 # For this test, we need one and just one huge page
 echo 1 > /proc/sys/vm/nr_hugepages
 CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
 # Restore the previous number of huge pages, since further tests rely on it
 echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 
_

Patches currently in -mm which might be from leitao@debian.org are

selftests-mm-new-test-that-steals-pages.patch

