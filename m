Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CE2289E0B
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849740; cv=none; b=nSArcd9JzegfKStCDJYT8eq6rwnTs6uHpu6MKoqy/f/0uit7TM9h18M8Ts9KrsMehO/oUUDyzIGfJlvOBWaMnePXEtTFnJIpPSlUgRfVeT2WkL5/zU3GkO9bdMCn1Y/8hl61Xdc98mG5nPp+C461YtfbgD8oign7R7Ua4zhsNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849740; c=relaxed/simple;
	bh=r27IpGmYCOFQp8U8HF/LKfnrCHv3v0x0IOIlVX5oirs=;
	h=Date:To:From:Subject:Message-Id; b=QGbnqkaltVuC5oHfNUUnGatu4j7t3NXcW77lkBsP1IB71cfzOzMIMMbKitj0D1O8OMFkv0Wu1f/avkZFNTAaNwQtMogcuj+oGBv44AdqkZn6tioPywepEQkL7ha62QK0vVpCxlvMT+GXTSYg7JQBb7nOfY0EM7UFU9yIprh6I2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SBZuNXdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SBZuNXdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD5CC4CEE4;
	Wed, 21 May 2025 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849740;
	bh=r27IpGmYCOFQp8U8HF/LKfnrCHv3v0x0IOIlVX5oirs=;
	h=Date:To:From:Subject:From;
	b=SBZuNXdd2nzKPWpJg3a2YjgX0iVF756phrPBcWjHYq5MTzRB3MK59a8AVe+XE/FDP
	 X0i/TGYSPmcATXCh7tGvSXwgUhBG1arTYdDd9qAA0CRjeYtTICA2onqEf9Bx8hoQwK
	 Z01R5d31Dji+EizkjMZ77xhjt+gIp9w+1pvpwbkY=
Date: Wed, 21 May 2025 10:48:59 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,bhe@redhat.com,berrange@redhat.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible.patch removed from -mm tree
Message-Id: <20250521174900.0BD5CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/crash: make the page that stores the dm crypt keys inaccessible
has been removed from the -mm tree.  Its filename was
     x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


