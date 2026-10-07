Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2A0327C18
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338654; cv=none; b=Y5yk3XeH6OORLH0jZETLxrtAw3eLtr/E9vOlPKkVEjtAlkjiQK/hc8xl36dWYfVbIqg3EkzyhsIrQt+ViBLs9Gofqgxf6mL2yNwmR8/qvLtsCH1Jscjrd+kR5qiX+BtCQPgSBkBpu/HnRUNNhciJU/0R/t6xSS37TzcdcALtRtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338654; c=relaxed/simple;
	bh=5qQfprSTWyvRkdXIGUgcI27ymhlVfx+FgmklZDQpSFc=;
	h=Date:To:From:Subject:Message-Id; b=Tkw2ik8IuhuOwlQhRBxWmHusuxbDdKJCsW0BROruRIYaiYsQPcLX3dhdeNmEnNsVqBnfi8VLrjHPLTM9JzS07G7Ftq8Dwnegw18vl8szxPMvW7VTdiEteD2frC8FoXnjhSDGWP4Fzbw+bbj79x/1rYH6WnQvAgezHSaJquUXyPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lowuwiZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lowuwiZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50BB1F0089B;
	Wed,  7 Oct 2026 02:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338653;
	bh=7EeIOzfRE1Pqs6BCrIWzB5vJg8xr2Z9LeM1qs+5gJQ0=;
	h=Date:To:From:Subject;
	b=lowuwiZt9gNWmu+dcdwpEPufhOjhnHq32QQqeMkEXjY7shzf9wsd+Rkkh20D1Kdc3
	 qh6CWja8SnVOdbv4CfiSIJBwYV74Mr/iwicnHzewaUzgyOANpeUPvbj3zmOIlHMaGX
	 fZFDzRq6WqnzUPCmwDB8/dm1dyAldtP3XR9xdupI=
Date: Tue, 06 Oct 2026 19:04:13 -0700
To: mm-commits@vger.kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-simplify-early_hostname.patch removed from -mm tree
Message-Id: <20261007020413.A50BB1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: simplify early_hostname()
has been removed from the -mm tree.  Its filename was
     init-simplify-early_hostname.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <blum@kernel.org>
Subject: init: simplify early_hostname()
Date: Fri, 28 Aug 2026 19:43:37 +0200

Inline the strscpy() check and remove the redundant arglen variable.  Use
%zu to format the unsigned maxlen argument and add a newline after the
truncation warning.

Link: https://lore.kernel.org/20260828174337.609333-2-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/version.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/init/version.c~init-simplify-early_hostname
+++ a/init/version.c
@@ -21,16 +21,14 @@ static int __init early_hostname(char *a
 {
 	size_t bufsize = sizeof(init_uts_ns.name.nodename);
 	size_t maxlen  = bufsize - 1;
-	ssize_t arglen;
 
 	if (!arg)
 		return -EINVAL;
 
-	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
-	if (arglen < 0) {
-		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
+	if (strscpy(init_uts_ns.name.nodename, arg, bufsize) < 0)
+		pr_warn("hostname parameter exceeds %zu characters and will be truncated\n",
 			maxlen);
-	}
+
 	return 0;
 }
 early_param("hostname", early_hostname);
_

Patches currently in -mm which might be from blum@kernel.org are


