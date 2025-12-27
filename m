Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633A61C3F36;
	Thu,  1 Jan 2026 02:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767234616; cv=none; b=HNhPyRQ0Hgjd7eFBGyG0bxlamgcnmdNLQFaH87RaUBanxuRIPheUIM1wSq9NzhYqiQj6cRDVg+Ksd9J8gqHEKLAX7mQAKPBzgi190gkuIsRfhU8Z9u7vGj0qzvQ+lKnjDhBkHWrHxhqcdc71SVhWSnN+jFLl6yAbSIQdKXpHr4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767234616; c=relaxed/simple;
	bh=yesyJjTeP7/46j9ALHRJXsgThtBfbXX86v1rBAGlqLM=;
	h=Date:To:From:Subject:Message-Id; b=uYDQazbCLtOuqx0r6VNGQGJmOhbZegqVh/C7RQ2L/2YT/wTQcNS9ZJga07l4U8EVFypNnpoyqaIUTkfcGzDIJ133Sbeg4YTve5HGi/u368eCpeH6t8sq2JbgnRJSX58WqIz3v3erPoaWb/QDhVQO4Zd43JvpE/65fP1ajzksC08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=InOMa5Kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="InOMa5Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64DAC113D0;
	Thu,  1 Jan 2026 02:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767234614;
	bh=yesyJjTeP7/46j9ALHRJXsgThtBfbXX86v1rBAGlqLM=;
	h=Date:To:From:Subject:From;
	b=InOMa5Kzsjg2m0L6zC1/vhdz3g7MyChDbv188JOhLXbgd/t5tNlGC+4WivMnvQMQQ
	 bquLrntx+klxSsKhFHvNOBcutj2C5Vwvjnki5gIiHCFX5fi7DOMauCxxTpkKQyL4Xq
	 spTJZTaq7xnBCfewjz2UT0B84O01uW1bqtvold8c=
Date: Wed, 31 Dec 2025 18:30:14 +9900
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,stable@vger.kernel.org,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@fb.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,bhe@redhat.com,ardb@kernel.org,harshit.m.mogalapalli@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch added to mm-nonmm-unstable branch
Message-Id: <20260101023014.D64DAC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch

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
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
Date: Tue, 30 Dec 2025 22:16:08 -0800

Refactor the OF/DT ima_get_kexec_buffer() to use a generic helper to
validate the address range.  No functional change intended.

Link: https://lkml.kernel.org/r/20251231061609.907170-3-harshit.m.mogalapalli@oracle.com
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Jonathan McDowell <noodles@fb.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Webb <paul.x.webb@oracle.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/kexec.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/of/kexec.c~of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range
+++ a/drivers/of/kexec.c
@@ -128,7 +128,6 @@ int __init ima_get_kexec_buffer(void **a
 {
 	int ret, len;
 	unsigned long tmp_addr;
-	unsigned long start_pfn, end_pfn;
 	size_t tmp_size;
 	const void *prop;
 
@@ -144,17 +143,9 @@ int __init ima_get_kexec_buffer(void **a
 	if (!tmp_size)
 		return -ENOENT;
 
-	/*
-	 * Calculate the PFNs for the buffer and ensure
-	 * they are with in addressable memory.
-	 */
-	start_pfn = PHYS_PFN(tmp_addr);
-	end_pfn = PHYS_PFN(tmp_addr + tmp_size - 1);
-	if (!page_is_ram(start_pfn) || !page_is_ram(end_pfn)) {
-		pr_warn("IMA buffer at 0x%lx, size = 0x%zx beyond memory\n",
-			tmp_addr, tmp_size);
-		return -EINVAL;
-	}
+	ret = ima_validate_range(tmp_addr, tmp_size);
+	if (ret)
+		return ret;
 
 	*addr = __va(tmp_addr);
 	*size = tmp_size;
_

Patches currently in -mm which might be from harshit.m.mogalapalli@oracle.com are

ima-verify-the-previous-kernels-ima-buffer-lies-in-addressable-ram.patch
of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

