Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0610635891
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g7SKTEbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6092C433C8;
	Fri,  5 Jan 2024 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478735;
	bh=Jz6Emt0mN03uDFoHugrPgNmBBUf25ldylpp0Y4E/b84=;
	h=Date:To:From:Subject:From;
	b=g7SKTEbYIhmSbwY1xwP/sv+GnSOo7179d0ov7y9lUas9Zje/pH3sfI11WzZpRA2C3
	 iWUXn4tVY89vjdLoEGK9ZU4uj/TrPCxwp9gTItTyfd1sQyR15PxsJ9oXKe58RQtK/q
	 L9eScPQ6Gi4MV2GMRhpGdOWqaA3x5jMKAjpX4dyk=
Date: Fri, 05 Jan 2024 10:18:55 -0800
To: mm-commits@vger.kernel.org,zhangpeng362@huawei.com,willy@infradead.org,viro@zeniv.linux.org.uk,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,mhocko@suse.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,hughd@google.com,david@redhat.com,brauner@kernel.org,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-separate-uffdio_move-test-for-pmd-splitting.patch removed from -mm tree
Message-Id: <20240105181855.C6092C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add separate UFFDIO_MOVE test for PMD splitting
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-separate-uffdio_move-test-for-pmd-splitting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: selftests/mm: add separate UFFDIO_MOVE test for PMD splitting
Date: Fri, 29 Dec 2023 18:56:36 -0800

Add a test for UFFDIO_MOVE ioctl operating on a hugepage which has to be
split because destination is marked with MADV_NOHUGEPAGE.  With this we
cover all 3 cases: normal page move, hugepage move, hugepage splitting
before move.

Link: https://lkml.kernel.org/r/20231230025636.2477429-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-separate-uffdio_move-test-for-pmd-splitting
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1199,6 +1199,16 @@ static void uffd_move_test(uffd_test_arg
 
 static void uffd_move_pmd_test(uffd_test_args_t *targs)
 {
+	if (madvise(area_dst, nr_pages * page_size, MADV_HUGEPAGE))
+		err("madvise(MADV_HUGEPAGE) failure");
+	uffd_move_test_common(targs, read_pmd_pagesize(),
+			      uffd_move_pmd_handle_fault);
+}
+
+static void uffd_move_pmd_split_test(uffd_test_args_t *targs)
+{
+	if (madvise(area_dst, nr_pages * page_size, MADV_NOHUGEPAGE))
+		err("madvise(MADV_NOHUGEPAGE) failure");
 	uffd_move_test_common(targs, read_pmd_pagesize(),
 			      uffd_move_pmd_handle_fault);
 }
@@ -1329,6 +1339,13 @@ uffd_test_case_t uffd_tests[] = {
 		.mem_targets = MEM_ANON,
 		.uffd_feature_required = UFFD_FEATURE_MOVE,
 		.test_case_ops = &uffd_move_test_pmd_case_ops,
+	},
+	{
+		.name = "move-pmd-split",
+		.uffd_fn = uffd_move_pmd_split_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE,
+		.test_case_ops = &uffd_move_test_pmd_case_ops,
 	},
 	{
 		.name = "wp-fork",
_

Patches currently in -mm which might be from surenb@google.com are


