Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A1B2E62A2
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 22:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743718057; cv=none; b=kGZi2F1Dg77Zf7USlj3dZ5U9auaRqdznE0vJfFVi7lY9a/FfmAEdYyQxOhGJVHZky6ouvJ9ykJLmzIcAgnKep6HhNNrrjVn1SUx97DMguoZMMdv84F6iwIB14GpgXjtSfXcFrSiu8UxtGOOIo5dZDi3u0JF2AmU+qboXU1NFGTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743718057; c=relaxed/simple;
	bh=HsQdDyBesXVwwhmGdwfkcjDwEcns3qJfL2Y82B2pj4U=;
	h=Date:To:From:Subject:Message-Id; b=rgJcg4obGSXeIwC07ehJSD7S7kT5kiQORpc0kqoKlM5ExBQFwWj4CQpEPCvLZr3tc1vlcP3AMkfCzOfnqg4soyFGiAsFrrWB26GG5FvTyVeDTcXJu+Ljh3iwFHsK2iwZaMJBPPX3AZH/5yUGAe0FThN6tea8W8JC5NpG3df1O/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjgfmzXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjgfmzXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA52C4CEE3;
	Thu,  3 Apr 2025 22:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743718057;
	bh=HsQdDyBesXVwwhmGdwfkcjDwEcns3qJfL2Y82B2pj4U=;
	h=Date:To:From:Subject:From;
	b=GjgfmzXiyLEyXY4Fz/Vkm2ugD1m3/aBRkfMDw14R9DdIWEQGDEs6/v5rGUOSPEjog
	 CwdlP5MwVdwK25QtEIJeY2w/HtqZBIndwdOuDChRhicQdrIChXJHX2eM8t9M2+Uk66
	 Tphoylx6flM0Vt0DpgKEN4SzaqVQglaxZt+hGxhs=
Date: Thu, 03 Apr 2025 15:07:36 -0700
To: mm-commits@vger.kernel.org,horms@kernel.org,ebiederm@xmission.com,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-andrew-and-myself-as-kexec-maintainer.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403220736.ECA52C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: Add Andrew and Baoquan as kexec maintainers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-andrew-and-myself-as-kexec-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-andrew-and-myself-as-kexec-maintainer.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: MAINTAINERS: Add Andrew and Baoquan as kexec maintainers
Date: Fri, 28 Mar 2025 18:44:02 +0800

Add Andrew as kexec/kdump maintainer because he has been helping review
and merge ready kexec/kdump patches.

And I would like to nominate myself as kexec maintainer because I always
try to review generic kexec codes.

Link: https://lkml.kernel.org/r/20250328104402.16826-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Acked-by: Simon Horman <horms@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-andrew-and-myself-as-kexec-maintainer
+++ a/MAINTAINERS
@@ -12818,6 +12818,7 @@ F:	lib/Kconfig.kcsan
 F:	scripts/Makefile.kcsan
 
 KDUMP
+M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Baoquan He <bhe@redhat.com>
 R:	Vivek Goyal <vgoyal@redhat.com>
 R:	Dave Young <dyoung@redhat.com>
@@ -13118,6 +13119,8 @@ F:	fs/kernfs/
 F:	include/linux/kernfs.h
 
 KEXEC
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Baoquan He <bhe@redhat.com>
 L:	kexec@lists.infradead.org
 W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 F:	include/linux/kexec.h
_

Patches currently in -mm which might be from bhe@redhat.com are

maintainers-add-andrew-and-myself-as-kexec-maintainer.patch
mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-check-if-both-gup_get-and-gup_pin-are-set-in-__get_user_pages-earlier.patch
mm-gup-fix-the-outdated-code-comments-above-get_user_pages_unlocked.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
x86-mm-remove-pgd_leaf-definition-in-arch.patch
x86-mm-remove-p4d_leaf-definition.patch
mm-pgtable-remove-unneeded-pgd_devmap.patch

