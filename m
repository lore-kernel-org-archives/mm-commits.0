Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E620C2AD03
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 20:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769027291; cv=none; b=p1uuVUnlkS+atFBRAZ1gdy6uVCj0qA852w992YrnBaO0Hliu1qS5hZcNIf5+DWDty7D1i2gMP4XLCKrWRDKQuvV9anNBLOL5sQOnxwElkeH9QPuax/xk4OWVbB6IHQWAw+RLxdeRUh+ZP+VKDvCMFDFYiB+5wyuXT2HWSQk/i/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769027291; c=relaxed/simple;
	bh=ZTuB1uBRJ47sUbLu4DVWtusbP4JOcl2pPk/LWs+NNwg=;
	h=Date:To:From:Subject:Message-Id; b=YHqiGhVwUUUdHR5PHtaOEtMdLu9sV4vLk5EAEsYfD/J3HE16R4G5AhhAnNjkJrOL7sLHPeEvDe8K+0Pd4Wimu4wYaqiOaauePI+Pl/kT5akQhec2+/XBNU+vLpC0TJsvUYR6KXgRWIZ+mnAxVZZU6iK37+FMof3LX4GyKURzCic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k6anEd7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k6anEd7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C20DC4CEF1;
	Wed, 21 Jan 2026 20:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769027290;
	bh=ZTuB1uBRJ47sUbLu4DVWtusbP4JOcl2pPk/LWs+NNwg=;
	h=Date:To:From:Subject:From;
	b=k6anEd7vCq28ooTQINFn89EIVScX0dYbW0LFL10Asg+Q/NFXAW8WtuPfas483Csg0
	 gPmEW025eM8wBKzGQHLkgSpXUiXWcdXoG6bdqbFHsU5uq6cwnniDjDY4Mi10MpY9p9
	 QDZ1Ao0mlAINTfS2rpU/Dtg0QTb5fzc6FRHMDQb8=
Date: Wed, 21 Jan 2026 12:28:09 -0800
To: mm-commits@vger.kernel.org,xueshuai@linux.alibaba.com,vgoyal@redhat.com,tony.luck@intel.com,osandov@osandov.com,dyoung@redhat.com,bhe@redhat.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcoreinfo-make-hwerr_data-visible-for-debugging.patch added to mm-nonmm-unstable branch
Message-Id: <20260121202810.4C20DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmcoreinfo: make hwerr_data visible for debugging
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     vmcoreinfo-make-hwerr_data-visible-for-debugging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcoreinfo-make-hwerr_data-visible-for-debugging.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: vmcoreinfo: make hwerr_data visible for debugging
Date: Wed, 21 Jan 2026 03:05:44 -0800

If the kernel is compiled with LTO, hwerr_data symbol might be lost, and
vmcoreinfo doesn't have it dumped. This is currently seen in some
production kernels with LTO enabled.

Remove the static qualifier from hwerr_data so that the information is
still preserved when the kernel is built with LTO. Making hwerr_data
a global symbol ensures its debug info survives the LTO link process and
appears in kallsyms.

Link: https://lkml.kernel.org/r/20260121-fix_vmcoreinfo-v1-1-39e96fab670e@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/vmcore_info.c~vmcoreinfo-make-hwerr_data-visible-for-debugging
+++ a/kernel/vmcore_info.c
@@ -36,7 +36,7 @@ struct hwerr_info {
 	time64_t timestamp;
 };
 
-static struct hwerr_info hwerr_data[HWERR_RECOV_MAX];
+struct hwerr_info hwerr_data[HWERR_RECOV_MAX];
 
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
 			  void *data, size_t data_len)
_

Patches currently in -mm which might be from leitao@debian.org are

vmcoreinfo-make-hwerr_data-visible-for-debugging.patch

