Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC07537F8
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735955615; cv=none; b=evvQRp1qZt4J7hGZt0EmKxKu/8eKguN7wHkqLlPA3mLTEf6qWivvdqrvlUgzgPUBwR06rHhlRsCgpc1+JlMaqYdnlB1YHihcVPWScujuiPKohlZ2fAdwTRtBifLotw874PHJ+0PKqj14LBukXRApGs0J4gmaZOvSITXw++b+fak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735955615; c=relaxed/simple;
	bh=QDBUR4qKB1ODaiFJJ8wGEXUNaWqdCpXdP83FGHj5ec4=;
	h=Date:To:From:Subject:Message-Id; b=CQYQyS9lsinZAYsC4nH94+9D2hFHu6Retl/Y4uGKZg8OCBEHUBx4euNRU3vL8T8bsRHDhjRkR/QBcC5TV36apKcoLL1/2A94mDdwFqSYpiSLAiIKlJygHXXB3DsZvdqQTCdZwx33Fy5ctlqfjyv1fVFnjF1q0undrVBD3iTCXxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zp/dSYyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zp/dSYyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D71C4CED6;
	Sat,  4 Jan 2025 01:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735955615;
	bh=QDBUR4qKB1ODaiFJJ8wGEXUNaWqdCpXdP83FGHj5ec4=;
	h=Date:To:From:Subject:From;
	b=zp/dSYyfHRFb7gPylxTXJ9uMDQsysw21FqIQvuropRm79Ne3AOzPh+nNCiyrlEr6k
	 sAZF56gYmgjbURSAceDyQo26PYtgJXtDBc68qJQO+WeDKbvk4eYcT3WkjScf3FqVW2
	 AF5IGVJUXsIBsaFHe8IO59TX/E1AbyDbK5Xq89pU=
Date: Fri, 03 Jan 2025 17:53:34 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,peterz@infradead.org,mingo@redhat.com,marmarek@invisiblethingslab.com,luto@kernel.org,hpa@zytor.com,dave.hansen@linux.intel.com,jgross@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-execmem-fix-rox-cache-usage-in-xen-pv-guests.patch added to mm-hotfixes-unstable branch
Message-Id: <20250104015334.F3D71C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/execmem: fix ROX cache usage in Xen PV guests
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-execmem-fix-rox-cache-usage-in-xen-pv-guests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-execmem-fix-rox-cache-usage-in-xen-pv-guests.patch

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

x86-execmem-fix-rox-cache-usage-in-xen-pv-guests.patch

