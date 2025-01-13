Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8B085260
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 03:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737451; cv=none; b=EvnNkphzJvM19symDLPJ9qlQRilOW+WuBjseM+93MLA1xkUgbJAMvGk6F6FN8DfPB3Sm3iMI9JTlMMjXtPUCPfvU56yCsW3gHib2MKKBMO15qJtIHkUgXapBxxfEXj2j0NL2bycdZAY9xI7Wzj0lnUZNCI9yPIWxrKMstOCpCS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737451; c=relaxed/simple;
	bh=rlJSHkQWPhZk6GwP9sb5wrKms8+0BBWGXd6FmqHPJec=;
	h=Date:To:From:Subject:Message-Id; b=jJb9w9vBPYa4H7w7FCFJMbqXaGnfkBO09VS61YIZA6USy6b6L1lS4HrelsolZkMVGqK568zh629IjexI3QDFueJvNn/AwFPYbyz9uz9LnIMTU5CEra8+r3glKKoOPACKSjPkCxQXGRRRqfp4lbBM8mMU7Ojnkm7yqGvt/jCGUpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LwEkes5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LwEkes5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD12C4CEDF;
	Mon, 13 Jan 2025 03:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737451;
	bh=rlJSHkQWPhZk6GwP9sb5wrKms8+0BBWGXd6FmqHPJec=;
	h=Date:To:From:Subject:From;
	b=LwEkes5yXQz+s4j6qZ8GuvTHmBM0dte6fK9amsgFoB3MZT0YTBEIDRvpcRB5qRYrC
	 MS+CAMUYW0g+TQYFsw5Sh727pVwx5ZzIeXrPw5ocDBD0YyvV8Qi9Q4qvXWrSBpzsDs
	 aLCYVB0f6LhlP1T5F5xe5NlKv1X6bpF0LQGEVw08=
Date: Sun, 12 Jan 2025 19:04:10 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,peterz@infradead.org,mingo@redhat.com,mcgrof@kernel.org,marmarek@invisiblethingslab.com,luto@kernel.org,hpa@zytor.com,dave.hansen@linux.intel.com,jgross@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-execmem-fix-rox-cache-usage-in-xen-pv-guests.patch removed from -mm tree
Message-Id: <20250113030410.EAD12C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/execmem: fix ROX cache usage in Xen PV guests
has been removed from the -mm tree.  Its filename was
     x86-execmem-fix-rox-cache-usage-in-xen-pv-guests.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Juergen Gross <jgross@suse.com>
Subject: x86/execmem: fix ROX cache usage in Xen PV guests
Date: Fri, 3 Jan 2025 07:56:31 +0100

The recently introduced ROX cache for modules is assuming large page
support in 64-bit mode without testing the related feature bit.  This
results in breakage when running as a Xen PV guest, as in this mode large
pages are not supported.

Fix that by testing the X86_FEATURE_PSE capability when deciding whether
to enable the ROX cache.

Link: https://lkml.kernel.org/r/20250103065631.26459-1-jgross@suse.com
Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/init.c~x86-execmem-fix-rox-cache-usage-in-xen-pv-guests
+++ a/arch/x86/mm/init.c
@@ -1080,7 +1080,8 @@ struct execmem_info __init *execmem_arch
 
 	start = MODULES_VADDR + offset;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX)) {
+	if (IS_ENABLED(CONFIG_ARCH_HAS_EXECMEM_ROX) &&
+	    cpu_feature_enabled(X86_FEATURE_PSE)) {
 		pgprot = PAGE_KERNEL_ROX;
 		flags = EXECMEM_KASAN_SHADOW | EXECMEM_ROX_CACHE;
 	} else {
_

Patches currently in -mm which might be from jgross@suse.com are


