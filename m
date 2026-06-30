Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F064B218ADD;
	Tue, 30 Jun 2026 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782848036; cv=none; b=YCMTOTRgrGLpuveSaBmXgzRjr7ZONMuFiwTkVd/4r+n0cOCfyfoEDFVKHIo+Vmfu71WQXU2DQXV4mUSSM6ppu5BJB2ctmhC5YiyoZzvsMLwjTOF0hpj+PsfKWVfVMzoLe6tqTSB0OLrPJyM+ttJ8odBQHzu1Utj7bINK3yH7k8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782848036; c=relaxed/simple;
	bh=Eg20+VAAssc3FYkdk1eSTyJ1S+d8iw//th1NOcFJIb4=;
	h=Date:To:From:Subject:Message-Id; b=ipdSZAHaGTCZ06BFcB6Wir0MRNuOqcpSgtUodtsmiBS9KshD1R0dSNyVqh4mrEMRDgg+FLylBgmUD/rvdrAdOq8coOzFqDdQU27ZE2nyKSDCyxGaejTxCQLBbEZB/VdWZbNkOiYBsOXa7k6gXniBrylfUHNbBWhu9Jv7cdIESks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=slE3RoQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="slE3RoQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870441F000E9;
	Tue, 30 Jun 2026 19:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782848034;
	bh=StlVVE0MT/EAK8je7lu0gcmBlcRPvkEXViRwqB+pZqc=;
	h=Date:To:From:Subject;
	b=slE3RoQUPmyQ+edY/giVJAYUzs9ggblhuGSjQZ4TPXqGfy31F9KffkH8jXfhgJn2z
	 /7Ko+H/xxakext36dVSSZBTZW9y9i/zfPvcQEXcYSljWzd04m6wRGTvbRiuM2xbjKZ
	 udOl0A7IpIrPPIMsFFSIrUZKFb7Ho2lD11ZF8JLE=
Date: Tue, 30 Jun 2026 12:33:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bootconfig-fix-undefined-behavior-involving-null-pointer-arithmetic.patch added to mm-nonmm-unstable branch
Message-Id: <20260630193354.870441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bootconfig: fix undefined behavior involving NULL pointer arithmetic
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bootconfig-fix-undefined-behavior-involving-null-pointer-arithmetic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bootconfig-fix-undefined-behavior-involving-null-pointer-arithmetic.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Bradley Morgan <include@grrlz.net>
Subject: lib/bootconfig: fix undefined behavior involving NULL pointer arithmetic
Date: Tue, 30 Jun 2026 17:47:46 +0000

When xbc_snprint_cmdline() is called during the size-probing phase (with
buf = NULL and size = 0), the function computes the end pointer as 'buf +
size' (NULL + 0) and repeatedly advances 'buf' via 'buf += ret'.

Under the C standard, performing pointer arithmetic on a NULL pointer is
undefined behavior.  While harmless inside the kernel, this code is also
compiled into the userspace host tool 'tools/bootconfig', where host
compilers with UBSan or FORTIFY_SOURCE enabled abort the build when they
detect NULL pointer arithmetic.

Fix this by guarding the pointer arithmetic so 'buf' is only advanced when
non-NULL, and track the running written length in a separate 'len' counter
for the return value (which cannot be recovered from pointer math when
'buf' is NULL).  The rest() helper and snprintf call sites are unchanged.

Link: https://lore.kernel.org/20260630174746.14795-1-include@grrlz.net
Fixes: 51887d03aca1 ("bootconfig: init: Allow admin to use bootconfig for kernel command line")
Assisted-by: GLM:glm-5.2
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/lib/bootconfig.c~lib-bootconfig-fix-undefined-behavior-involving-null-pointer-arithmetic
+++ a/lib/bootconfig.c
@@ -427,8 +427,9 @@ static char xbc_namebuf[XBC_KEYLEN_MAX]
 int __init xbc_snprint_cmdline(char *buf, size_t size, struct xbc_node *root)
 {
 	struct xbc_node *knode, *vnode;
-	char *end = buf + size;
+	char *end = buf ? buf + size : NULL;
 	const char *val, *q;
+	size_t len = 0;
 	int ret;
 
 	xbc_node_for_each_key_value(root, knode, val) {
@@ -442,7 +443,9 @@ int __init xbc_snprint_cmdline(char *buf
 			ret = snprintf(buf, rest(buf, end), "%s ", xbc_namebuf);
 			if (ret < 0)
 				return ret;
-			buf += ret;
+			len += ret;
+			if (buf)
+				buf += ret;
 			continue;
 		}
 		xbc_array_for_each_value(vnode, val) {
@@ -456,11 +459,13 @@ int __init xbc_snprint_cmdline(char *buf
 				       xbc_namebuf, q, val, q);
 			if (ret < 0)
 				return ret;
-			buf += ret;
+			len += ret;
+			if (buf)
+				buf += ret;
 		}
 	}
 
-	return buf - (end - size);
+	return len;
 }
 #undef rest
 
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch
signal-avoid-shared-siginfo-namespace-rewrites.patch
lib-bootconfig-fix-undefined-behavior-involving-null-pointer-arithmetic.patch

