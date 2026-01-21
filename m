Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C87733F37F
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 20:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769027293; cv=none; b=eJNsp+2QlFkQ0fiEfIK04NKl1Txty1MFqaLY3yQNQeQp+slHabmQrFjsh6tPdp1DlijNU5lwJ5SQrEav2CesK63dAukqXNPWjOnruoa/sfVNlcBUzwaTzXNPPAyEt7EzdwbF82vRne6qlJvwrZe+DNexZT2rgIOahHIWYwfWgLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769027293; c=relaxed/simple;
	bh=rve6S30OQ09Gewx1+hPRugkhxzfwi7f+XLS/126W5Mg=;
	h=Date:To:From:Subject:Message-Id; b=DnmsfSpTTno3jJ4wIZZRIGCwkInhIKRIfB0UUcjaMXGCwZ/8I8+Gj95KTPVVe4aO563+1DZwiOoSq1fmtrcYWEi+jz4Ap/wgj1+8bjn9U6+sBInmGLDQ0E2fXeGr9rDCydn4L9cWklMvY142SaHLhvcccnXErQN5ztQwQUcbniA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ORKIgq7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ORKIgq7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8191CC4CEF1;
	Wed, 21 Jan 2026 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769027292;
	bh=rve6S30OQ09Gewx1+hPRugkhxzfwi7f+XLS/126W5Mg=;
	h=Date:To:From:Subject:From;
	b=ORKIgq7e+/jxT0UBthyvg4V4lHO2zmWWV9skwo8VH2ur4iq6ERgX6ViKpqy0OUwVk
	 qvOnn62bCXFOUrJuHWMl7wbsgFoVP4g3WLGbYuABo5DlYMDV24dp0JVT/4/N7m4rUb
	 3zRIjLoDcLZWxkiVoJC9sA1ovDqqIu7kctg/Oxlo=
Date: Wed, 21 Jan 2026 12:28:11 -0800
To: mm-commits@vger.kernel.org,xueshuai@linux.alibaba.com,vgoyal@redhat.com,tony.luck@intel.com,osandov@osandov.com,leitao@debian.org,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcoreinfo-make-hwerr_data-visible-for-debugging-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260121202812.8191CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmcoreinfo-make-hwerr_data-visible-for-debugging-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     vmcoreinfo-make-hwerr_data-visible-for-debugging-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcoreinfo-make-hwerr_data-visible-for-debugging-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmcoreinfo-make-hwerr_data-visible-for-debugging-fix
Date: Wed Jan 21 12:23:52 PM PST 2026

add comment

Cc: Baoquan He <bhe@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/vmcore_info.c~vmcoreinfo-make-hwerr_data-visible-for-debugging-fix
+++ a/kernel/vmcore_info.c
@@ -36,6 +36,7 @@ struct hwerr_info {
 	time64_t timestamp;
 };
 
+/* hwerr_data[] has global scope to make it available in vmcoreinfo under LTO */
 struct hwerr_info hwerr_data[HWERR_RECOV_MAX];
 
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
vmcoreinfo-make-hwerr_data-visible-for-debugging-fix.patch

