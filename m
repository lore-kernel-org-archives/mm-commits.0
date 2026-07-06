Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD3813B7AE
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 01:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783299663; cv=none; b=PcYyutQpSZkYVDthBIA4NM0MfQsz+8tC2lsgnVxGtHNfhJdrkaBkxg+JBOhCkrO4c5oFdrTyDUxu78bl5pmkJlgFgNoMUCFnds8NyVnsarO6oMYNf8bGdQMKvrk1tWVOsJbliCJnJyIqHUdjGwFGqA/IqmwzCvJoU5Lr7iT9E+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783299663; c=relaxed/simple;
	bh=3enqslEUYdMs6v5cdy7qZwnD7Kaq6wXjLJXyxoxM5OA=;
	h=Date:To:From:Subject:Message-Id; b=NvuZ3/Gz4UTZilibSqGnQqifjwy8d+qw1HAWcQ04ERAW+9FKYtjm/kiIz46EtM6x3doL7lNj4ejlTKOHJ/6eJNcwTqVXW0DtD0dxC4KlSzBpe+6Wc+RaJ7B2wLe8Sa8WoePdEVzlEwAXa/ork7/F7psSEqCEf2XGKTIfYRKJVGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TSlzeFv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TSlzeFv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F22B1F000E9;
	Mon,  6 Jul 2026 01:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783299662;
	bh=wp//TH3VGN7thpQFVlLxEBpHWO/u4sCDZbQy+WXvkqM=;
	h=Date:To:From:Subject;
	b=TSlzeFv9isrParUFHAUbizBDAB5RobUpa9mlFQ5Sb18tAVfGTUhqvxNmvx+eTd6ya
	 WMrjQv4j8fGmqEfAHIvFgmNBCwwjQKWP79olqRZ4PORO06rj+ZB2vnUegzyIlSi/0M
	 T9VG/CbkkFyqF58GFF94GNprvb7MGdenEVVlsAmg=
Date: Sun, 05 Jul 2026 18:01:01 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,thuth@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-replace-__assembly__-with-__assembler__-in-percpu-defsh-header-file.patch added to mm-new branch
Message-Id: <20260706010102.3F22B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: replace __ASSEMBLY__ with __ASSEMBLER__ in percpu-defs.h header file
has been added to the -mm mm-new branch.  Its filename is
     percpu-replace-__assembly__-with-__assembler__-in-percpu-defsh-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-replace-__assembly__-with-__assembler__-in-percpu-defsh-header-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Thomas Huth <thuth@redhat.com>
Subject: percpu: replace __ASSEMBLY__ with __ASSEMBLER__ in percpu-defs.h header file
Date: Fri, 19 Jun 2026 17:47:04 +0200

While the GCC and Clang compilers already define __ASSEMBLER__
automatically when compiling assembly code, __ASSEMBLY__ is a macro that
only gets defined by the Makefiles in the kernel.  This can be very
confusing when switching between userspace and kernelspace coding, or when
dealing with uapi headers that rather should use __ASSEMBLER__ instead. 
So let's standardize now on the __ASSEMBLER__ macro that is provided by
the compilers.

This is a completely mechanical patch (done with a simple "sed -i"
statement.

Link: https://lore.kernel.org/20260619154704.41293-1-thuth@redhat.com
Signed-off-by: Thomas Huth <thuth@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/percpu-defs.h~percpu-replace-__assembly__-with-__assembler__-in-percpu-defsh-header-file
+++ a/include/linux/percpu-defs.h
@@ -203,7 +203,7 @@
 /*
  * Accessors and operations.
  */
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 /*
  * __verify_pcpu_ptr() verifies @ptr is a percpu pointer without evaluating
@@ -514,5 +514,5 @@ do {									\
 #define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
 #define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* _LINUX_PERCPU_DEFS_H */
_

Patches currently in -mm which might be from thuth@redhat.com are

mm-replace-__assembly__-with-__assembler__-in-memory-management-header-files.patch
percpu-replace-__assembly__-with-__assembler__-in-percpu-defsh-header-file.patch

