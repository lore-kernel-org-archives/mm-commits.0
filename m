Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F516FC5
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 23:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756336163; cv=none; b=tUPmWzqJiv159hEiRPuuPyJGxMGRYNSuew7SFPJoZEAcivLMA4rO35OwJgoXOOOG0/rYjS+tykyo7WYmcEUokapXkwsH11JopCWI+Z9J2eDHsb2T/VepfIDCdngSWkmyhwKq2LitAstf9fp3pfNTvEqjPHN/1ZZN5oX/QXuWs/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756336163; c=relaxed/simple;
	bh=tL9XBRzuOhDwNY0DmHbws4FO7/Yh3hHD3ViYOWHWvaM=;
	h=Date:To:From:Subject:Message-Id; b=ZW8Cl5B30+DDmxNuA3PlLxKaZqooN8lxLDHr+jkoBw+1IbfqbRA03KuwQDQSrSTDgktLG3RQftCAhOM0LwzErfWKBQLN/2ro8884IHj/2E0pMIMvILsfpDo0NxgZy74omgV5MH//n9rBPXysB8ZweYZYILisMB1kS/zeu+kBysI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzXE5cNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzXE5cNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A127C4CEEB;
	Wed, 27 Aug 2025 23:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756336162;
	bh=tL9XBRzuOhDwNY0DmHbws4FO7/Yh3hHD3ViYOWHWvaM=;
	h=Date:To:From:Subject:From;
	b=AzXE5cNNBXdcLILQi1iWcrIXI6SoowyWYcOqnD0f6Y5kCw0vuS/cYfB3cmdoUDgmZ
	 R9MFjyWOjOKmQ29E4m4IOWPcPyyFB31OzK7U8t0jruaO0kg3uUWE+fFVhHAS6uHZC9
	 BKgrQW4iCOm5X/SmdU9ACJZGoXei0TeUDTepJyYU=
Date: Wed, 27 Aug 2025 16:09:21 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,hca@linux.ibm.com,gor@linux.ibm.com,coxu@redhat.com,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments.patch added to mm-hotfixes-unstable branch
Message-Id: <20250827230922.9A127C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: kexec: initialize kexec_buf struct in load_other_segments()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments.patch

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
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
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

arm64-kexec-initialize-kexec_buf-struct-in-image_load.patch
arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments.patch
riscv-kexec-initialize-kexec_buf-struct.patch
s390-kexec-initialize-kexec_buf-struct.patch

