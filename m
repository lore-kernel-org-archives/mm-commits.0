Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1B22868B5
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896566; cv=none; b=mbqwlhiSvNvDQJoBy6U/30yohE/ALi7R+n9Pb7OSoMRCcl1SKi2WidRiGycwB+HaxSA+5OqzGQtlUefxxBXoQhetIYi0V8oB54G7qibdWfZOC0rqtTDi+Vf5fWjwhc2oI2SSflwCEINI8q93HyrtaqfUa2K6PAdjkyJjpirMmyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896566; c=relaxed/simple;
	bh=4Z3efDq+ukIrM8A3hV+5vYbiaqHO6HFfd5vIx7TSZAY=;
	h=Date:To:From:Subject:Message-Id; b=Fajd7N0+4kzN+E9r1C+HIX5dBNT76/go3Yl4c26BVOSInR+ivmX5ZY6DXQynBU+kztigUZzW4OaDzj4vhKcfvqkJksd6QfaTABKLp+t/TajXsMtG0uHGXSIYNtT6PQfJyKl5xNLWwBq7UQGGRUk8PyM1o25iT9z0J/iAwTimtlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lrGoM/DP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lrGoM/DP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4831F00A3A;
	Wed,  5 Aug 2026 02:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896564;
	bh=w1JwL24SjKwRrN4l8b/Swy0imYjoKiNxvtK/yyTtztA=;
	h=Date:To:From:Subject;
	b=lrGoM/DPupCflXCdkeVRxMarzF8fFV8JQQhtdWaC/9OIRLLDeB4Fx4vlwvdnGTBWr
	 StOILQBcN2CGEg5iMltA8CNuz1ZH5A1pz4Xkf+goJy5zucWv+gZwNdtpDRiV3WlIN7
	 8eE56Oxv7sQH5yAbv5IVjxjlHhr2lD/VLU99cm3M=
Date: Tue, 04 Aug 2026 19:22:43 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,thuth@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-replace-__assembly__-with-__assembler__-in-percpu-defsh-header-file.patch removed from -mm tree
Message-Id: <20260805022244.6F4831F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: replace __ASSEMBLY__ with __ASSEMBLER__ in percpu-defs.h header file
has been removed from the -mm tree.  Its filename was
     percpu-replace-__assembly__-with-__assembler__-in-percpu-defsh-header-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


