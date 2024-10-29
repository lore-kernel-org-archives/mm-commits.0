Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B316FC0B
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 04:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730175251; cv=none; b=baqIQne+XTQnMwwCLIvXn3ztobqxBQYRoeN5bmXYYMdufX85E4AUz6jR6lWQd1gsk9uis2x8JRCC/Kng359ceOfQ3l5/DkfDeH/3YiFMUWtTJO88eLrq77LMJjP7ca7CNlla1jAJWJsx731CqgNLysoYTW1MhsQDHvBMPn5yArI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730175251; c=relaxed/simple;
	bh=grkdmWjOyrbYXgbRUoBCjDWXE6SGe/4dzIxz+Z+8DbU=;
	h=Date:To:From:Subject:Message-Id; b=IyWcEmLcTGMkskXiTVlUAa1Y27TU8WvMce/M2ET6cfr92NV/lNF5h74hKjFQG9QtefBwT1X+9oNSDLJK7hCgxv0HemOWoTlvlp22UXqwG3i4Lj3SFEDUvjPASAogcZI8mE3WCNNf2G6lU2qDclL6h78q8oYdxX2LCjzZmXQp+Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IdDqSdd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IdDqSdd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAD6C4CECD;
	Tue, 29 Oct 2024 04:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730175250;
	bh=grkdmWjOyrbYXgbRUoBCjDWXE6SGe/4dzIxz+Z+8DbU=;
	h=Date:To:From:Subject:From;
	b=IdDqSdd0hevBVJCagz7r0lqK320Cz8vznxY5LJOvQGrBBscJrFak0Gf38eOKSXxZK
	 ldnntKutuEmRaxJOuYaEH1TcE8T54CMO4YjVTOxRW+DFFWOKFKyD0asVhXIjE7FNY+
	 vzZuoo4bNXMckEBIp0AgqHJQO5YbV/rrkYvEJLYA=
Date: Mon, 28 Oct 2024 21:14:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,linux@weissschuh.net,libang.li@antgroup.com,leonylgao@tencent.com,kent.overstreet@linux.dev,jsiddle@redhat.com,joel.granados@kernel.org,j.granados@samsung.com,david@redhat.com,cunhuang@tencent.com,baolin.wang@linux.alibaba.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-add-docs-for-hung_task_detect_count.patch added to mm-nonmm-unstable branch
Message-Id: <20241029041410.BBAD6C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: add docs for hung_task_detect_count
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-add-docs-for-hung_task_detect_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-add-docs-for-hung_task_detect_count.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Lance Yang <ioworker0@gmail.com>
Subject: hung_task: add docs for hung_task_detect_count
Date: Sun, 27 Oct 2024 20:07:47 +0800

This commit introduces documentation for hung_task_detect_count in
kernel.rst.

Link: https://lkml.kernel.org/r/20241027120747.42833-3-ioworker0@gmail.com
Signed-off-by: Mingzhe Yang <mingzhe.yang@ly.com>
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Cun <cunhuang@tencent.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Siddle <jsiddle@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Yongliang Gao <leonylgao@tencent.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~hung_task-add-docs-for-hung_task_detect_count
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -401,6 +401,15 @@ The upper bound on the number of tasks t
 This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
 
 
+hung_task_detect_count
+======================
+
+Indicates the total number of tasks that have been detected as hung since
+the system boot.
+
+This file shows up if ``CONFIG_DETECT_HUNG_TASK`` is enabled.
+
+
 hung_task_timeout_secs
 ======================
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are

hung_task-add-detect-count-for-hung-tasks.patch
hung_task-add-docs-for-hung_task_detect_count.patch

