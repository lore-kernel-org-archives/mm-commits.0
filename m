Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A854382
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 00:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711067218; cv=none; b=pTzQJFwueNZ+n2sd7sxK7AMaJmYmbz+PF4tmnY+lPgCHhGjM88m67iPjHXS9DMqaDwi5RqXD18cWr/LO5Ykr5rTe0O2cn3ASLOQ1tnjSou5TeXkKNEdeWRcjoefz6RFkMja5QCsvq1QwVlyL7LsC99xJLejiCg90q8gSyQd8Z9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711067218; c=relaxed/simple;
	bh=09aOEs+rSxHbLMEyDNcJ4dcnodmuf/5npTbhm1G3mlo=;
	h=Date:To:From:Subject:Message-Id; b=Mn4Msbu+BQ+LSBMXUVT2qEtQE+dggqAkdFM6DSniMLDbiV0hWoqP2GcHo6G9QZbNMcKnVEDZdyUKtx8DgZAfSf32dxF8GbJEgLDxIm1ZqT8ayIMMVvjMhS7tjnoXAf8xN7JCOlANE+PQwRcSr8mfUA9mrFIo1WkXshpyVsNo//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AtMSmMCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AtMSmMCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73F4C433C7;
	Fri, 22 Mar 2024 00:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711067217;
	bh=09aOEs+rSxHbLMEyDNcJ4dcnodmuf/5npTbhm1G3mlo=;
	h=Date:To:From:Subject:From;
	b=AtMSmMCni7rzGlFFuTrBIeoUz2IYJbvYVLVX3WlNVGmBWrpBuhYsTq0ftTMZAbnrv
	 a/wLqovNZZjWWKTTYlNvpdXkxSsC4U5IsTqAwVWiIVAHIIEO9Jiyinf46786ANtY5h
	 iHeTGn6E6Apz2aUXkZCXUWAH+qM4OBKWmxpRFdUY=
Date: Thu, 21 Mar 2024 17:26:57 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,linux@rasmusvillemoes.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch added to mm-nonmm-unstable branch
Message-Id: <20240322002657.D73F4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootconfig: do not put quotes on cmdline items unless necessary
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch

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

bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch

