Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8BC21832F
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019128; cv=none; b=ig9MO70P8y3+GzUgMI43yvf6KhKlhva+bSTzilPzL/3dKf499a3cuINqMb+7lOdqw2MQsaxHCDr9CUnnNn95RMaO6RDOe3ph6I4Tndpkw64/WW8YF1dXpiNRwYgGpwPr1dIy7667F8ixGXnd6p46xnEQdj2g9Hcoo0w86Qt6ac4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019128; c=relaxed/simple;
	bh=3kiAjy8tR9cV4Z4YOi4Y/C1CCWeEvl3TjnlP11AQOuU=;
	h=Date:To:From:Subject:Message-Id; b=q0Une9UIeEw34w7+8F0ZVRUuny682fysbwiytYwV47qpFf6yB7KNjh2+qvZ64BtpfFloHAsBm9vmkxy0Sg/UYDfGNhqy+WCcGlRGyfgUobW5L1hYYjMx/D4Sm5tVoC7DzSfRSnUt4vUmYYZ4/04Q6846CS37aWb2ltJsH8bbjiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CZ9bwoUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CZ9bwoUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90550C4CECC;
	Thu,  7 Nov 2024 22:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019128;
	bh=3kiAjy8tR9cV4Z4YOi4Y/C1CCWeEvl3TjnlP11AQOuU=;
	h=Date:To:From:Subject:From;
	b=CZ9bwoUVz4XAdHWWYyxDxMFfibH4NuH5DTl8GbphVy9Vm+XqEEEClW8gnvIaiw7+u
	 yZwNlpfxS4GDpH3j2D070WBfvTM2SpQSds60s0jKGTeATdkB3bh8sNvc7HjNtU+ycS
	 StpVnGYNaH9ufNspM+ZDo6YL82ygVF3QFE9Hehjk=
Date: Thu, 07 Nov 2024 14:38:48 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch removed from -mm tree
Message-Id: <20241107223848.90550C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/huge_count_read_write: remove unnecessary debugging message
has been removed from the -mm tree.  Its filename was
     selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/huge_count_read_write: remove unnecessary debugging message
Date: Mon, 28 Oct 2024 16:30:54 -0700

The program prints expected errors from write/read of the files with
invalid huge count, for only debugging purpose.  It is only making the
output noisy.  Remove those.

Link: https://lkml.kernel.org/r/20241028233058.283381-3-sj@kernel.org
Fixes: b4a002889d24 ("selftests/damon: test debugfs file reads/writes with huge count")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/huge_count_read_write.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/damon/huge_count_read_write.c~selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message
+++ a/tools/testing/selftests/damon/huge_count_read_write.c
@@ -28,9 +28,7 @@ void write_read_with_huge_count(char *fi
 	}
 
 	write(filedesc, "", 0xfffffffful);
-	perror("after write: ");
 	ret = read(filedesc, buf, 0xfffffffful);
-	perror("after read: ");
 	close(filedesc);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch
maintainers-memory-management-add-document-files-for-mm.patch

