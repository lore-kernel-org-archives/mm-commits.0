Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEE13C38
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 00:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758070607; cv=none; b=UlIm/q7SJKLARux8zmpGiMzioYdZYniLHAxvS/vgX1n9VyBD8WYgCjH9eV6f8BbhD561bBigscq5WcGm7y9IcbTZNIEgMQJA5E6ChzfwnOSctYhZfnaayZiLw36CvkSaP8Z9egYbCd+o4092F1joqGC93SlN07kH+823dfJSSoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758070607; c=relaxed/simple;
	bh=i45X4ByumuTzmwB/H44+RyUZNiYKrTwOCmen/zM/qhA=;
	h=Date:To:From:Subject:Message-Id; b=aglaADMjMU+0w8bQXhfdUo/AHVcDj4dQee9ItrdUaVD1j3PaOPVWrluXNYZ/8qhHWCnaBi82GWyY0fD9+LSvzqeVmtQuvpSh+x33Zs8tbM4I0m5cm96SRJZrbHQnrwAxdTjDdVtfGlFxalZjLrVY84YNPZIzK2yNLBnezXIz1/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y3hwD0q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y3hwD0q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEEEC4CEEB;
	Wed, 17 Sep 2025 00:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758070607;
	bh=i45X4ByumuTzmwB/H44+RyUZNiYKrTwOCmen/zM/qhA=;
	h=Date:To:From:Subject:From;
	b=Y3hwD0q9l5mC9NZHg+DtMwPF9OYxZVWft28It5ZQskVDCCoys7ZwCZyVAGuAtrv1n
	 IZquJfM4UcYKSvHce4qj4q807JnuVQBv90oPiziBTX0i0Tkb1vNO2lKBcMVF7MQ3iP
	 btsk4GvCXTGkFcK7XUAVsjJ6cm2CDLc2lfLJ+UOo=
Date: Tue, 16 Sep 2025 17:56:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix.patch added to mm-new branch
Message-Id: <20250917005647.3BEEEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix
Date: Tue, 16 Sep 2025 09:01:10 -0700

Document new "accurate:no" marker.

Link: https://lkml.kernel.org/r/20250916160110.266190-1-surenb@google.com
Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1014,6 +1014,14 @@ If file version is 2.0 or higher then ea
 For example if the counters are not accurate, the line will be appended with
 "accurate:no" pair.
 
+Supported markers in v2:
+accurate:no
+              Absolute values of the counters in this line are not
+              accurate because of the failure to allocate storage required
+              to track some of the allocations made at this location.
+              Deltas in these counters are accurate, therefore counters
+              can be used to track allocation size and count changes.
+
 Example output.
 
 ::
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-use-release_pages-in-the-cleanup-path.patch
alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch
alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix.patch

