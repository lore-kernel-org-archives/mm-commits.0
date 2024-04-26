Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BA578C8A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103896; cv=none; b=Dg5fFIfsLTcLylF032K8I6oVa4MnG1r+BLQd6VFq+zpX759mWMsHO9nXsSBpQImi/y08Xaib/FotSUnSUKHQJRDiZdSJh++tOf266pYBCEvG9LELcfYsXUWbr+3GTVkAgEAaADXUHx3pxuENwX335dxotrgr2JNy1/qFFuCAbdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103896; c=relaxed/simple;
	bh=smwfoWIqqRVb2NYPe+cx3T6Qdo5FjttFxFijpU2ROE4=;
	h=Date:To:From:Subject:Message-Id; b=kM0q1aoUMBvQBvWm0RcnV232AQdqGV8EFUgIznvWwYphEETYLfDr1C+xZILSIWv8ArTHmh62KPOY9YC2fdJvoPsP5RTvAIANz2w2PSG9BIvjV0FGTwCEvn63+4UeAAqbKzoXdhcKhScuaVBGB+HqeGmlIq+c6akPlP4xhG4s4lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F/Ro/e2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F/Ro/e2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439D0C113CD;
	Fri, 26 Apr 2024 03:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103896;
	bh=smwfoWIqqRVb2NYPe+cx3T6Qdo5FjttFxFijpU2ROE4=;
	h=Date:To:From:Subject:From;
	b=F/Ro/e2snici11tqbjJO5ZKK7LmmsbBNE38Qzw3+14FkqKnJCHVLjb5ik2YHMzJKD
	 9Hgl+4CxusCjnCHbPp4aMyMSDWWCfBhGL6lTKyGslDe8k3ZvgZ3a6S4jU5OCN+NitB
	 8zEiLCzc8q24cgtPSBqX1fHijBDfg96Dg2jxwDNI=
Date: Thu, 25 Apr 2024 20:58:15 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch removed from -mm tree
Message-Id: <20240426035816.439D0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: introduce early boot parameter to avoid page_ext memory overhead
has been removed from the -mm tree.  Its filename was
     lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib: introduce early boot parameter to avoid page_ext memory overhead
Date: Thu, 21 Mar 2024 09:36:37 -0700

The highest memory overhead from memory allocation profiling comes from
page_ext objects.  This overhead exists even if the feature is disabled
but compiled-in.  To avoid it, introduce an early boot parameter that
prevents page_ext object creation.  The new boot parameter is a tri-state
with possible values of 0|1|never.  When it is set to "never" the memory
allocation profiling support is disabled, and overhead is minimized
(currently no page_ext objects are allocated, in the future more overhead
might be eliminated).  As a result we also lose ability to enable memory
allocation profiling at runtime (because there is no space to store
alloctag references).  Runtime sysctrl becomes read-only if the early boot
parameter was set to "never".  Note that the default value of this boot
parameter depends on the CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
configuration.  When CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=n the
boot parameter is set to "never", therefore eliminating any overhead. 
CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y results in boot parameter
being set to 1 (enabled).  This allows distributions to avoid any overhead
by setting CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=n config and with
no changes to the kernel command line.

We reuse sysctl.vm.mem_profiling boot parameter name in order to avoid
introducing yet another control.  This change turns it into a tri-state
early boot parameter.

Link: https://lkml.kernel.org/r/20240321163705.3067592-16-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead
+++ a/lib/alloc_tag.c
@@ -119,9 +119,46 @@ static bool alloc_tag_module_unload(stru
 	return module_unused;
 }
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
+static bool mem_profiling_support __meminitdata = true;
+#else
+static bool mem_profiling_support __meminitdata;
+#endif
+
+static int __init setup_early_mem_profiling(char *str)
+{
+	bool enable;
+
+	if (!str || !str[0])
+		return -EINVAL;
+
+	if (!strncmp(str, "never", 5)) {
+		enable = false;
+		mem_profiling_support = false;
+	} else {
+		int res;
+
+		res = kstrtobool(str, &enable);
+		if (res)
+			return res;
+
+		mem_profiling_support = true;
+	}
+
+	if (enable != static_key_enabled(&mem_alloc_profiling_key)) {
+		if (enable)
+			static_branch_enable(&mem_alloc_profiling_key);
+		else
+			static_branch_disable(&mem_alloc_profiling_key);
+	}
+
+	return 0;
+}
+early_param("sysctl.vm.mem_profiling", setup_early_mem_profiling);
+
 static __init bool need_page_alloc_tagging(void)
 {
-	return true;
+	return mem_profiling_support;
 }
 
 static __init void init_page_alloc_tagging(void)
@@ -161,6 +198,8 @@ static int __init alloc_tag_init(void)
 	if (IS_ERR(alloc_tag_cttype))
 		return PTR_ERR(alloc_tag_cttype);
 
+	if (!mem_profiling_support)
+		memory_allocation_profiling_sysctls[0].mode = 0444;
 	register_sysctl_init("vm", memory_allocation_profiling_sysctls);
 	procfs_init();
 
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

