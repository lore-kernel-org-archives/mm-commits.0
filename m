Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFE713D25D
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482877; cv=none; b=btZqkrpaIx8KfdqPrdc96rEfKWWazVjDQnsh/z4GZeOtN+XDAPdk9qyf6IyXsZREFqvLZLNCEtXCkvnO81kZ77ZCHrxtDV2wLUvQ/KKHUD3/1lw+2aJdUXAiyJe7Babbe3G1l1cFfm1u63sWVAvAnGN7tpO9N0LQFN9Tsv0a/FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482877; c=relaxed/simple;
	bh=USiBfoT37SfzK/DT/l9E7Zty8Q/JWLlaYbZJ7R9D5L0=;
	h=Date:To:From:Subject:Message-Id; b=mejcBoYrLfDGnrggs6GH3qeG20hUeLzp1dfMxTWT72V3934XjhrNubP1vphU2Qp4TUkbaAUeqU3sqockuOqbwHwSrSgXVv5hCh4R9dOuvbMao9Nr8SD+pEpYVzZxbTn5ZtDqo6Y0yTL49k9sLq32JB4zcVXHEpLJKb+OhYxKAeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e5xLu/lA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e5xLu/lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E54C433F1;
	Tue, 26 Mar 2024 19:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711482877;
	bh=USiBfoT37SfzK/DT/l9E7Zty8Q/JWLlaYbZJ7R9D5L0=;
	h=Date:To:From:Subject:From;
	b=e5xLu/lAlnDqWqAJ8vMbOUUdfa7OkDJYsq2zXfCTEhOKOyzSZaX7spjFrsQROP9eH
	 ZHFzrorzUcp795FYm7hWJEVBZuGIixmLoydIuu5yhw7tGNAEHymZO4Zr0v8kwmS6s7
	 knyOkX4RlOjHKiHZZSPPKgIlNOsQTaOn1/vgwxoQ=
Date: Tue, 26 Mar 2024 12:54:37 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sfr@canb.auug.org.au,kent.overstreet@linux.dev,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-kernel-doc-drop-_noprof-on-function-prototypes.patch added to mm-unstable branch
Message-Id: <20240326195437.84E54C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/kernel-doc: drop "_noprof" on function prototypes
has been added to the -mm mm-unstable branch.  Its filename is
     scripts-kernel-doc-drop-_noprof-on-function-prototypes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-kernel-doc-drop-_noprof-on-function-prototypes.patch

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
Fixes: c64e38ed88d1 ("mm/slab: enable slab allocation tagging for kmalloc and friends")
Fixes: ea7b8933f21b ("mempool: hook up to memory allocation profiling")
Fixes: 576477564ede ("mm: vmalloc: enable memory allocation profiling")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20240325123603.1bdd6588@canb.auug.org.au/
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
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

scripts-kernel-doc-drop-_noprof-on-function-prototypes.patch

