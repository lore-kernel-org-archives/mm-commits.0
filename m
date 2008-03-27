From: akpm@linux-foundation.org
Subject: - give-futex-init-a-proper-name.patch removed from -mm tree
Date: Thu, 27 Mar 2008 15:45:51 -0700
Message-ID: <200803272245.m2RMjpIY025727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbYC0Wq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 18:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@ozlabs.org, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Give futex init a proper name
has been removed from the -mm tree.  Its filename was
     give-futex-init-a-proper-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Give futex init a proper name
From: Benjamin Herrenschmidt <benh@ozlabs.org>

The futex init function is called init(). This is a pain in the neck
when debugging when you code dies in ... init :-)

This renames it to futex_init().

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/futex.c~give-futex-init-a-proper-name kernel/futex.c
--- a/kernel/futex.c~give-futex-init-a-proper-name
+++ a/kernel/futex.c
@@ -2158,7 +2158,7 @@ static struct file_system_type futex_fs_
 	.kill_sb	= kill_anon_super,
 };
 
-static int __init init(void)
+static int __init futex_init(void)
 {
 	u32 curval;
 	int i;
@@ -2194,4 +2194,4 @@ static int __init init(void)
 
 	return 0;
 }
-__initcall(init);
+__initcall(futex_init);
_

Patches currently in -mm which might be from benh@ozlabs.org are

origin.patch
pata_sil680-only-enable-mmio-on-cell-blades.patch

