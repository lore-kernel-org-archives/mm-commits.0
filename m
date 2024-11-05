Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C0336127
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 03:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730778530; cv=none; b=JFNk3u9Zlcy4UDKsDEahpeGzT+89qUu6cZuB4MvZXL1o0KfiIOwzDCTAxohb4E6PF5PtBfLMpuVlk+7yke2YrD4ziJkHRRKhTna5G3J5N3s1XweAsQMq02X2FZ44i8QfSYFwQGyUVELsz/A3E3KXaQ7q/g7Z9JIYVnZRog9yG4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730778530; c=relaxed/simple;
	bh=JDVbyEiDEJUOlEcrioIAE4y9jHL4ZiEMBxdsViiE4kU=;
	h=Date:To:From:Subject:Message-Id; b=JN/gB7XdsoQRuD0ju05AkNWoROVj5ne0al2vZCSbHPlYZYRjwepUglsJPesBbzopRSwUhKFt3vzTntF8+bo534uB7fTCBISDNsyqPf7LwbcsjAgWgQwYEbgmK/U0EmpQVWhzCfwnZZQ9EVI0byci9vOJrn65gVgE8K4aW6hIXZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UMRUT4is; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UMRUT4is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65173C4CECF;
	Tue,  5 Nov 2024 03:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730778529;
	bh=JDVbyEiDEJUOlEcrioIAE4y9jHL4ZiEMBxdsViiE4kU=;
	h=Date:To:From:Subject:From;
	b=UMRUT4isFbayU/NKz3wJpMvzvnd8eH2ePOY7TbN9Q2XSutYLA7YEZgzCGbcKZs6s6
	 I9KqhzZRK9kSn+YAvcrlzxoNcmFvvBRTf8DsCU6MnHadGHaWPn81+USNhx+MzRTckZ
	 EbILYyrbsw9t+bIg9hakm3/3QxzCeiP4PX1fHic0=
Date: Mon, 04 Nov 2024 19:48:48 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch added to mm-unstable branch
Message-Id: <20241105034849.65173C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon: recommend academic papers to read and/or cite
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon: recommend academic papers to read and/or cite
Date: Fri, 1 Nov 2024 13:35:57 -0700

Kernel documentation is the most up-to-date and recommended resource for
DAMON.  It doesn't cover non-kernel part of the entire project[1], though.
Also it is not optimum for formal long-term citations.  Depending on
cases, DAMON academic papers[2,3] could be better to be read and cited. 
However, there is no clear guidance for those.  Add a paragraph for DAMON
academic papers on the kernel documentation for DAMON.

[1] https://damonitor.github.io
[2] https://dl.acm.org/doi/abs/10.1145/3366626.3368125
[3] https://dl.acm.org/doi/abs/10.1145/3502181.353146

Link: https://lkml.kernel.org/r/20241101203557.55210-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/index.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/mm/damon/index.rst~docs-mm-damon-recommend-academic-papers-to-read-and-or-cite
+++ a/Documentation/mm/damon/index.rst
@@ -37,3 +37,9 @@ with no code but simple configurations.
 
 To utilize and control DAMON from the user-space, please refer to the
 administration :doc:`guide </admin-guide/mm/damon/index>`.
+
+If you prefer academic papers for reading and citations, please use the papers
+from `HPDC'22 <https://dl.acm.org/doi/abs/10.1145/3502181.3531466>`_ and
+`Middleware19 Industry <https://dl.acm.org/doi/abs/10.1145/3366626.3368125>`_ .
+Note that those cover DAMON implementations in Linux v5.16 and v5.15,
+respectively.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-zero-aggregationops_update-intervals.patch
mm-damon-core-handle-zero-schemes-apply-interval.patch
mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input.patch
selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch
docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch

