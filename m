Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74259134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418002; cv=none; b=iobvEGR0OY2FmJGbVwQz6H6qWTGaORb1FZbn5qNdEsyyqVWHAf03kyc+ucyH3LGiFDiVRo9ULI+xOZm6ubjhqkXLXu77TDngOCURVMHKjNMg7YroVi22Z3YJRUT/ArgJ4HwOiee6MHun/24dc9KS+y6z3V0fai9z9l0Hu1fAu4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418002; c=relaxed/simple;
	bh=Ek1gdQqaefUKdAp2k3E23H77Tm8PLJ5EK0KSiaNs6Jw=;
	h=Date:To:From:Subject:Message-Id; b=q3P3BlFBC6ZZXMcMpTfSw6bwXqz4SUjL0ZyIl9oyKS2bO6CfY9Q8rWrXnhHNYKJ2v/IQZLld/0MrECEPjiMF4KVMVlQHyB2fXPPummJCHKW9iUs97EBbPWX5YJVesRPcq0NrT7uHP6+RiZNkM3qG4lEV1NKdz8VefzM7iXyS/00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dp0Gxoms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dp0Gxoms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401D2C4CEE2;
	Sat, 12 Apr 2025 00:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418002;
	bh=Ek1gdQqaefUKdAp2k3E23H77Tm8PLJ5EK0KSiaNs6Jw=;
	h=Date:To:From:Subject:From;
	b=dp0GxomsD3Dl+QbzH8Y1InegjZ81yw81/Czlb2uwiJeUTVW+nw+3/ZMewB2L4UI94
	 TfQFN0dAKbZUubeONVn7e5UKFJAcMmQTZhJgff6EfqERTwhGE8AdMgiPYicrQaw8Q9
	 dyygIzYzEtJop9+72l5lng6e1et0rt+JnAJ3QXGw=
Date: Fri, 11 Apr 2025 17:33:21 -0700
To: mm-commits@vger.kernel.org,horms@kernel.org,ebiederm@xmission.com,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-andrew-and-myself-as-kexec-maintainer.patch removed from -mm tree
Message-Id: <20250412003322.401D2C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Andrew and Baoquan as kexec maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-add-andrew-and-myself-as-kexec-maintainer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: MAINTAINERS: add Andrew and Baoquan as kexec maintainers
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
@@ -12810,6 +12810,7 @@ F:	lib/Kconfig.kcsan
 F:	scripts/Makefile.kcsan
 
 KDUMP
+M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Baoquan He <bhe@redhat.com>
 R:	Vivek Goyal <vgoyal@redhat.com>
 R:	Dave Young <dyoung@redhat.com>
@@ -13111,6 +13112,8 @@ F:	fs/kernfs/
 F:	include/linux/kernfs.h
 
 KEXEC
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Baoquan He <bhe@redhat.com>
 L:	kexec@lists.infradead.org
 W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 F:	include/linux/kexec.h
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch
mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch

