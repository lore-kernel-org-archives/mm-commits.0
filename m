Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C625946A
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 01:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756172403; cv=none; b=oOj0i/5iZdX371VwX82XStaHoDHwYbD3CL4SlNn5/7bMLW3eiBMfmb7+mRXKTS4A6AMeH+jEPJpqOsuGzzxly821bCZWOGmGRz+dbXZaa/TkdOKqH+7shOZSCJp6hj/kgkqRtMK+XRdGLeuC+j2hjc6mN0qcFxQGSmyxv9AzuV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756172403; c=relaxed/simple;
	bh=O8TlGlhZbDXWOfX9uQJDNAxv42kgmcMSO1bIaXe3gaY=;
	h=Date:To:From:Subject:Message-Id; b=X+QN1+I23AZqjgC/8AaJ1SqxgM/GOjY+dme1SJwNT3LSBkW8n330vuVQrGMv4h1cKANxn953Ct7J//2uMbmumEXwzeXfkYYLpzlqEtsxitP7pMXzJ54MjpCk2jh640H2VwYsCBpGb5XBE/hMQVf1tIu6T9s6dO+HfGtw2IRSV/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C7/AbScc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C7/AbScc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1007C4CEED;
	Tue, 26 Aug 2025 01:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756172402;
	bh=O8TlGlhZbDXWOfX9uQJDNAxv42kgmcMSO1bIaXe3gaY=;
	h=Date:To:From:Subject:From;
	b=C7/AbSccQfaxGiVWRgJ00zUoIkVR8nP/lG6qW/nRXgPzmOpw+eJkAcbYPW5xhvpPX
	 ZQGFYkNVLsABoiif5XIWHmB2/8ooEWMrmQtpJ5uMUPIQF+CiKx4M1GLlmqbm8t2PNX
	 NLvRIhisuk7a2ExMbKqKaFW3U7+KfCNQg3Daq2FM=
Date: Mon, 25 Aug 2025 18:40:02 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,bhe@redhat.com,vdumitrescu@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-fix-race-on-alloc-failed-warning-limit.patch added to mm-hotfixes-unstable branch
Message-Id: <20250826014002.D1007C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: fix race on alloc failed warning limit
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     percpu-fix-race-on-alloc-failed-warning-limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-fix-race-on-alloc-failed-warning-limit.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Subject: percpu: fix race on alloc failed warning limit
Date: Fri, 22 Aug 2025 15:55:16 -0700

The 'allocation failed, ...' warning messages can cause unlimited log
spam, contrary to the implementation's intent.

The warn_limit variable is accessed without synchronization.  If more than
<warn_limit> threads enter the warning path at the same time, the variable
will get decremented past 0.  Once it becomes negative, the non-zero check
will always return true leading to unlimited log spam.

Use atomic operations to access warn_limit and change the check to test
for positive (> 0) as it can still become negative.

While the change cited in Fixes is only adjacent, the warning limit
implementation was correct before it.  Only non-atomic allocations were
considered for warnings, and those happened to hold pcpu_alloc_mutex while
accessing warn_limit.

Link: https://lkml.kernel.org/r/ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com
Fixes: f7d77dfc91f7 ("mm/percpu.c: print error message too if atomic alloc failed")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/percpu.c~percpu-fix-race-on-alloc-failed-warning-limit
+++ a/mm/percpu.c
@@ -1734,7 +1734,7 @@ void __percpu *pcpu_alloc_noprof(size_t
 	bool is_atomic;
 	bool do_warn;
 	struct obj_cgroup *objcg = NULL;
-	static int warn_limit = 10;
+	static atomic_t warn_limit = ATOMIC_INIT(10);
 	struct pcpu_chunk *chunk, *next;
 	const char *err;
 	int slot, off, cpu, ret;
@@ -1904,13 +1904,17 @@ fail_unlock:
 fail:
 	trace_percpu_alloc_percpu_fail(reserved, is_atomic, size, align);
 
-	if (do_warn && warn_limit) {
-		pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
-			size, align, is_atomic, err);
-		if (!is_atomic)
-			dump_stack();
-		if (!--warn_limit)
-			pr_info("limit reached, disable warning\n");
+	if (do_warn && atomic_read(&warn_limit) > 0) {
+		int remaining = atomic_dec_return(&warn_limit);
+
+		if (remaining >= 0) {
+			pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
+				size, align, is_atomic, err);
+			if (!is_atomic)
+				dump_stack();
+			if (remaining == 0)
+				pr_info("limit reached, disable warning\n");
+		}
 	}
 
 	if (is_atomic) {
_

Patches currently in -mm which might be from vdumitrescu@nvidia.com are

percpu-fix-race-on-alloc-failed-warning-limit.patch

