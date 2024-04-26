Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE2278C90
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103875; cv=none; b=sfYnlKDB58xej1SJrycnBxB3rqj90V5++1ULwaRiYZifnvcFaKuOkOKlcRFl0Mjtuce74kPmXp79Frh1gDv4VOXeXEHpdmQMD8aM+/GhgzQoGL1t8+f+KsHpNAdGHkh3UoDQKzBD5kYRxuaC0IrokM8I//kyLwe/JcgHWUfD4fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103875; c=relaxed/simple;
	bh=uYSDo0DkSfRO4qWQaPw6O9D62xndjwzudYb1fHQ3vsc=;
	h=Date:To:From:Subject:Message-Id; b=NumgPfCfmhH4hNOcH41PKuTvU2I88zpECk2HU4S+n6ZH02jOdLm/Q8mHmBsoS16V2BQ/AOqTRvE2pb6nXZtxEvbV/86pN4pqRql5oAuVPjBDE8QgA/gPMkt8pTKTIIR91gOcyy0Jx0TKMmJnoY5JvIjKmQ9glLkUTZV2tYz6m+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RtsLqp0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RtsLqp0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854E4C116B1;
	Fri, 26 Apr 2024 03:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103875;
	bh=uYSDo0DkSfRO4qWQaPw6O9D62xndjwzudYb1fHQ3vsc=;
	h=Date:To:From:Subject:From;
	b=RtsLqp0FQSsAobek7YNVFirm1jKkADv8/sEEJ7j79VRPHrg2nHQfCiR3bBkRV2f77
	 nNoO2QAju+NSzUyZZz7XKoOhYf5pyS+2BbUQqxslR7WuH6dGGJUioQlqcJcLD56f0v
	 hwds/1m9rnEaERUvTEM0a+ypxf77ljqRGCswnJGU=
Date: Thu, 25 Apr 2024 20:57:55 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sfr@canb.auug.org.au,kent.overstreet@linux.dev,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scripts-kernel-doc-drop-_noprof-on-function-prototypes.patch removed from -mm tree
Message-Id: <20240426035755.854E4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/kernel-doc: drop "_noprof" on function prototypes
has been removed from the -mm tree.  Its filename was
     scripts-kernel-doc-drop-_noprof-on-function-prototypes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: scripts/kernel-doc: drop "_noprof" on function prototypes
Date: Mon, 25 Mar 2024 22:41:49 -0700

Memory profiling introduces macros as hooks for function-level allocation
profiling[1].  Memory allocation functions that are profiled are named
like xyz_alloc() for API access to the function.  xyz_alloc() then calls
xyz_alloc_noprof() to do the allocation work.

The kernel-doc comments for the memory allocation functions are introduced
with the xyz_alloc() function names but the function implementations are
the xyz_alloc_noprof() names.  This causes kernel-doc warnings for
mismatched documentation and function prototype names.  By dropping the
"_noprof" part of the function name, the kernel-doc function name matches
the function prototype name, so the warnings are resolved.

[1] https://lore.kernel.org/all/20240321163705.3067592-1-surenb@google.com/

Link: https://lkml.kernel.org/r/20240326054149.2121-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20240325123603.1bdd6588@canb.auug.org.au/
Tested-by: Suren Baghdasaryan <surenb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/kernel-doc~scripts-kernel-doc-drop-_noprof-on-function-prototypes
+++ a/scripts/kernel-doc
@@ -1723,6 +1723,7 @@ sub dump_function($$) {
     $prototype =~ s/__must_check +//;
     $prototype =~ s/__weak +//;
     $prototype =~ s/__sched +//;
+    $prototype =~ s/_noprof//;
     $prototype =~ s/__printf\s*\(\s*\d*\s*,\s*\d*\s*\) +//;
     $prototype =~ s/__(?:re)?alloc_size\s*\(\s*\d+\s*(?:,\s*\d+\s*)?\) +//;
     $prototype =~ s/__diagnose_as\s*\(\s*\S+\s*(?:,\s*\d+\s*)*\) +//;
_

Patches currently in -mm which might be from rdunlap@infradead.org are


