Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094842417D7
	for <mm-commits@vger.kernel.org>; Tue, 15 Apr 2025 19:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744744781; cv=none; b=Z/9z5O1ZwSU7j0EJwVHTY7DeJo0vm8xVH+WjRagoorEM0xV2xeVVHsvj78T7uoRpFi+y9PS4LSXDJhIsDA9sFkOlf4I7fFE0eZYMv2SL7EImFhWXBFzpYnl4KfOKlfzHMRzJB80PTPy/a6Hc4q1bnuOGYm9m6dnh7XcLgM6nTkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744744781; c=relaxed/simple;
	bh=8YbJVrbVvVdoGEWdV0gPk9KaSu5pq4258gqJGBgF5Fw=;
	h=Date:To:From:Subject:Message-Id; b=L3eDoGrM/jnXRXygEe8Sm/A1lTJ8oJ0BOVdLOYMToKPAyRC8SdMBgMm3p+QX9zVvx9p01xHQ1Xi3SCtONJd/cfXibnPhcFVdoTGjdEyGJ/rca0txrYac4NEV71PpNYGKv9Ic+MzLLC7qdaFS4AYndGLj4kltzFp02WaDwCGA/CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GRpcs4Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GRpcs4Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37070C4CEE7;
	Tue, 15 Apr 2025 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744744780;
	bh=8YbJVrbVvVdoGEWdV0gPk9KaSu5pq4258gqJGBgF5Fw=;
	h=Date:To:From:Subject:From;
	b=GRpcs4GhWzj/Ntatc69OUuBt7H4iSk7asP6VIv4J7as9e9Ge2iYyiEbgbGVr7dfKt
	 fuxKkZwBw4jVDTvuhAjWwHeBpkCSI4rt4aoFLUXesoWg7X1huPJzniSKYH/gQOK9kQ
	 pvKUG0D+rbyj3Y+S5WQ1F62HUBDeHawp8ecKX7n8=
Date: Tue, 15 Apr 2025 12:19:39 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,samitolvanen@google.com,pmenzel@molgen.mpg.de,mingo@kernel.org,masahiroy@kernel.org,bp@alien8.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] compilerh-avoid-the-usage-of-__typeof_unqual__-when-__genksyms__-is-defined.patch removed from -mm tree
Message-Id: <20250415191940.37070C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler.h: avoid the usage of __typeof_unqual__() when __GENKSYMS__ is defined
has been removed from the -mm tree.  Its filename was
     compilerh-avoid-the-usage-of-__typeof_unqual__-when-__genksyms__-is-defined.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: compiler.h: avoid the usage of __typeof_unqual__() when __GENKSYMS__ is defined
Date: Fri, 4 Apr 2025 12:24:37 +0200

Current version of genksyms doesn't know anything about
__typeof_unqual__() operator.  Avoid the usage of __typeof_unqual__() with
genksyms to prevent errors when symbols are versioned.

There were no problems with gendwarfksyms.

Link: https://lkml.kernel.org/r/20250404102535.705090-1-ubizjak@gmail.com
Fixes: ac053946f5c40 ("compiler.h: introduce TYPEOF_UNQUAL() macro")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/lkml/81a25a60-de78-43fb-b56a-131151e1c035@molgen.mpg.de/
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/compiler.h~compilerh-avoid-the-usage-of-__typeof_unqual__-when-__genksyms__-is-defined
+++ a/include/linux/compiler.h
@@ -229,10 +229,10 @@ void ftrace_likely_update(struct ftrace_
 /*
  * Use __typeof_unqual__() when available.
  *
- * XXX: Remove test for __CHECKER__ once
- * sparse learns about __typeof_unqual__().
+ * XXX: Remove test for __GENKSYMS__ once "genksyms" handles
+ * __typeof_unqual__(), and test for __CHECKER__ once "sparse" handles it.
  */
-#if CC_HAS_TYPEOF_UNQUAL && !defined(__CHECKER__)
+#if CC_HAS_TYPEOF_UNQUAL && !defined(__GENKSYMS__) && !defined(__CHECKER__)
 # define USE_TYPEOF_UNQUAL 1
 #endif
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are


