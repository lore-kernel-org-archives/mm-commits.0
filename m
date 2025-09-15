Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0BA242D66
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 22:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974668; cv=none; b=P7AMXz49ZH2k5wrhDILfScssXXi5WmOkfg8jXY8WU9cxUevOHw1/xZrHF3zZrjvuN//gCEO6vH2xYKIWQwYFzC7EAlhYBXMFdlHZmKKNBdV9yVySoiqHMmYPFUDfXrleM0xgoyvEk1VcMigrrx3o3285PfHsft7DtvIlRGtxdK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974668; c=relaxed/simple;
	bh=gTF8jmPgEvwcpOh1kCd5prP2rOtPNJRTl80NfgVLcho=;
	h=Date:To:From:Subject:Message-Id; b=N/H42jhH+fJa+Y/Luw7VZrvw7KuNDLYtYAplkYp1HnpFdylK5yRgMF0dfTuZLemQc8fojgFsMu4w16lLWsex+akjLgIjbCzilP19/Pv9vlRVeHK/9hHiQWcPHOkyoV6gGj2yPua/Hv8hDapLKghhya0wZgNN/AZdfrSFLM1QXIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DDaaQUFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DDaaQUFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF527C4CEF5;
	Mon, 15 Sep 2025 22:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757974667;
	bh=gTF8jmPgEvwcpOh1kCd5prP2rOtPNJRTl80NfgVLcho=;
	h=Date:To:From:Subject:From;
	b=DDaaQUFVLgOBB13HOUprf1HAV3z/mormGWC6tMXy2d93c4NSik4jS3UXwN3jdrza7
	 SzEociZqv1V/4XPtIDet3+tFD7H3iPoM7mgyd3dMFpflcNfm3/QPhXE/3YD4sZ/12+
	 qw/fuUKDs628pZr42RvLzbCJC8oCfUwIfGUPEQ94=
Date: Mon, 15 Sep 2025 15:17:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,souravpanda@google.com,shakeel.butt@linux.dev,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch added to mm-unstable branch
Message-Id: <20250915221747.BF527C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: prevent enabling memory profiling if it was shut down
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: prevent enabling memory profiling if it was shut down
Date: Mon, 15 Sep 2025 14:27:55 -0700

Memory profiling can be shut down due to reasons like a failure during
initialization.  When this happens, the user should not be able to
re-enable it.  Current sysctrl interface does not handle this properly and
will allow re-enabling memory profiling.  Fix this by checking for this
condition during sysctrl write operation.

Link: https://lkml.kernel.org/r/20250915212756.3998938-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down
+++ a/lib/alloc_tag.c
@@ -766,6 +766,20 @@ struct page_ext_operations page_alloc_ta
 EXPORT_SYMBOL(page_alloc_tagging_ops);
 
 #ifdef CONFIG_SYSCTL
+/*
+ * Not using proc_do_static_key() directly to prevent enabling profiling
+ * after it was shut down.
+ */
+static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
+				      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (!mem_profiling_support && write)
+		return -EINVAL;
+
+	return proc_do_static_key(table, write, buffer, lenp, ppos);
+}
+
+
 static struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
@@ -775,7 +789,7 @@ static struct ctl_table memory_allocatio
 #else
 		.mode		= 0644,
 #endif
-		.proc_handler	= proc_do_static_key,
+		.proc_handler	= proc_mem_profiling_handler,
 	},
 };
 
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-use-release_pages-in-the-cleanup-path.patch
alloc_tag-prevent-enabling-memory-profiling-if-it-was-shut-down.patch
alloc_tag-avoid-warnings-when-freeing-non-compound-tail-pages.patch

