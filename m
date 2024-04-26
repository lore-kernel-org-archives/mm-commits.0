Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F3B811F7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104456; cv=none; b=W3jUwf6OxCSsSAmMgeXDF5EKUj55g0CJQ/6aRjOI3rfzFcM/lsTdi0S1Re2HGIJzcJQqN6jw1eKLf3PlwyQKrNLddtpJWL0hhBYGEPCEvpn1u4d/K9RkNU7oTQ8ZKyg6SrQoDTh7CZedu/XQiN6NAqReBXqg1CbrnxhrgaYIO1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104456; c=relaxed/simple;
	bh=n/3LSRh+afFpExcMNR29GFHoTp18ZtMnsg2+UUNVH1o=;
	h=Date:To:From:Subject:Message-Id; b=MuUmRExfRn5hIS1EyuOG9PO+U0UjLV9aiVIFm3xm0vdIr3N1IeDROjNKuQFHRwrcbY44cN/bNwyNxjCArTxRAHVbRHnMPUeQBb0H26L+ccs8cV6HCmUTQ0pV0fjJkQsS3I73/vOG56sQkmQ4P6eGtmvTQ+gTEktOqywfnBPvFKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s5fYZ72u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s5fYZ72u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C940C32782;
	Fri, 26 Apr 2024 04:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104455;
	bh=n/3LSRh+afFpExcMNR29GFHoTp18ZtMnsg2+UUNVH1o=;
	h=Date:To:From:Subject:From;
	b=s5fYZ72uLU2a4oVNRPQWyAy1QQ9RRgz2FlI81T3GB0lnWff1WYLwVr2Mz3EQ+yW5L
	 fL0B3sGXqVlGZkbUcetiMfo4fVQa/QIMvibwE6qnTFVBOo5lV8BhuduyTz+gb/0YcP
	 StXqrMvCj1Ei76ir8Oxjx0ImnJnLYBX/JXrPurWw=
Date: Thu, 25 Apr 2024 21:07:35 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,linux@rasmusvillemoes.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch removed from -mm tree
Message-Id: <20240426040735.8C940C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: do not put quotes on cmdline items unless necessary
has been removed from the -mm tree.  Its filename was
     bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: bootconfig: do not put quotes on cmdline items unless necessary
Date: Wed, 20 Mar 2024 11:19:52 +0100

When trying to migrate to using bootconfig to embed the kernel's and
PID1's command line with the kernel image itself, and so allowing changing
that without modifying the bootloader, I noticed that /proc/cmdline
changed from e.g.

  console=ttymxc0,115200n8 cma=128M quiet -- --log-level=notice

to

  console="ttymxc0,115200n8" cma="128M" quiet -- --log-level="notice"

The kernel parameters are parsed just fine, and the quotes are indeed
stripped from the actual argv[] given to PID1.  However, the quoting
doesn't really serve any purpose and looks excessive, and might confuse
some (naive) userspace tool trying to parse /proc/cmdline.  So do not
quote the value unless it contains whitespace.

Link: https://lkml.kernel.org/r/20240320101952.62135-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/init/main.c~bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary
+++ a/init/main.c
@@ -327,7 +327,7 @@ static int __init xbc_snprint_cmdline(ch
 {
 	struct xbc_node *knode, *vnode;
 	char *end = buf + size;
-	const char *val;
+	const char *val, *q;
 	int ret;
 
 	xbc_node_for_each_key_value(root, knode, val) {
@@ -345,8 +345,14 @@ static int __init xbc_snprint_cmdline(ch
 			continue;
 		}
 		xbc_array_for_each_value(vnode, val) {
-			ret = snprintf(buf, rest(buf, end), "%s=\"%s\" ",
-				       xbc_namebuf, val);
+			/*
+			 * For prettier and more readable /proc/cmdline, only
+			 * quote the value when necessary, i.e. when it contains
+			 * whitespace.
+			 */
+			q = strpbrk(val, " \t\r\n") ? "\"" : "";
+			ret = snprintf(buf, rest(buf, end), "%s=%s%s%s ",
+				       xbc_namebuf, q, val, q);
 			if (ret < 0)
 				return ret;
 			buf += ret;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


