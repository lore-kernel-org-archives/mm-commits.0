Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CEA217736
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188445; cv=none; b=UOSu3WkzgCnjDk5OIxWzaBak7dmZZ8z1tfxXojOQXnEpCRxFcklOiAs8/yKC8upJjcR013FFEUtEh/kY4M9acP+jxbtyAW6xeTx3rPrLcblEVEq0HWEDkakTzUsHtdlrffUqs5spm5fV68mkBgpEKHGv4ixp+EIhoH4Ct/ZiwQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188445; c=relaxed/simple;
	bh=XCdYD+hwkahcEeVsrh4NIgO+Pvq4zXJtUVKgpolLgho=;
	h=Date:To:From:Subject:Message-Id; b=Zeci0AwYGKWb3Kp0vC1sGqgbOhH6UNMx2mUGlEieXcfdpeB9iyLgX7XxWkiKc0yGq8loA97ulklkKLgVxf9XfH+PeDr0bZo3ZxB5XZ8gX341kPO/y3CUetSxQfqmFkKHQf370CctU6QDPTz07ULsRc7O3EOE5JWVZVeuCYEc7Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=slVKdbk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="slVKdbk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9942AC4CEEC;
	Mon, 17 Mar 2025 05:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188445;
	bh=XCdYD+hwkahcEeVsrh4NIgO+Pvq4zXJtUVKgpolLgho=;
	h=Date:To:From:Subject:From;
	b=slVKdbk/uPf5VJuAQOwXZwBJVnGhCb17om65VIXRTeC8c02Wj432JEfvWEfYNhmlw
	 9HEoiY8FgdoMkJPQqRrntWMHf1wDgQkqk8hIz9ozyvs5xPoLVjNahXYdkAdrPpkmXc
	 GCECu2TL7LQNXQ6N9XbwDd+EOyA2bI8kEa89K5uI=
Date: Sun, 16 Mar 2025 22:14:05 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch removed from -mm tree
Message-Id: <20250317051405.9942AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip gup_longterm tests on weird filesystems
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: skip gup_longterm tests on weird filesystems
Date: Tue, 11 Mar 2025 13:18:19 +0000

Some filesystems don't support ftruncate()ing unlinked files.  They return
ENOENT.  In that case, skip the test.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-8-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-skip-gup_longterm-tests-on-weird-filesystems
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -96,7 +96,15 @@ static void do_test(int fd, size_t size,
 	int ret;
 
 	if (ftruncate(fd, size)) {
-		ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
+		if (errno == ENOENT) {
+			/*
+			 * This can happen if the file has been unlinked and the
+			 * filesystem doesn't support truncating unlinked files.
+			 */
+			ksft_test_result_skip("ftruncate() failed with ENOENT\n");
+		} else {
+			ksft_test_result_fail("ftruncate() failed (%s)\n", strerror(errno));
+		}
 		return;
 	}
 
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

