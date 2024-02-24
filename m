Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277851870
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738824; cv=none; b=YA8mh6CCm35C2lHdBjZ0JwhJD7s3J6QUSlelTv5Aq0IMZsVrwuT/gU1vdcph4q4tDfOAFgsQgU5+ptPyyyRoWpV9zipxb9pAb4hPtb+V37Z/t5dU03VHsVJfBUCI4c98TpNX9LMSuzBDRNhPZOEPjwzOPCaOsTnu50CODF/nYH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738824; c=relaxed/simple;
	bh=NCbGWhOS43e8Bfw7DWJMdmy3M5XfaPHogL4S8Y7RE30=;
	h=Date:To:From:Subject:Message-Id; b=uGlKCbvEufB5fIwPnWsEL5wAqVtBmnheN+kG0wCyNLyoQYyfwiR85ywnQO3600u53iieF6JwRdfPFgDHHGqNlgDn4xqcgJADb3mwkDTqYZbcctcZCuXVvVEAwZxIZhjndokC+KKErEdAQGkWq31rcvcOmLjw6FmbiY488KjMYuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lUCQoopx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lUCQoopx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E995C433F1;
	Sat, 24 Feb 2024 01:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738823;
	bh=NCbGWhOS43e8Bfw7DWJMdmy3M5XfaPHogL4S8Y7RE30=;
	h=Date:To:From:Subject:From;
	b=lUCQoopxBVMhufoIyCOGOBNBjlNvXFtmWe4QTx4i3HurFp3TC6//cDrtVotOtVywr
	 YbrbcUc+b1rVN1mDSw/EUVCBQC2tGkLO/a66N50bjR3DwWsmi3vDMnKLBf256Uh1sY
	 +0rv3DKVcj4MhZtTIZn0UpKcbsNUK3xFO0f1i6Hc=
Date: Fri, 23 Feb 2024 17:40:23 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch removed from -mm tree
Message-Id: <20240224014023.7E995C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix
has been removed from the -mm tree.  Its filename was
     kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch

This patch was dropped because it was folded into kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix
Date: Sun Jan 28 10:00:15 PM PST 2024

s/CRASH_RESEERVE/CRASH_RESERVE/, per Klara Modin

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig~kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix
+++ a/arch/x86/Kconfig
@@ -2106,7 +2106,7 @@ config ARCH_SUPPORTS_CRASH_HOTPLUG
 	def_bool y
 
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
-	def_bool CRASH_RESEERVE
+	def_bool CRASH_RESERVE
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EXPERT || CRASH_DUMP)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch

