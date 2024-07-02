Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5CC7EEE7
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 06:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901111; cv=none; b=G5k5VEtKbBxNXIIQVZld7cvENmmbaF9YIZCUUK6nSIg96w4dbWI6cYlZsHFnhM9ZO1VZBySm72JRDaGUIAHGcj4a16QOgcZEb33hlRxGQcJnLTQqpJbmFdTRw0tGfkD4/ZVo8GvUbzJqhh0/N/lOKwkZ8DdEvPTm4ZZgiXNbCw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901111; c=relaxed/simple;
	bh=gsLKTQ09Nc++E4jhFS8pGgW7JQdzjSkbnmYjhIbPbWw=;
	h=Date:To:From:Subject:Message-Id; b=q4y3TeOBrB8U5iWp49zTTixzmy8Zoz3BQTf1zlyzBdY0j3XvCvgpuE97GUTEGKIt+aiyqMTCP2N8pn74Zdp5oYIXhZLOxKW7rFDmpyIDtxHZ8Scp7M+PC7WrhzVa8L+NwLFAMFjp021KAHsIXPHY1q1J+3awh+V5FT7Hl2Ra1Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jk8T9mTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jk8T9mTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D6CC116B1;
	Tue,  2 Jul 2024 06:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719901111;
	bh=gsLKTQ09Nc++E4jhFS8pGgW7JQdzjSkbnmYjhIbPbWw=;
	h=Date:To:From:Subject:From;
	b=Jk8T9mTh5jnizsTL5hAT8lEifAn5hFI9KY620ONVlKhEGuv05s76AmLrIwmMtILLQ
	 T3vnNW6i7My0Q3FzEiB1QR4/2b0M30glH+8QcsntO7FwcoC+4M3GncJxI2L32UNDb+
	 k8tiptfD/nh9krtScQh24LemNXZ46tigKpg6SRSU=
Date: Mon, 01 Jul 2024 23:18:30 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-enable_soft_offline-sysctl-fix.patch added to mm-unstable branch
Message-Id: <20240702061831.38D6CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-mm-add-enable_soft_offline-sysctl-fix
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-add-enable_soft_offline-sysctl-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-enable_soft_offline-sysctl-fix.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: docs-mm-add-enable_soft_offline-sysctl-fix
Date: Mon, 1 Jul 2024 21:15:05 -0700

fix kerneldoc warnings

Link: https://lkml.kernel.org/r/CACw3F52=GxTCDw-PqFh3-GDM-fo3GbhGdu0hedxYXOTT4TQSTg@mail.gmail.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-add-enable_soft_offline-sysctl-fix
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -274,12 +274,15 @@ Correctable memory errors are very commo
 solution for memory pages having (excessive) corrected memory errors.
 
 For different types of page, soft-offline has different behaviors / costs.
+
 - For a raw error page, soft-offline migrates the in-use page's content to
   a new raw page.
+
 - For a page that is part of a transparent hugepage, soft-offline splits the
   transparent hugepage into raw pages, then migrates only the raw error page.
   As a result, user is transparently backed by 1 less hugepage, impacting
   memory access performance.
+
 - For a page that is part of a HugeTLB hugepage, soft-offline first migrates
   the entire HugeTLB hugepage, during which a free hugepage will be consumed
   as migration target.  Then the original hugepage is dissolved into raw
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
mm-memory-failure-userspace-controls-soft-offlining-pages-v7.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
selftest-mm-test-enable_soft_offline-behaviors-v7.patch
docs-mm-add-enable_soft_offline-sysctl.patch
docs-mm-add-enable_soft_offline-sysctl-fix.patch

