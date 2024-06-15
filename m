Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4370E1EB3D
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473432; cv=none; b=o1WaX0h8Y41cTGF2YgN5JUGIWXaYsspsU5K/DOtzq26jf11hTPZxKT2i35A2Q+/+lIruKZcxLnWhoFz1TpIzLXQ6aGp1D/d3kz0aeRuVyyBHy99d2HRPJk4JXftw9+amv+Zh7hoiW1q+qxpMAqKfIgnDB9zNBqD0XoNFvOfBpuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473432; c=relaxed/simple;
	bh=nJssK3KbT7Ufec0eIGKVr7A99XZfSCBFV+ENGEH5phA=;
	h=Date:To:From:Subject:Message-Id; b=KDvkjX1MZ46ywTlGSsFxoUFBb/WWbTiDEHR47awjS0ReogL1IrufwwVbaN/2tN5LUPIQ7c7afKZOKACHQcTsPre1cN4fHyL+LOMvjaOKgVhgpU5uo8rBt9jHgN6f5vQOqEHLHyWzRtBxgGEZc7M/533lBsxfPVwbyp96daaZ5rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XlNnDD4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XlNnDD4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC5CC116B1;
	Sat, 15 Jun 2024 17:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473431;
	bh=nJssK3KbT7Ufec0eIGKVr7A99XZfSCBFV+ENGEH5phA=;
	h=Date:To:From:Subject:From;
	b=XlNnDD4ifOIXapRFfTTqbdRgCbxIoWp3guM0eKz0A4Jst2BzzN9UsgqWU+Ia7CPDR
	 f/Qltg5BWoxxVZO/rnLGjoMYY4YH+Sdqp+P/CTQ0AQ2LIAtk8AhdwjL3f4XUAdA99e
	 UTZAIQfqLjInYAwg0jyo/7TtMnDC7XEgZdclxjC4=
Date: Sat, 15 Jun 2024 10:43:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pasha.tatashin@soleen.com,lkp@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n.patch removed from -mm tree
Message-Id: <20240615174351.BAC5CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/alloc_tag: do not register sysctl interface when CONFIG_SYSCTL=n
has been removed from the -mm tree.  Its filename was
     lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib/alloc_tag: do not register sysctl interface when CONFIG_SYSCTL=n
Date: Sat, 1 Jun 2024 16:38:31 -0700

Memory allocation profiling is trying to register sysctl interface even
when CONFIG_SYSCTL=n, resulting in proc_do_static_key() being undefined. 
Prevent that by skipping sysctl registration for such configurations.

Link: https://lkml.kernel.org/r/20240601233831.617124-1-surenb@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405280616.wcOGWJEj-lkp@intel.com/
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/lib/alloc_tag.c~lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n
+++ a/lib/alloc_tag.c
@@ -227,6 +227,7 @@ struct page_ext_operations page_alloc_ta
 };
 EXPORT_SYMBOL(page_alloc_tagging_ops);
 
+#ifdef CONFIG_SYSCTL
 static struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
@@ -241,6 +242,17 @@ static struct ctl_table memory_allocatio
 	{ }
 };
 
+static void __init sysctl_init(void)
+{
+	if (!mem_profiling_support)
+		memory_allocation_profiling_sysctls[0].mode = 0444;
+
+	register_sysctl_init("vm", memory_allocation_profiling_sysctls);
+}
+#else /* CONFIG_SYSCTL */
+static inline void sysctl_init(void) {}
+#endif /* CONFIG_SYSCTL */
+
 static int __init alloc_tag_init(void)
 {
 	const struct codetag_type_desc desc = {
@@ -253,9 +265,7 @@ static int __init alloc_tag_init(void)
 	if (IS_ERR(alloc_tag_cttype))
 		return PTR_ERR(alloc_tag_cttype);
 
-	if (!mem_profiling_support)
-		memory_allocation_profiling_sysctls[0].mode = 0444;
-	register_sysctl_init("vm", memory_allocation_profiling_sysctls);
+	sysctl_init();
 	procfs_init();
 
 	return 0;
_

Patches currently in -mm which might be from surenb@google.com are

mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch
mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch

