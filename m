Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3B322AE7F
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 20:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870010; cv=none; b=WLyXgLdGfcTz8oEOdwa3TNT3t66EwLmsISOus8RmtXbHtp8gU6DlbNqW6RAyYtMRMq9twoiTy+s3RnxnIzuFgHgZ224b1yc5ucmvc0lrCZGeGlJmNOFaMnhiem8QXn10aEKnvIaqtE6cR5l6ReMMqS1p28meUaCBmUA6HleK6NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870010; c=relaxed/simple;
	bh=O69JgtUOA6YWJdvxkOzOKTnmg28KgVpPQsihIlbJ2G0=;
	h=Date:To:From:Subject:Message-Id; b=mwlKwtt0RvOWMG5gj0aOUZ8boSoCIy013C0RZg2dBmTDo97vnlid8wsV+N05T6U9ruThyTsVNsxAI2Wl4/+75FjQZ+gSFReFvNudmcqAV8lA1ri8BFFx8HKVB5jqLCUe4cYPBgTxcKlSdGEAw6UG9VfWJVzmRSy/oG3x6HCsdBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PysrDHQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PysrDHQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAFFC4CEF1;
	Tue,  7 Oct 2025 20:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870010;
	bh=O69JgtUOA6YWJdvxkOzOKTnmg28KgVpPQsihIlbJ2G0=;
	h=Date:To:From:Subject:From;
	b=PysrDHQtwv+ZoLa8+we/ZDDmYxqRVoTVSXKMBYbZxqnxEdiV3bzO06v6kLnnTcVtl
	 p8OvIoI29WWwC91skn+ERpWZB6dPfbIwpLOJyUpPX/pYKSqbuSnT32MZDr9hP7vfuf
	 12c0cjDjAih5jI7QSq82SniTfqyAxGYf5JokBOGI=
Date: Tue, 07 Oct 2025 13:46:49 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20251007204649.ECAFFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

This patch was dropped because it was folded into kho-add-support-for-preserving-vmalloc-allocations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes
Date: Sun Sep 21 09:52:59 AM PDT 2025

ERROR: code indent should use tabs where possible
#38: FILE: include/linux/kexec_handover.h:44:
+        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);$

WARNING: please, no spaces at the start of a line
#38: FILE: include/linux/kexec_handover.h:44:
+        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);$

ERROR: code indent should use tabs where possible
#39: FILE: include/linux/kexec_handover.h:45:
+        unsigned int total_pages;$

WARNING: please, no spaces at the start of a line
#39: FILE: include/linux/kexec_handover.h:45:
+        unsigned int total_pages;$

ERROR: code indent should use tabs where possible
#40: FILE: include/linux/kexec_handover.h:46:
+        unsigned short flags;$

WARNING: please, no spaces at the start of a line
#40: FILE: include/linux/kexec_handover.h:46:
+        unsigned short flags;$

ERROR: code indent should use tabs where possible
#41: FILE: include/linux/kexec_handover.h:47:
+        unsigned short order;$

WARNING: please, no spaces at the start of a line
#41: FILE: include/linux/kexec_handover.h:47:
+        unsigned short order;$

total: 4 errors, 4 warnings, 350 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/kho-add-support-for-preserving-vmalloc-allocations.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/kexec_handover.h~kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes
+++ a/include/linux/kexec_handover.h
@@ -41,10 +41,10 @@ struct kho_serialization;
 
 struct kho_vmalloc_chunk;
 struct kho_vmalloc {
-        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
-        unsigned int total_pages;
-        unsigned short flags;
-        unsigned short order;
+	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
+	unsigned int total_pages;
+	unsigned short flags;
+	unsigned short order;
 };
 
 #ifdef CONFIG_KEXEC_HANDOVER
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations.patch

