Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590D927281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490021; cv=none; b=o9CHr58TUJhH9/f1FqtMWnhMNEUc5o2Ii5/w7yih4jyVEMPVKbXjTUULuAlTmXg6VZc+JiVTCJf6BRtq3k92Nj61Eo/bCLtQBEaG8/4lO2wMiQY6ELxqFzRlTSNHpiHRkftwyD+ub2M+TFGSdDOzBsBKqmqS1fe0yhyp0oGzBwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490021; c=relaxed/simple;
	bh=49mHLaFS0hNP2OL8Iv5bai7ECBE4ZB1rGlPwOP3GVDc=;
	h=Date:To:From:Subject:Message-Id; b=TvLZ3Rff3nM+pxvzv5nF4RvBFrhn9SDw+fwTfCPI8Uo6WfwGvvvhStFEMaWpfuLLuPJgtl8Wtt5YDF+F1A63zb0ogYfcJDacli0V6WV0rPIGteWJcONEOKO64bRCUK+M7VE7tWb8LISFHFTHZsKVWs1zgFN7NLytvCogTi7cfUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WfLBIXiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WfLBIXiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F16BC4CEE7;
	Sun, 21 Sep 2025 21:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490021;
	bh=49mHLaFS0hNP2OL8Iv5bai7ECBE4ZB1rGlPwOP3GVDc=;
	h=Date:To:From:Subject:From;
	b=WfLBIXivl6/fiUOn5GZMMZaUBiKvevSqLVkxHpO3UVZZ4kLBH1Aa5/xQYsmkkF9+6
	 P7BmdnX65HvSFnWiSy+1iikv8KpIY7cz75gVDUrOaq/KxKL4Vz1ySrFfJGghXMBHOv
	 2HgKXLwoaCkRBo/yDqbm23yd0frGTZ+RJS9/v7Rc=
Date: Sun, 21 Sep 2025 14:27:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-damon_initialized-function.patch removed from -mm tree
Message-Id: <20250921212701.2F16BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement damon_initialized() function
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-damon_initialized-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: implement damon_initialized() function
Date: Mon, 15 Sep 2025 20:35:05 -0700

Patch series "mm/damon: define and use DAMON initialization check
function".

DAMON is initialized in subsystem initialization time, by damon_init().
If DAMON API functions are called before the initialization, the
system could crash.  Actually such issues happened and were fixed [1]
in the past.  For the fix, DAMON API callers have updated to check if
DAMON is initialized or not, using their own hacks.  The hacks are
unnecessarily duplicated on every DAMON API callers and therefore it
would be difficult to reliably maintain in the long term.

Make it reliable and easy to maintain.  For this, implement a new DAMON
core layer API function that returns if DAMON is successfully
initialized.  If it returns true, it means DAMON API functions are safe
to be used.  After the introduction of the new API, update DAMON API
callers to use the new function instead of their own hacks.


This patch (of 7):

If DAMON is tried to be used when it is not yet successfully initialized,
the caller could be crashed.  DAMON core layer is not providing a reliable
way to see if it is successfully initialized and therefore ready to be
used, though.  As a result, DAMON API callers are implementing their own
hacks to see it.  The hacks simply assume DAMON should be ready on module
init time.  It is not reliable as DAMON initialization can indeed fail if
KMEM_CACHE() fails, and difficult to maintain as those are duplicates. 
Implement a core layer API function for better reliability and
maintainability to replace the hacks with followup commits.

Link: https://lkml.kernel.org/r/20250916033511.116366-2-sj@kernel.org
Link: https://lkml.kernel.org/r/20250916033511.116366-2-sj@kernel.org
Link: https://lore.kernel.org/20250909022238.2989-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |   10 ++++++++++
 2 files changed, 11 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-damon_initialized-function
+++ a/include/linux/damon.h
@@ -938,6 +938,7 @@ static inline unsigned int damon_max_nr_
 }
 
 
+bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
--- a/mm/damon/core.c~mm-damon-core-implement-damon_initialized-function
+++ a/mm/damon/core.c
@@ -2863,6 +2863,16 @@ void damon_update_region_access_rate(str
 		r->nr_accesses++;
 }
 
+/**
+ * damon_initialized() - Return if DAMON is ready to be used.
+ *
+ * Return: true if DAMON is ready to be used, false otherwise.
+ */
+bool damon_initialized(void)
+{
+	return damon_region_cache != NULL;
+}
+
 static int __init damon_init(void)
 {
 	damon_region_cache = KMEM_CACHE(damon_region, 0);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

