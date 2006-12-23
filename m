From: akpm@osdl.org
Subject: - audit-fix-kstrdup-error-check.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:22 -0800
Message-ID: <200612230754.kBN7sMeb010206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbWLWHy1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dwmw2@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: fix kstrdup() error check
has been removed from the -mm tree.  Its filename was
     audit-fix-kstrdup-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: audit: fix kstrdup() error check
From: Akinobu Mita <akinobu.mita@gmail.com>

kstrdup() returns NULL on error.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/auditfilter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditfilter.c~audit-fix-kstrdup-error-check kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-fix-kstrdup-error-check
+++ a/kernel/auditfilter.c
@@ -800,8 +800,8 @@ static inline int audit_dupe_selinux_fie
 
 	/* our own copy of se_str */
 	se_str = kstrdup(sf->se_str, GFP_KERNEL);
-	if (unlikely(IS_ERR(se_str)))
-	    return -ENOMEM;
+	if (unlikely(!se_str))
+		return -ENOMEM;
 	df->se_str = se_str;
 
 	/* our own (refreshed) copy of se_rule */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
powerpc-use-is_init.patch
git-dvb.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
git-input.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

