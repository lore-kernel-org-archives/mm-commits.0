Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1DA153597
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 21:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714079556; cv=none; b=rUYdqioKMwyQPK0us+C1hSdYkqdmle+O5C2ZJzI35ux5RiKnz/KPsMqQsw0Ewc4sQ8qjEm98fu5tz8tKB7+z43lwWIQpCnu4/kE+sEdmEYZmdZnzB5V9Aomfn9o+x1OBQJ2FGPSHE0VHLoAE281IBiSuA/x+dVWIuG9PSTtYYI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714079556; c=relaxed/simple;
	bh=rQbvA32qYXgtPH/6I+CoQFtxx0EMKbbx52qvasODpK8=;
	h=Date:To:From:Subject:Message-Id; b=la4hfdbH8qXAKgT8RtH5GEKilq55W9vVmPr1EkmjyGqYmINN02ToT/AFLGQOXUzPcVTTpxZ62+kmCxnk6OUttzdjhIyvk8raKl9OWcdUS2Wu6gRG3xlvpbDiA51KRUz71XY9BmDALkDFUcuVjuhZwqs0wUGLqF7F+rgal1Yrsb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5EI8MXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5EI8MXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70C3C113CC;
	Thu, 25 Apr 2024 21:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714079556;
	bh=rQbvA32qYXgtPH/6I+CoQFtxx0EMKbbx52qvasODpK8=;
	h=Date:To:From:Subject:From;
	b=Z5EI8MXL76Sq4dYmN95Rzh2NsLxeNJqspmD3OI7N1Ptqcaiudr2KjAk+pJVcK0TAg
	 W9h10kUSXVpe4Y8l35pZoZ0IPOc44cAMs1g9mxt9ERfjNZWO+wR9v1ONBY9bQlPGqM
	 JMf9dWK5lO++rGnCl53iU0+FkC6rrSpnpTJJA+kI=
Date: Thu, 25 Apr 2024 14:12:35 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-tighten-file-permissions-on-proc-allocinfo.patch added to mm-unstable branch
Message-Id: <20240425211235.E70C3C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: Tighten file permissions on /proc/allocinfo
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-tighten-file-permissions-on-proc-allocinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-tighten-file-permissions-on-proc-allocinfo.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: alloc_tag: Tighten file permissions on /proc/allocinfo
Date: Thu, 25 Apr 2024 13:08:50 -0700

The /proc/allocinfo file exposes a tremendous about of information about
kernel build details, memory allocations (obviously), and potentially even
image layout (due to ordering).  As this is intended to be consumed by
system owners (like /proc/slabinfo), use the same file permissions as
there: 0400.

Link: https://lkml.kernel.org/r/20240425200844.work.184-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-tighten-file-permissions-on-proc-allocinfo
+++ a/lib/alloc_tag.c
@@ -129,7 +129,7 @@ size_t alloc_tag_top_users(struct codeta
 
 static void __init procfs_init(void)
 {
-	proc_create_seq("allocinfo", 0444, NULL, &allocinfo_seq_op);
+	proc_create_seq("allocinfo", 0400, NULL, &allocinfo_seq_op);
 }
 
 static bool alloc_tag_module_unload(struct codetag_type *cttype,
_

Patches currently in -mm which might be from keescook@chromium.org are

alloc_tag-tighten-file-permissions-on-proc-allocinfo.patch

