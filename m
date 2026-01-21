Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159FA356A14;
	Wed, 21 Jan 2026 03:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967374; cv=none; b=AnsGCaS7st0qxDzpLz63uM1fDKjxwHEUIPHdGltdod6Z8m8uXq15dXA/yeO9lwerZWyoY8ImHKNMyL9UolyoCXIZoETaxLnyKICfMn10+ybblnOX3raCWUpanUqKViCuCJjhF2vzf/vorvNlXK/2PJFPibbPUdM0q/aNPERtICk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967374; c=relaxed/simple;
	bh=aXmLCLM5kogFA44Em6xRADnBBrNJhE1TLo+xlLhbrtM=;
	h=Date:To:From:Subject:Message-Id; b=CUD3OfVJB5RLwEIC2qLrxSy/PcU44jo+I8g+W4unAlOI/5XMLLx9aw+hJBuPU48w6qrrEeVYM9TZ85MPKdPA0JGxjOD33eULSCM45Ky2WZq4JGMnyXPUtL3Ke/99IeGI5XosPM4xT6YbfYxfUKD76F/aEPKkokJwDy5CXTADuFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FEgd1qa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FEgd1qa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D44C19423;
	Wed, 21 Jan 2026 03:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967373;
	bh=aXmLCLM5kogFA44Em6xRADnBBrNJhE1TLo+xlLhbrtM=;
	h=Date:To:From:Subject:From;
	b=FEgd1qa/C1112WjhA/32BNTSqWYmiDiwlJzTRLAm4nH0//hYl+Iz+N4OjGPyHJenG
	 gRsAQ+DMsvGyuIhhUFteMlSBkm0FaS1uLjCKdul20iIEgYh03xk/nYQYHvUjWoRYz6
	 nXxdB3wB/d1KaH3eXu+Zw6di7zrn8fxPLqLcVGNM=
Date: Tue, 20 Jan 2026 19:49:33 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,stable@vger.kernel.org,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@fb.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,bhe@redhat.com,ardb@kernel.org,harshit.m.mogalapalli@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch removed from -mm tree
Message-Id: <20260121034933.D5D44C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
has been removed from the -mm tree.  Its filename was
     of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


