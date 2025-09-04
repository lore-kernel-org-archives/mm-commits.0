Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CCF1A285;
	Thu,  4 Sep 2025 00:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944700; cv=none; b=pBI4/qbixxJfde+9XQRVsdDaYZ+WGPVGxgjUCp+lUXXz0DWLOOpQ3uSsAOypTlVEsPcA+DlOW0yf9cW+mk3W40vtflXqR5fdx7FkiFm0/8QG2ABNiJQbW9rVSfTI0m6Aws2cO1iSl3h4xT+/G9EJ1we3Q+7RjpNzRhmCNCPoVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944700; c=relaxed/simple;
	bh=BFXeOt5i1+sod2fzIPRWV5VKfRXPIRLYb6+JcrKwnDc=;
	h=Date:To:From:Subject:Message-Id; b=U/g/g5awGS1cLzFBVWTV9jfRVJi9aoz3Wu3e+usLnhlwy9UXT0x1lNauN8FUMk7G8qzDePH9A15/AqEyPJPMi1bHbUE1TZytTnBoPNCOuC65qnChxvttRdzOJEuOzc0daDP2l5U/V5ovKChn8R3Ku2ievRRLbPABWf4wJeibdBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FvFPGjzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FvFPGjzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83711C4CEE7;
	Thu,  4 Sep 2025 00:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944700;
	bh=BFXeOt5i1+sod2fzIPRWV5VKfRXPIRLYb6+JcrKwnDc=;
	h=Date:To:From:Subject:From;
	b=FvFPGjzurMBWIkhLDIPQUicqsrzfxI4wQz2T8tQa5B0HUyXeVqXpILFQGQh/Ns0si
	 NtCtzKoT4EnJFeXuiXqWwgwbg+Crl0YebPDdltriUIeLcCJ33ctjnukOL+wwuI7ICj
	 Sn58gj9eFpv5VHCTiAuO64cLXNkmLupxBDLPOnaA=
Date: Wed, 03 Sep 2025 17:11:40 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,stable@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,hca@linux.ibm.com,gor@linux.ibm.com,coxu@redhat.com,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments.patch removed from -mm tree
Message-Id: <20250904001140.83711C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: kexec: initialize kexec_buf struct in load_other_segments()
has been removed from the -mm tree.  Its filename was
     arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: arm64: kexec: initialize kexec_buf struct in load_other_segments()
Date: Wed, 27 Aug 2025 03:42:21 -0700

Patch series "kexec: Fix invalid field access".

The kexec_buf structure was previously declared without initialization. 
commit bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
added a field that is always read but not consistently populated by all
architectures.  This un-initialized field will contain garbage.

This is also triggering a UBSAN warning when the uninitialized data was
accessed:

	------------[ cut here ]------------
	UBSAN: invalid-load in ./include/linux/kexec.h:210:10
	load of value 252 is not a valid value for type '_Bool'

Zero-initializing kexec_buf at declaration ensures all fields are cleanly
set, preventing future instances of uninitialized memory being used.

An initial fix was already landed for arm64[0], and this patchset fixes
the problem on the remaining arm64 code and on riscv, as raised by Mark.

Discussions about this problem could be found at[1][2].


This patch (of 3):

The kexec_buf structure was previously declared without initialization.
commit bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
added a field that is always read but not consistently populated by all
architectures. This un-initialized field will contain garbage.

This is also triggering a UBSAN warning when the uninitialized data was
accessed:

	------------[ cut here ]------------
	UBSAN: invalid-load in ./include/linux/kexec.h:210:10
	load of value 252 is not a valid value for type '_Bool'

Zero-initializing kexec_buf at declaration ensures all fields are
cleanly set, preventing future instances of uninitialized memory being
used.

Link: https://lkml.kernel.org/r/20250827-kbuf_all-v1-0-1df9882bb01a@debian.org
Link: https://lkml.kernel.org/r/20250827-kbuf_all-v1-1-1df9882bb01a@debian.org
Link: https://lore.kernel.org/all/20250826180742.f2471131255ec1c43683ea07@linux-foundation.org/ [0]
Link: https://lore.kernel.org/all/oninomspajhxp4omtdapxnckxydbk2nzmrix7rggmpukpnzadw@c67o7njgdgm3/ [1]
Link: https://lore.kernel.org/all/20250826-akpm-v1-1-3c831f0e3799@debian.org/ [2]
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/machine_kexec_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/machine_kexec_file.c~arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments
+++ a/arch/arm64/kernel/machine_kexec_file.c
@@ -94,7 +94,7 @@ int load_other_segments(struct kimage *i
 			char *initrd, unsigned long initrd_len,
 			char *cmdline)
 {
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	void *dtb = NULL;
 	unsigned long initrd_load_addr = 0, dtb_len,
 		      orig_segments = image->nr_segments;
_

Patches currently in -mm which might be from leitao@debian.org are


