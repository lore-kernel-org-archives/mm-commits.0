Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C7A7405A
	for <mm-commits@vger.kernel.org>; Sun, 31 Aug 2025 19:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756668934; cv=none; b=GI8hw7IzGgkKpOWHfq+YW9M5HyIpaVPuAUhlVGqkgo9HSgvrRU5HsrpIszxlWnKdPeZ5tmg4HzeWnc7b+h6gJQyPRmt6MK6iEZXdzLsoWx5krA/nfPK71NWb4bQhMb6Q7/0j9MxOW2B41GWX3v2GF3B2p91a2erOPyQQRSmxiVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756668934; c=relaxed/simple;
	bh=e982pYAg7NY0xZrSdgHI2BAWoFQa/Zi9naB3uaeja80=;
	h=Date:To:From:Subject:Message-Id; b=fjryKEdjIE10HaGLB4WctpnZ9SOpkeNo1++KTuQXVIZTKk+exvPxUmwZzZHEbAuyroKvhz5YcPlmnfmjixZsnb2WbmN6NTf1q0wCY1Bub18FRZ4GToXv/SSbV0fQeEdro6rq69OsnSMz6nvSEDTu6uKPfIQ2Lm9jG0WfGjVFCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uS6rHZtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uS6rHZtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DF1C4CEED;
	Sun, 31 Aug 2025 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756668934;
	bh=e982pYAg7NY0xZrSdgHI2BAWoFQa/Zi9naB3uaeja80=;
	h=Date:To:From:Subject:From;
	b=uS6rHZtMwrGPRSW3XL6cEEgv5OU9a08ELCge/nlB3pMTfnYZr5P25/sHSz2mFfEu+
	 u5L6pLqz10QKRXSKcX/kZpB14DEYovgkK7dWO0We8kI6D7WRxVN5zzAan+PK3PbzZN
	 CCGUkwZrWvpiq1WRVyx4q5B4mMMg5KIaoe20lAnI=
Date: Sun, 31 Aug 2025 12:35:33 -0700
To: mm-commits@vger.kernel.org,joeypabalinas@gmail.com,hughd@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-move-mfd_all_flags-definition-to-memfdh.patch added to mm-new branch
Message-Id: <20250831193534.11DF1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memfd: move MFD_ALL_FLAGS definition to memfd.h
has been added to the -mm mm-new branch.  Its filename is
     memfd-move-mfd_all_flags-definition-to-memfdh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-move-mfd_all_flags-definition-to-memfdh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memfd: move MFD_ALL_FLAGS definition to memfd.h
Date: Sun Aug 31 12:29:57 PM PDT 2025

It's not part of the UAPI, but putting it here is better from a
maintainability POV.
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joey Pabalinas <joeypabalinas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/memfd.h |    2 ++
 mm/memfd.c                 |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/memfd.h~memfd-move-mfd_all_flags-definition-to-memfdh
+++ a/include/uapi/linux/memfd.h
@@ -12,6 +12,8 @@
 #define MFD_NOEXEC_SEAL		0x0008U
 /* executable */
 #define MFD_EXEC		0x0010U
+#define MFD_ALL_FLAGS		(MFD_CLOEXEC | MFD_ALLOW_SEALING | \
+				 MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
 
 /*
  * Huge page size encoding when MFD_HUGETLB is specified, and a huge page
--- a/mm/memfd.c~memfd-move-mfd_all_flags-definition-to-memfdh
+++ a/mm/memfd.c
@@ -313,8 +313,6 @@ long memfd_fcntl(struct file *file, unsi
 #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
 #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
 
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
-
 static int check_sysctl_memfd_noexec(unsigned int *flags)
 {
 #ifdef CONFIG_SYSCTL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch

