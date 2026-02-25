Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A503195FD
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 22:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772057292; cv=none; b=gHH9NsuOg6QfZnzz+FFFeRuxULfpCSRjq1g5HxvRzdpAa7+vx0pWOt9ZjaJirOaV7ba+SCFayMU92LcmyGyOa4wvX7stgmVamorKgOAt4wForejZAjCzmuEYCpN071yY5/inxdYrMXNH5Kuy/6l4QwU4inrX+qHIzfR7dt6MCus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772057292; c=relaxed/simple;
	bh=udgnc61Jhc6ma2q5zj/vN3P8JmJtt44t9aiSlUK2odI=;
	h=Date:To:From:Subject:Message-Id; b=E9e8z652NKtrCBGT1mjcmgEDY9YHnhhxJf0KfV4tP0xgBVb5prPMpTavxO+OGm+JgCB6G/wYFrRBg/DNHNjUMSA8ewvNVndzdv10O/lySFwEWUHK5xytK9xCHREFknT3u/n4ZS15fBv9D7js8rxGA5rld9l2OLJIcHgk0uwyn10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hxY1sKQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hxY1sKQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7F2C116D0;
	Wed, 25 Feb 2026 22:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772057291;
	bh=udgnc61Jhc6ma2q5zj/vN3P8JmJtt44t9aiSlUK2odI=;
	h=Date:To:From:Subject:From;
	b=hxY1sKQeLRvkqiE7Am/WxkNUPHLaKB1JPjie4uqBBTAYNU8ZYS+L6fpJ54xvrGAjI
	 GZ7rQjbnjhpQZikGwj2d1yOX4WK11bPtVR7kP2oi6EJmsWrrvZzLl2gN4aFVy3KdXy
	 KY4+FL3eMacMMzgoFwi0+5h5yqlGSixpvh/eF5fk=
Date: Wed, 25 Feb 2026 14:08:11 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tstaudt@de.ibm.com,sourabhjain@linux.ibm.com,ryncsn@gmail.com,robh@kernel.org,lkp@intel.com,krzk@kernel.org,kernelfans@gmail.com,dyoung@redhat.com,chleroy@kernel.org,bhe@redhat.com,arnaud.lefebvre@clever-cloud.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-dm-crypt-dont-print-in-arch-specific-code.patch added to mm-nonmm-unstable branch
Message-Id: <20260225220811.AB7F2C116D0@smtp.kernel.org>
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

When the vmcore dumping target is not a LUKS-encrypted target, it's
expected that there is no dm-crypt key thus no need to return -ENOENT. 
Also print more logs in crash_load_dm_crypt_keys.  The benefit is
arch-specific code can be more succinct.

Link: https://lkml.kernel.org/r/20260225060347.718905-2-coxu@redhat.com
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Coiby Xu <coxu@redhat.com>
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

