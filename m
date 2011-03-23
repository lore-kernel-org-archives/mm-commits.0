From: akpm@linux-foundation.org
Subject: + fs-adfs-adfsh-fix-unsigned-comparison-fix.patch added to -mm tree
Date: Wed, 23 Mar 2011 16:13:52 -0700
Message-ID: <201103232313.p2NNDqvV004028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933139Ab1CWXOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, rmk+kernel@arm.linux.org.uk, stuart.swales.croftnuisk@gmail.com


The patch titled
     fs-adfs-adfsh-fix-unsigned-comparison-fix
has been added to the -mm tree.  Its filename is
     fs-adfs-adfsh-fix-unsigned-comparison-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-adfs-adfsh-fix-unsigned-comparison-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/adfs/adfs.h~fs-adfs-adfsh-fix-unsigned-comparison-fix fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~fs-adfs-adfsh-fix-unsigned-comparison-fix
+++ a/fs/adfs/adfs.h
@@ -112,7 +112,7 @@ struct object_info {
 /* RISC OS 12-bit filetype converts to ,xyz hex filename suffix */
 static inline int append_filetype_suffix(char *buf, __u16 filetype)
 {
-	if (filetype == (__u16)-1)
+	if (filetype == 0xffff)	/* no explicit 12-bit file type was set */
 		return 0;
 
 	*buf++ = ',';
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
fs-adfs-adfsh-fix-unsigned-comparison-fix.patch
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

