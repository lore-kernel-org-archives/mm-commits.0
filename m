Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A6134F48E
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499163; cv=none; b=XiwyhI2JngmFX9idFyuDBDxyzmdOqQJpP7OJin5qFJcguCu4ykpOHFKWasjwTzo9L24BL/lXu8YD4cyfSwTEp5d4x4SC25NwAJKLI/O7WYb7iO9p6VAfx9Uh7LuInSl7COSH/RJzbnxwWWrp1eE06IpoGi7xudrpzJeF5PyB4Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499163; c=relaxed/simple;
	bh=4wzVdeVLSJJkiHn2z5+lE16m/txyMVh9LsXLRyb3Mqg=;
	h=Date:To:From:Subject:Message-Id; b=OGwb3G3V+uEujQHPhuhhcyjMsY1aPw7CjPYgiKfWbd0BXh7/MJAhPyLkGMLatKRr0enjjbUV5uKUZpUtE/7vGumSa4SH2PIrzkRNnxtlB/2ARVqrNjgCB+ERwtB70GDIbgsH5xnl8p+pxx/MRZ3hAoWPXd2IskeiASZCGs6oT1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vkQm34r6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vkQm34r6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1DBC19424;
	Sat, 18 Apr 2026 07:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499163;
	bh=4wzVdeVLSJJkiHn2z5+lE16m/txyMVh9LsXLRyb3Mqg=;
	h=Date:To:From:Subject:From;
	b=vkQm34r6tXnmXZfkraY3VavA9IwvWShjEKpx/usnG6bVjBlL9qPs46xVZtzjA6IQo
	 dNtxlKtso7PCd/0BlnxCvQZwy2Z0ozu3HiNgGqcUM3zLJWBYhTRDR/Fy3Tjj04yh6U
	 jna64xGNKHNiFFFq76u+rLPEJHiX3yHf50riIemM=
Date: Sat, 18 Apr 2026 00:59:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,david@kernel.org,create0818@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-charge_reserved_hugetlb-without-killall.patch removed from -mm tree
Message-Id: <20260418075922.7E1DBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: skip charge_reserved_hugetlb without killall
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-charge_reserved_hugetlb-without-killall.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cao Ruichuang <create0818@163.com>
Subject: selftests: mm: skip charge_reserved_hugetlb without killall
Date: Fri, 10 Apr 2026 12:41:39 +0800

charge_reserved_hugetlb.sh tears down background writers with killall from
psmisc.  Minimal Ubuntu images do not always provide that tool, so the
selftest fails in cleanup for an environment reason rather than for the
hugetlb behavior it is trying to cover.

Skip the test when killall is unavailable, similar to the existing root
check, so these environments report the dependency clearly instead of
failing the test.

Link: https://lore.kernel.org/20260410044139.67480-1-create0818@163.com
Signed-off-by: Cao Ruichuang <create0818@163.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-skip-charge_reserved_hugetlb-without-killall
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -11,6 +11,11 @@ if [[ $(id -u) -ne 0 ]]; then
   exit $ksft_skip
 fi
 
+if ! command -v killall >/dev/null 2>&1; then
+  echo "killall not available. Skipping..."
+  exit $ksft_skip
+fi
+
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 
 fault_limit_file=limit_in_bytes
_

Patches currently in -mm which might be from create0818@163.com are


