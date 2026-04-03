Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299F534D91F
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198556; cv=none; b=m1dvNQ26b3ChHZb3CMQhIu3ABBNtHYL/lIJiohfgOPgfNsjSCJq8b0B3FWwKl4Kyl2gcny6ZK4p355aoxuVTx43lGjCK42PzLZxI6IhOxWKzKBapaFEU4kWHT7XeMqoiOwGqFyoKxAluRkc2QpNeQvib/l1PC4laAZG/DwvG32I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198556; c=relaxed/simple;
	bh=2F8dt9yRUBuBr/gg81KnsjwNgpeTSsRzDhrdS464hHI=;
	h=Date:To:From:Subject:Message-Id; b=Y0QYXhm/rM7LBbS/ThmjkdqQ9Ld82g3tNlxHK/fD1/ThgYXsciv6NJaJb7LN8Jzqg7Hb/YikwYMug1ZRzU1O5Pc9riXIgi8b7bISnVRFAB6Vb1127ZoPFXwADVGV7DMfeT7UeYQNdWfhv46aipn9C6ktz5uNxjagkmq80DVcZM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W+Yuz5Ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W+Yuz5Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4229C4CEF7;
	Fri,  3 Apr 2026 06:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775198556;
	bh=2F8dt9yRUBuBr/gg81KnsjwNgpeTSsRzDhrdS464hHI=;
	h=Date:To:From:Subject:From;
	b=W+Yuz5JuQvxegAmN2nH+y+UdAYI52zJCNFaXNvpNEddHV/hS9kAWmHzD7hnkCJBBS
	 HaDvtnE2N/RyGE6hz+NEey+jrF7onDIN5G3jjtEZlDGXNw9wKedtdPajtMOApYAtRp
	 3gZWFah8M5YMoP1/YK1sdYP76ok2dsWN0b+NC/XI=
Date: Thu, 02 Apr 2026 23:42:35 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tstaudt@de.ibm.com,sourabhjain@linux.ibm.com,ryncsn@gmail.com,robh@kernel.org,krzk@kernel.org,kernelfans@gmail.com,dyoung@redhat.com,chleroy@kernel.org,bhe@redhat.com,arnaud.lefebvre@clever-cloud.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_dump-dm-crypt-dont-print-in-arch-specific-code.patch removed from -mm tree
Message-Id: <20260403064235.F4229C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_dump/dm-crypt: don't print in arch-specific code
has been removed from the -mm tree.  Its filename was
     crash_dump-dm-crypt-dont-print-in-arch-specific-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Coiby Xu <coxu@redhat.com>
Subject: crash_dump/dm-crypt: don't print in arch-specific code
Date: Wed, 25 Feb 2026 14:03:44 +0800

Patch series "kdump: Enable LUKS-encrypted dump target support in ARM64
and PowerPC", v5.

CONFIG_CRASH_DM_CRYPT has been introduced to support LUKS-encrypted device
dump target by addressing two challenges [1],

 - Kdump kernel may not be able to decrypt the LUKS partition. For some
   machines, a system administrator may not have a chance to enter the
   password to decrypt the device in kdump initramfs after the 1st kernel
   crashes

 - LUKS2 by default use the memory-hard Argon2 key derivation function
   which is quite memory-consuming compared to the limited memory reserved
   for kdump.

To also enable this feature for ARM64 and PowerPC, we need to add a device
tree property dmcryptkeys [2] as similar to elfcorehdr to pass the memory
address of the stored info of dm-crypt keys to the kdump kernel.


This patch (of 3):

When the vmcore dumping target is not a LUKS-encrypted target, it's
expected that there is no dm-crypt key thus no need to return -ENOENT. 
Also print more logs in crash_load_dm_crypt_keys.  The benefit is
arch-specific code can be more succinct.

Link: https://lkml.kernel.org/r/20260225060347.718905-1-coxu@redhat.com
Link: https://lkml.kernel.org/r/20260225060347.718905-2-coxu@redhat.com
Link: https://lore.kernel.org/all/20250502011246.99238-1-coxu@redhat.com/ [1]
Link: https://github.com/devicetree-org/dt-schema/pull/181 [2]
Signed-off-by: Coiby Xu <coxu@redhat.com>
Suggested-by: Will Deacon <will@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Pingfan Liu <kernelfans@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Staudt <tstaudt@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kexec-bzimage64.c |    6 +-----
 kernel/crash_dump_dm_crypt.c      |    7 +++++--
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/kexec-bzimage64.c~crash_dump-dm-crypt-dont-print-in-arch-specific-code
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -525,12 +525,8 @@ static void *bzImage64_load(struct kimag
 		if (ret)
 			return ERR_PTR(ret);
 		ret = crash_load_dm_crypt_keys(image);
-		if (ret == -ENOENT) {
-			kexec_dprintk("No dm crypt key to load\n");
-		} else if (ret) {
-			pr_err("Failed to load dm crypt keys\n");
+		if (ret)
 			return ERR_PTR(ret);
-		}
 		if (image->dm_crypt_keys_addr &&
 		    cmdline_len + MAX_ELFCOREHDR_STR_LEN + MAX_DMCRYPTKEYS_STR_LEN >
 			    header->cmdline_size) {
--- a/kernel/crash_dump_dm_crypt.c~crash_dump-dm-crypt-dont-print-in-arch-specific-code
+++ a/kernel/crash_dump_dm_crypt.c
@@ -415,14 +415,16 @@ int crash_load_dm_crypt_keys(struct kima
 
 	if (key_count <= 0) {
 		kexec_dprintk("No dm-crypt keys\n");
-		return -ENOENT;
+		return 0;
 	}
 
 	if (!is_dm_key_reused) {
 		image->dm_crypt_keys_addr = 0;
 		r = build_keys_header();
-		if (r)
+		if (r) {
+			pr_err("Failed to build dm-crypt keys header, ret=%d\n", r);
 			return r;
+		}
 	}
 
 	kbuf.buffer = keys_header;
@@ -433,6 +435,7 @@ int crash_load_dm_crypt_keys(struct kima
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	r = kexec_add_buffer(&kbuf);
 	if (r) {
+		pr_err("Failed to call kexec_add_buffer, ret=%d\n", r);
 		kvfree((void *)kbuf.buffer);
 		return r;
 	}
_

Patches currently in -mm which might be from coxu@redhat.com are


