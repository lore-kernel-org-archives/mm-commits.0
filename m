From: akpm@linux-foundation.org
Subject: - alpha-handle-kcalloc-failure.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:25 -0700
Message-ID: <200804282154.m3SLsP1F018007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935940AbYD1VzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim@meyering.net, ink@jurassic.park.msu.ru, meyering@redhat.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: handle kcalloc failure
has been removed from the -mm tree.  Its filename was
     alpha-handle-kcalloc-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: handle kcalloc failure
From: Jim Meyering <jim@meyering.net>

arch/alpha/kernel/module.c (module_frob_arch_sections): Handle kcalloc failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/module.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/alpha/kernel/module.c~alpha-handle-kcalloc-failure arch/alpha/kernel/module.c
--- a/arch/alpha/kernel/module.c~alpha-handle-kcalloc-failure
+++ a/arch/alpha/kernel/module.c
@@ -120,6 +120,12 @@ module_frob_arch_sections(Elf64_Ehdr *hd
 
 	nsyms = symtab->sh_size / sizeof(Elf64_Sym);
 	chains = kcalloc(nsyms, sizeof(struct got_entry), GFP_KERNEL);
+	if (!chains) {
+		printk(KERN_ERR
+		       "module %s: no memory for symbol chain buffer\n",
+		       me->name);
+		return -ENOMEM;
+	}
 
 	got->sh_size = 0;
 	got->sh_addralign = 8;
_

Patches currently in -mm which might be from jim@meyering.net are

origin.patch
git-v9fs.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch

