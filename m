Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8BA13A897
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717628238; cv=none; b=ROPJUNbreqrHdCW0l/ZID/xZwtuYMpOwtkfaO/qQnSyWnCtZM9qY8hHytFb8WSZr0Y3UNDQSJJzEHIOdU986AtMDy7bIe1gNTT9hfxD9HeWiG9vc3Iz2p1sgrsUMgl4E/Es0Sa8iW1xH5WWkiPqyfGZGONwLAw+jKs91I6tk51k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717628238; c=relaxed/simple;
	bh=fyLhMziPeupjyggKcESLOaQQf3Cj0WymyMTKecjOXnw=;
	h=Date:To:From:Subject:Message-Id; b=qNNYCUkC4eHF9KVokBvZv6ISC9xob2OUpuTZBcl9lUw/s+4JxmMaj519UZPNayR35sejFc06zhUsnfmQKFlSZRO2BmcFXhrvRess1B/0O/ORf+AzZ68Q/bW6Sc0EiS8kKZm0+1A6MVbeinqMeNezxkf00DvEBl9yGFhSVMLgXQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z/9FFAeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z/9FFAeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55980C2BD11;
	Wed,  5 Jun 2024 22:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717628238;
	bh=fyLhMziPeupjyggKcESLOaQQf3Cj0WymyMTKecjOXnw=;
	h=Date:To:From:Subject:From;
	b=Z/9FFAeoHSgnQSQs5ao78xfjDWRIsOryuoaPeiK6YXyUfqpWO47/GNoPkVQy6tCU3
	 0hEMbj6XKaYcz/eHL8hn4W4VOaSA8IO1xy+99HOntFI7MzQ3FuzXhOv8k5mBtgsARw
	 HaO/pyHtMLxHhcHgWC9FogplUsGYODJjuUC85ulY=
Date: Wed, 05 Jun 2024 15:57:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pasha.tatashin@soleen.com,lkp@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n.patch added to mm-hotfixes-unstable branch
Message-Id: <20240605225718.55980C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/alloc_tag: do not register sysctl interface when CONFIG_SYSCTL=n
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n.patch

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

mm-fix-xyz_noprof-functions-calling-profiled-functions.patch
lib-alloc_tag-do-not-register-sysctl-interface-when-config_sysctl=n.patch
lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch

