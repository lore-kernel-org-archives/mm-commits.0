From: akpm@linux-foundation.org
Subject: [folded] userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:25:12 -0700
Message-ID: <201103232325.p2NNPC4o004679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932910Ab1CWXZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch

This patch was dropped because it was folded into userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#108: FILE: fs/namei.c:695:
+	if (ns_capable(ns, CAP_DAC_OVERRIDE) || ns_capable(ns, CAP_DAC_READ_SEARCH))

total: 0 errors, 1 warnings, 113 lines checked

./patches/userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes fs/namei.c
--- a/fs/namei.c~userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes
+++ a/fs/namei.c
@@ -692,7 +692,8 @@ static inline int exec_permission(struct
 	if (ret == -ECHILD)
 		return ret;
 
-	if (ns_capable(ns, CAP_DAC_OVERRIDE) || ns_capable(ns, CAP_DAC_READ_SEARCH))
+	if (ns_capable(ns, CAP_DAC_OVERRIDE) ||
+			ns_capable(ns, CAP_DAC_READ_SEARCH))
 		goto ok;
 
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

