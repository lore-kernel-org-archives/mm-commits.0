Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D63321457
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282373; cv=none; b=YOxWP1fQ+7a7zmHIV6onoQNV0S2rfPgbsmlF3N5IbtFVS+kuLF9Yir46SCARTjZa4CHzayq4/iOhcr45TeRXUBHnKRHiCxkaItDgzzxy8A7ETTGmBcDk7vok606t8Tb2JT6lN+BPt0AEXRuwzK4K8GuJuoR1YZf13IrvoA51ycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282373; c=relaxed/simple;
	bh=8dGbUff371pZ9amK8dZRR3cEHtRMMKoDdNQZ2gx6nu0=;
	h=Date:To:From:Subject:Message-Id; b=T0imzof8HUtmZvutVadO/Li5KhW7dhy9iGgowwm8J5rGREeBKBxgSrdjBS+oE97saXWvo8ENgJLnee3kqJxEjvqdrD89gGwZC6QzUb+W/0wWwIe/uVCxmHNlB6dt1AipizXL9CHw7ks2YF3NhibsV1l4waYSdPhbY16FWQOQ4NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vOVfn8WL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vOVfn8WL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2885AC4CEFB;
	Thu, 27 Nov 2025 22:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282372;
	bh=8dGbUff371pZ9amK8dZRR3cEHtRMMKoDdNQZ2gx6nu0=;
	h=Date:To:From:Subject:From;
	b=vOVfn8WLHY1kcWym5UxS7KfggmNv6YhJI+DlwSBhblw5UGUQ93slWZ4rOu43GOgmG
	 p6Um6o+ovPYS+r0k49Wim6QIJsH7rPMJyyIzfIUO1RRgZw9PkvuMHoRJsaLdctPCob
	 2ndMRtXgCGH2lv4TP+q7dHrRPOBNuFtoYcLX8uiM=
Date: Thu, 27 Nov 2025 14:26:11 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-convert-__kho_abort-to-return-void.patch removed from -mm tree
Message-Id: <20251127222612.2885AC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: convert __kho_abort() to return void
has been removed from the -mm tree.  Its filename was
     kho-convert-__kho_abort-to-return-void.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: convert __kho_abort() to return void
Date: Fri, 14 Nov 2025 13:59:51 -0500

The internal helper __kho_abort() always returns 0 and has no failure
paths.  Its return value is ignored by __kho_finalize and checked
needlessly by kho_abort.

Change the return type to void to reflect that this function cannot fail,
and simplify kho_abort by removing dead error handling code.

Link: https://lkml.kernel.org/r/20251114190002.3311679-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-convert-__kho_abort-to-return-void
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1117,20 +1117,16 @@ err_free_pages_array:
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-static int __kho_abort(void)
+static void __kho_abort(void)
 {
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
-
-	return 0;
 }
 
 int kho_abort(void)
 {
-	int ret = 0;
-
 	if (!kho_enable)
 		return -EOPNOTSUPP;
 
@@ -1138,10 +1134,7 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	ret = __kho_abort();
-	if (ret)
-		return ret;
-
+	__kho_abort();
 	kho_out.finalized = false;
 
 	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

