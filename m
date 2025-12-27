Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DBF17A305;
	Thu,  1 Jan 2026 02:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767234617; cv=none; b=MJyHZl+8kNOnJc+7JvxuKIxz7gycgOZSJrpki2bNIrf5BG1bFvEByae4gLbPkzsHgAn1DNVOnnLWZT36Rgn30m/ljW1Rfek0FCcJ4pbV/mOOjIX18tmSVEF3PmhsVZhT0M4p8GMeo6czC3PQ86JGyQUSi+74WzaUZXth+p3YCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767234617; c=relaxed/simple;
	bh=tDxrmcJt/4fl84n5cWJZNV5peEV826otlarUz+4zYTg=;
	h=Date:To:From:Subject:Message-Id; b=blOslyjAG2FCKl8eaMrAyqsmr0rIgQ3vQIs3FImQg7eUlKd/HfpN9oR05XkEo+fMoLUiZo3+BeRvRsu7cYIlPQUgcFQ2mqjYtVPtDxVuk3Pnl1Hl4QnrPG63IdVWh1tycWdoIUSRNPt13X0M0T4aIqcZeX5jxhGPwgiSn5FxsG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NNsM2Mjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NNsM2Mjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D553C113D0;
	Thu,  1 Jan 2026 02:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767234617;
	bh=tDxrmcJt/4fl84n5cWJZNV5peEV826otlarUz+4zYTg=;
	h=Date:To:From:Subject:From;
	b=NNsM2MjsEI3e4GZoB0q/fMffO3nkQ/ICpG7AzVyzUEr6vKKSot36JFtbGSuDBZiiL
	 gp1yVyzvzLratTrv72lmdumYrwz5rVpTa9W4rN0pXn2Q07gaaPilfMOoKEaMkRGrtM
	 xSRCvupYqfWxdcJ+XykXVtmUFmZiBMZDNaoF1IfQ=
Date: Wed, 31 Dec 2025 18:30:16 +9900
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,stable@vger.kernel.org,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@fb.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,bhe@redhat.com,ardb@kernel.org,harshit.m.mogalapalli@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch added to mm-nonmm-unstable branch
Message-Id: <20260101023017.0D553C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: add a sanity check on previous kernel's ima kexec buffer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

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
Subject: x86/kexec: add a sanity check on previous kernel's ima kexec buffer
Date: Tue, 30 Dec 2025 22:16:09 -0800

When the second-stage kernel is booted via kexec with a limiting command
line such as "mem=<size>", the physical range that contains the carried
over IMA measurement list may fall outside the truncated RAM leading to a
kernel panic.

    BUG: unable to handle page fault for address: ffff97793ff47000
    RIP: ima_restore_measurement_list+0xdc/0x45a
    #PF: error_code(0x0000) – not-present page

Other architectures already validate the range with page_is_ram(), as done
in commit cbf9c4b9617b ("of: check previous kernel's ima-kexec-buffer
against memory bounds") do a similar check on x86.

Without carrying the measurement list across kexec, the attestation
would fail.

Link: https://lkml.kernel.org/r/20251231061609.907170-4-harshit.m.mogalapalli@oracle.com
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Fixes: b69a2afd5afc ("x86/kexec: Carry forward IMA measurement log on kexec")
Reported-by: Paul Webb <paul.x.webb@oracle.com>
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
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/setup.c~x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer
+++ a/arch/x86/kernel/setup.c
@@ -439,9 +439,15 @@ int __init ima_free_kexec_buffer(void)
 
 int __init ima_get_kexec_buffer(void **addr, size_t *size)
 {
+	int ret;
+
 	if (!ima_kexec_buffer_size)
 		return -ENOENT;
 
+	ret = ima_validate_range(ima_kexec_buffer_phys, ima_kexec_buffer_size);
+	if (ret)
+		return ret;
+
 	*addr = __va(ima_kexec_buffer_phys);
 	*size = ima_kexec_buffer_size;
 
_

Patches currently in -mm which might be from harshit.m.mogalapalli@oracle.com are

ima-verify-the-previous-kernels-ima-buffer-lies-in-addressable-ram.patch
of-kexec-refactor-ima_get_kexec_buffer-to-use-ima_validate_range.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer.patch

