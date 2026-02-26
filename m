Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A6422A4E9
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 01:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772069304; cv=none; b=pj1qScJvNtUFRckYU9ixwLEplWZTqBTJCXIT7A1ktkH+hfxt2Wl/G5u9n54ZQK5QrFFObiMobqkM2sB0ah34eTlhdNhX0aGdCGdjvI5DMDSZEVgw3QretxUewup9QdTrpWcj9OR1IP4GHSf5g137QTVYmYpz6+aZ7bIok1zuS6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772069304; c=relaxed/simple;
	bh=0rtSqt69PeWiqEArjZcd/2ojk+nGclCkkYQOHzqFR94=;
	h=Date:To:From:Subject:Message-Id; b=nqwrTYBhBYbVQOIMKCLknuknKmK5c4CkzaeTkz5e16NmNgAD5Nn2k9nRWFojsD2bwMS4WGPuSqdRU945dM5boURx1NVNNCWMSD9Gsi0Ip9nNKgxo469Evhfx+Za1dgmxEXntKf4f6WyT7iK7aArSvRyNyO6zsGDWt4voJBOjJPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gF0aDjry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gF0aDjry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1EEC116D0;
	Thu, 26 Feb 2026 01:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772069303;
	bh=0rtSqt69PeWiqEArjZcd/2ojk+nGclCkkYQOHzqFR94=;
	h=Date:To:From:Subject:From;
	b=gF0aDjrye7WJMKzqofBuxzACp+yuUD4VxPuI7sdy7NfldJIqC5l3GqofsYtoz3jK7
	 6gqtXtHkx5zM0Pw9xX0gPITqTTYRW+9RAX9ggmot1oLxPRCnS7fahTKPQNH1iQcI3q
	 YSJTvYLl2YeoIXUjvWNQdCJqjTYePMG97M24RFHA=
Date: Wed, 25 Feb 2026 17:28:22 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tstaudt@de.ibm.com,sourabhjain@linux.ibm.com,ryncsn@gmail.com,robh@kernel.org,lkp@intel.com,krzk@kernel.org,kernelfans@gmail.com,dyoung@redhat.com,chleroy@kernel.org,bhe@redhat.com,arnaud.lefebvre@clever-cloud.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-dm-crypt-dont-print-in-arch-specific-code.patch added to mm-nonmm-unstable branch
Message-Id: <20260226012823.7D1EEC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump/dm-crypt: don't print in arch-specific code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_dump-dm-crypt-dont-print-in-arch-specific-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-dm-crypt-dont-print-in-arch-specific-code.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: kernel test robot <lkp@intel.com>
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
@@ -414,14 +414,16 @@ int crash_load_dm_crypt_keys(struct kima
 
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
@@ -432,6 +434,7 @@ int crash_load_dm_crypt_keys(struct kima
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	r = kexec_add_buffer(&kbuf);
 	if (r) {
+		pr_err("Failed to call kexec_add_buffer, ret=%d\n", r);
 		kvfree((void *)kbuf.buffer);
 		return r;
 	}
_

Patches currently in -mm which might be from coxu@redhat.com are

crash_dump-dm-crypt-dont-print-in-arch-specific-code.patch
crash-align-the-declaration-of-crash_load_dm_crypt_keys-with-config_crash_dm_crypt.patch
arm64ppc64le-kdump-pass-dm-crypt-keys-to-kdump-kernel.patch

