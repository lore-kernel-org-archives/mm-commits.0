From: akpm@linux-foundation.org
Subject: [folded] userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:25:34 -0700
Message-ID: <201103232325.p2NNPYBH004691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1CWX0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix
has been removed from the -mm tree.  Its filename was
     userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch

This patch was dropped because it was folded into userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix
+++ a/fs/nilfs2/ioctl.c
@@ -113,7 +113,7 @@ static int nilfs_ioctl_setflags(struct i
 	unsigned int flags, oldflags;
 	int ret;
 
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
 	if (get_user(flags, (int __user *)argp))
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
userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

