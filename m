From: akpm@linux-foundation.org
Subject: - arch-um-kernel-um_archc-some-small-improvements.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:46 -0700
Message-ID: <200804282154.m3SLskuP018040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934249AbYD1Vyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     arch/um/kernel/um_arch.c: some small improvements
has been removed from the -mm tree.  Its filename was
     arch-um-kernel-um_archc-some-small-improvements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um/kernel/um_arch.c: some small improvements
From: WANG Cong <xiyou.wangcong@gmail.com>

Make some small improvements for arch/um/kernel/um_arch.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/um_arch.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/um/kernel/um_arch.c~arch-um-kernel-um_archc-some-small-improvements arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~arch-um-kernel-um_archc-some-small-improvements
+++ a/arch/um/kernel/um_arch.c
@@ -115,7 +115,7 @@ static int have_root __initdata = 0;
 /* Set in uml_mem_setup and modified in linux_main */
 long long physmem_size = 32 * 1024 * 1024;
 
-static char *usage_string =
+static const char *usage_string =
 "User Mode Linux v%s\n"
 "	available at http://user-mode-linux.sourceforge.net/\n\n";
 
@@ -202,7 +202,7 @@ static void __init uml_checksetup(char *
 
 	p = &__uml_setup_start;
 	while (p < &__uml_setup_end) {
-		int n;
+		size_t n;
 
 		n = strlen(p->str);
 		if (!strncmp(line, p->str, n) && p->setup_func(line + n, add))
@@ -258,7 +258,8 @@ int __init linux_main(int argc, char **a
 {
 	unsigned long avail, diff;
 	unsigned long virtmem_size, max_physmem;
-	unsigned int i, add;
+	unsigned int i;
+	int add;
 	char * mode;
 
 	for (i = 1; i < argc; i++) {
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
remove-the-macro-get_personality.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch

