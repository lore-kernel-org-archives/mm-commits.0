Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0143433E1
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 05:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746335736; cv=none; b=pCOAkMwMgmFzbgB2T6NG0LvHi8GLPy5MxwQc7JVjSu0SyCRQ6vrn1tlJcA7u0CnKxitQHXJtSVGmDgsHtwN8bh9H31Gd9wRnU926LGllrAAILS102Mi1A/wDeMjKdbSjcngooTfTTrBO8MCQNiF2v0+kxSR9OVueKoYt4onj0n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746335736; c=relaxed/simple;
	bh=KrLsJBsBVQjztrO/hUfxO/jsqJluqZ7SjH5bm8wskRk=;
	h=Date:To:From:Subject:Message-Id; b=nhYsoEli/rL+fycTI5eC3V5tugm0fvg42F5XL1xkNpfN/gbBq03s5A0TgVX64p7igramiCRqi9MgBDqWdIKGqgDDPGDo7DpLibuVZAV9lAQs0YjsrDhmSAVFUnEq/nlyHpva/lgv34KMvUsqB8f9x305bhMfnTyLBiUDg4YG8C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=py9+Fwdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="py9+Fwdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B4FC4CEED;
	Sun,  4 May 2025 05:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746335735;
	bh=KrLsJBsBVQjztrO/hUfxO/jsqJluqZ7SjH5bm8wskRk=;
	h=Date:To:From:Subject:From;
	b=py9+FwdpplxIU4f1EzdOEgJZuwKC7BESChDL/J/EZp+3fd/SI5eEi2H+nUPCFXHt4
	 mRSNeiY/heY7IszJLrMhC32I67++JmM8HuGMm/AU+rOrN/uqPY/7Pj07+GB2v4O8cn
	 QG/TQx7Aj4EY4rraRoR+Bk1lMUaBq5+Tlt1wEQew=
Date: Sat, 03 May 2025 22:15:35 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,bhe@redhat.com,berrange@redhat.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible.patch added to mm-nonmm-unstable branch
Message-Id: <20250504051535.C3B4FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/crash: make the page that stores the dm crypt keys inaccessible
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Coiby Xu <coxu@redhat.com>
Subject: x86/crash: make the page that stores the dm crypt keys inaccessible
Date: Fri, 2 May 2025 09:12:42 +0800

This adds an addition layer of protection for the saved copy of dm crypt
key.  Trying to access the saved copy will cause page fault.

Link: https://lkml.kernel.org/r/20250502011246.99238-9-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Suggested-by: Pingfan Liu <kernelfans@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jan Pazdziora <jpazdziora@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/x86/kernel/machine_kexec_64.c~x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -598,13 +598,35 @@ static void kexec_mark_crashkres(bool pr
 	kexec_mark_range(control, crashk_res.end, protect);
 }
 
+/* make the memory storing dm crypt keys in/accessible */
+static void kexec_mark_dm_crypt_keys(bool protect)
+{
+	unsigned long start_paddr, end_paddr;
+	unsigned int nr_pages;
+
+	if (kexec_crash_image->dm_crypt_keys_addr) {
+		start_paddr = kexec_crash_image->dm_crypt_keys_addr;
+		end_paddr = start_paddr + kexec_crash_image->dm_crypt_keys_sz - 1;
+		nr_pages = (PAGE_ALIGN(end_paddr) - PAGE_ALIGN_DOWN(start_paddr))/PAGE_SIZE;
+		if (protect)
+			set_memory_np((unsigned long)phys_to_virt(start_paddr), nr_pages);
+		else
+			__set_memory_prot(
+				(unsigned long)phys_to_virt(start_paddr),
+				nr_pages,
+				__pgprot(_PAGE_PRESENT | _PAGE_NX | _PAGE_RW));
+	}
+}
+
 void arch_kexec_protect_crashkres(void)
 {
 	kexec_mark_crashkres(true);
+	kexec_mark_dm_crypt_keys(true);
 }
 
 void arch_kexec_unprotect_crashkres(void)
 {
+	kexec_mark_dm_crypt_keys(false);
 	kexec_mark_crashkres(false);
 }
 #endif
_

Patches currently in -mm which might be from coxu@redhat.com are

kexec_file-allow-to-place-kexec_buf-randomly.patch
crash_dump-make-dm-crypt-keys-persist-for-the-kdump-kernel.patch
crash_dump-store-dm-crypt-keys-in-kdump-reserved-memory.patch
crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging.patch
crash_dump-retrieve-dm-crypt-keys-in-kdump-kernel.patch
revert-x86-mm-remove-unused-__set_memory_prot.patch
x86-crash-pass-dm-crypt-keys-to-kdump-kernel.patch
x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible.patch

