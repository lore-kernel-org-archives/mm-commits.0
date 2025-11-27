Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498553246ED
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282379; cv=none; b=YpVEE97zAhSD1hEPs87LEhOJw3iOaDxJXK4WIGRv8n3L0bd5bpP4VfIPk34RxrSM2ZIsOmL2S76/UvEFx+ZK/BSIMax9EkGKASPOBbbPkWjkamrHheDi7YZO3BAwFRCohDlt+T79OW6mzb2cDdqJu8UKuWrrQaylAYFBruUEz/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282379; c=relaxed/simple;
	bh=DeSxv88+I0T1gZlYF2mQMCfjLK4CidjDT0SAw6Yvgfs=;
	h=Date:To:From:Subject:Message-Id; b=kIHsJiFLsafSr7EromnlJe9plz0wEwPgqDhCO+EJQaR9wUaB9DYj/1QjM4uN/KUEhJSOMH6CA3bHVvVCZDCrO1pTn+YhbARJBG3zCqip11eEcRf8zzpPw2pafyshqAxuTtjJhOxsoxgd3Ir00lRqgjOXyz7LUxrtQ5xIjzO3cN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dOUtqbOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dOUtqbOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC19C4CEF8;
	Thu, 27 Nov 2025 22:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282378;
	bh=DeSxv88+I0T1gZlYF2mQMCfjLK4CidjDT0SAw6Yvgfs=;
	h=Date:To:From:Subject:From;
	b=dOUtqbOejjNhzre+0t+NtFoWhuvDC//J/JpTXhZUnyB5cdEz5SLdgek0xCBCWHsRY
	 uJLpXZMN/de4/CgYpn+RIMvIaOMD2Z+M2PIV6JEnbI+fCNOz1f+HSiPLKgOSvIqSMH
	 n9Xe5V6I+mVjPI4ZvMhStOUJEJkz5suxKkToLY0U=
Date: Thu, 27 Nov 2025 14:26:18 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-always-expose-output-fdt-in-debugfs.patch removed from -mm tree
Message-Id: <20251127222618.CBC19C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: always expose output FDT in debugfs
has been removed from the -mm tree.  Its filename was
     kho-always-expose-output-fdt-in-debugfs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: always expose output FDT in debugfs
Date: Fri, 14 Nov 2025 13:59:55 -0500

Currently, the output FDT is added to debugfs only when KHO is finalized
and removed when aborted.

There is no need to hide the FDT based on the state.  Always expose it
starting from initialization.  This aids the transition toward removing
the explicit abort functionality and converting KHO to be fully stateless.

Link: https://lkml.kernel.org/r/20251114190002.3311679-7-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-always-expose-output-fdt-in-debugfs
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1234,8 +1234,6 @@ int kho_abort(void)
 	__kho_abort();
 	kho_out.finalized = false;
 
-	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
-
 	return 0;
 }
 
@@ -1306,9 +1304,6 @@ int kho_finalize(void)
 
 	kho_out.finalized = true;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
-
 	return 0;
 }
 
@@ -1425,6 +1420,9 @@ static __init int kho_init(void)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
 	}
 
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
+					 kho_out.fdt, true));
+
 	return 0;
 
 err_free_fdt:
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

