Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324B53375C3;
	Mon,  1 Dec 2025 17:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764609661; cv=none; b=GIk9hWb9i6VJlQVcOwZMyW2WFLZ2LNAnMElhNgVDKRryh0xLNauoA+HHUxeQnulpTQ5t39vl0edrlAPXXzwP3RrhgX/98CfFC2Ja82DzddkoQQXj8u+mbLO/lYhrmBmCg2xlRwZgUDDY6aYGrSLRfEZ7k5pz+WlvShbeiEuzklo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764609661; c=relaxed/simple;
	bh=YjqGVlcCfWyEbxh0RRs+50ii27BecvGZxiLwu/4SQ58=;
	h=Date:To:From:Subject:Message-Id; b=nVLFc54vWycNS/y1tDvWQhgE8KoakFJV0yX+86iUwisOYm4dC4F5WKAdoA87eZqNpO21LDp5NK6JoFe3D9Y5a/gVrRgUXzC7Ylnb0GwbQb9cFtYCSq+iUxE3nU27F2s6mNnD7hBUG592gEHLoPNFu3dg8Lk7+EOp8TgKr2uVTJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pAGue5XD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pAGue5XD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F088EC4CEF1;
	Mon,  1 Dec 2025 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764609661;
	bh=YjqGVlcCfWyEbxh0RRs+50ii27BecvGZxiLwu/4SQ58=;
	h=Date:To:From:Subject:From;
	b=pAGue5XDBpl2FGq96Bg7Tq3OQT1HiVYvqOVzXCMeuDKG6httWV6BOIZ6pkCkGvsFc
	 mE81QoF0A35rIkZrUWNjLYPAfw2EDqv4z0atRdfHcE5eAV7D8HPuzbITCA/vRgtiH5
	 lKvsxGqA3b1Qd/leTu+ZQfFG+0pRgq7DQ0d6X9Xw=
Date: Mon, 01 Dec 2025 09:21:00 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,stable@vger.kernel.org,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@meta.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,ardb@kernel.org,harshit.m.mogalapalli@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch added to mm-hotfixes-unstable branch
Message-Id: <20251201172100.F088EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: add a sanity check on previous kernel's ima kexec buffer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

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
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: x86/kexec: add a sanity check on previous kernel's ima kexec buffer
Date: Wed, 12 Nov 2025 11:30:02 -0800

When the second-stage kernel is booted via kexec with a limiting command
line such as "mem=<size>", the physical range that contains the carried
over IMA measurement list may fall outside the truncated RAM leading to a
kernel panic.

    BUG: unable to handle page fault for address: ffff97793ff47000
    RIP: ima_restore_measurement_list+0xdc/0x45a
    #PF: error_code(0x0000) – not-present page

Other architectures already validate the range with page_is_ram(), as done
in commit: cbf9c4b9617b ("of: check previous kernel's ima-kexec-buffer
against memory bounds") do a similar check on x86.

Link: https://lkml.kernel.org/r/20251112193005.3772542-1-harshit.m.mogalapalli@oracle.com
Fixes: b69a2afd5afc ("x86/kexec: Carry forward IMA measurement log on kexec")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reported-by: Paul Webb <paul.x.webb@oracle.com>
Reviewed-by: Jonathan McDowell <noodles@meta.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/x86/kernel/setup.c~x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer
+++ a/arch/x86/kernel/setup.c
@@ -439,9 +439,23 @@ int __init ima_free_kexec_buffer(void)
 
 int __init ima_get_kexec_buffer(void **addr, size_t *size)
 {
+	unsigned long start_pfn, end_pfn;
+
 	if (!ima_kexec_buffer_size)
 		return -ENOENT;
 
+	/*
+	 * Calculate the PFNs for the buffer and ensure
+	 * they are with in addressable memory.
+	 */
+	start_pfn = PFN_DOWN(ima_kexec_buffer_phys);
+	end_pfn = PFN_DOWN(ima_kexec_buffer_phys + ima_kexec_buffer_size - 1);
+	if (!pfn_range_is_mapped(start_pfn, end_pfn)) {
+		pr_warn("IMA buffer at 0x%llx, size = 0x%zx beyond memory\n",
+			ima_kexec_buffer_phys, ima_kexec_buffer_size);
+		return -EINVAL;
+	}
+
 	*addr = __va(ima_kexec_buffer_phys);
 	*size = ima_kexec_buffer_size;
 
_

Patches currently in -mm which might be from harshit.m.mogalapalli@oracle.com are

x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

