Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CAF1F09A3
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 20:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767126976; cv=none; b=kvVf2qO09PARY9fGntA0WRtnNK4bTjOKApX0odo6W6R2DrzSasasyIwSvq3gHqIQNAU6juaQ5J0abkBFeBQONNCjOvK/UivMDF2maPfYt8JpLqh0srBHxBTaxAUCse5/l1Z8KJ6T2wlsycAUt7lRtKEDhfNTGEb3KlU4HHO7frU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767126976; c=relaxed/simple;
	bh=DFo4jd3G2NIjfRbPoE8fLhrlpfNhlvORKVpPzYoSxZQ=;
	h=Date:To:From:Subject:Message-Id; b=lTAyi96mUbTnoZswLNJRRJRKcjFRRDDRDAOMdZrc5cLYpdn9JwGthbJwuahpvxCc+2yA4OJSlobc6RekpSGGIziCbOOiAnFoLu3AjQF1LnHRu2VCmY6EVewxg4nim4ZmV4fe4PGTlB5KyfwvZxMEJCbQGwTqrQ565gqI8gSqWg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgGZ7EgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgGZ7EgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4532C4CEFB;
	Tue, 30 Dec 2025 20:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767126975;
	bh=DFo4jd3G2NIjfRbPoE8fLhrlpfNhlvORKVpPzYoSxZQ=;
	h=Date:To:From:Subject:From;
	b=QgGZ7EgTFr9ZKVWKJfH8f8xqbMZBmDjxspAjCFoSorS8yCSFDEzgVYZyDnpp7vQec
	 JwxHNZL/mmhlBQ2bba0dZniqfPyYBtx4luPMcseX2CDBXaaydiOfHgLSupkOGmwEDE
	 iIO5Y8BdCKe+n3L8MBLhqONXXjV1ac2EbbtrhDZM=
Date: Tue, 30 Dec 2025 12:36:15 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@meta.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,harshit.m.mogalapalli@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,ardb@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch removed from -mm tree
Message-Id: <20251230203615.C4532C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix
has been removed from the -mm tree.  Its filename was
     x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch

This patch was dropped because it was folded into x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix
Date: Mon Dec  1 09:20:28 AM PST 2025

fix comment typo

Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Jonathan McDowell <noodles@meta.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Paul Webb <paul.x.webb@oracle.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/setup.c~x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix
+++ a/arch/x86/kernel/setup.c
@@ -446,7 +446,7 @@ int __init ima_get_kexec_buffer(void **a
 
 	/*
 	 * Calculate the PFNs for the buffer and ensure
-	 * they are with in addressable memory.
+	 * they are within addressable memory.
 	 */
 	start_pfn = PFN_DOWN(ima_kexec_buffer_phys);
 	end_pfn = PFN_DOWN(ima_kexec_buffer_phys + ima_kexec_buffer_size - 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
kernel-watchdogc-fix-unused-var-warning.patch

