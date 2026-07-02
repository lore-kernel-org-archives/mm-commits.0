Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB725344D9D;
	Thu,  2 Jul 2026 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783013330; cv=none; b=hUcMlQscTTWSuEVxstEZCjUT6ruwueP4h40tg6e4+/dJyWTBZw7E1tsP8viEqQDAVq+bErXELMEO5nBMRQob9NBb7nwM771K4vtLafNTsbLPuRJBlc+ZfA5yELG+1GUB7YbXPNFT/n3JfocO2uGiJFg5Nduqpb/N8IbeqMUaWYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783013330; c=relaxed/simple;
	bh=B0uxHwpIxrFiI/RZmPGq7grcs09n9q6dO4zjjMU5Hz4=;
	h=Date:To:From:Subject:Message-Id; b=uplJswWI8QIX3Bc+cPjOXcYDo0ULyybh6FuS/QG+nuPgZOalSRvmJ4WQVTolaY/jO4s3X1FxvWNy+9P39fUI6Wj6J7b/K9RUC7tFbfYOH2ojuJ0TWpgMYx+RaEujn+3ubX572pg+4YM2M1riLrA3eAZpMAWGYuMNT3m9kbMF9ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sKmTeny8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sKmTeny8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E26F1F000E9;
	Thu,  2 Jul 2026 17:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783013328;
	bh=eV+dCEWl4LqK4dvP3NfiJG3u+uuVA3Q2YVjzCs2Gdpo=;
	h=Date:To:From:Subject;
	b=sKmTeny8ixOZpNgMkTDB66xhxpxOjVGzF9wLE5AvQeoXvobENZObRg95DEmLyZjkW
	 HkbXNzLArjCruH18eMVH79E1+EBA8IH9+CXUFWKVktm23nJZp0lJxiyObWCDfDbHk7
	 O5PdhNB4a5tV09lWTFVfTWJo8H2LIAw3UhW7xB0A=
Date: Thu, 02 Jul 2026 10:28:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,leitao@debian.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] lib-bootconfig-fix-undefined-behavior-involving-null-pointer-arithmetic.patch removed from -mm tree
Message-Id: <20260702172848.6E26F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bootconfig: fix undefined behavior involving NULL pointer arithmetic
has been removed from the -mm tree.  Its filename was
     lib-bootconfig-fix-undefined-behavior-involving-null-pointer-arithmetic.patch

This patch was dropped because an alternative patch was or shall be merged

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
Cc: Breno Leitao <leitao@debian.org>
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

