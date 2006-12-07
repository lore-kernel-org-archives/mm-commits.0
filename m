From: akpm@osdl.org
Subject: - elf-include-terminating-zero-in-n_namesz.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:12 -0800
Message-ID: <200612072305.kB7N5CIQ030129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52419 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163887AbWLGXFc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus@valinux.co.jp, drow@false.org, jakub@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     elf: include terminating zero in n_namesz
has been removed from the -mm tree.  Its filename was
     elf-include-terminating-zero-in-n_namesz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: elf: include terminating zero in n_namesz
From: Magnus Damm <magnus@valinux.co.jp>

The ELF32 spec says we should plus we include the zero on other platforms.

Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Cc: Daniel Jacobowitz <drow@false.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/kernel/irixelf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/kernel/irixelf.c~elf-include-terminating-zero-in-n_namesz arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~elf-include-terminating-zero-in-n_namesz
+++ a/arch/mips/kernel/irixelf.c
@@ -1009,7 +1009,7 @@ static int notesize(struct memelfnote *e
 	int sz;
 
 	sz = sizeof(struct elf_note);
-	sz += roundup(strlen(en->name), 4);
+	sz += roundup(strlen(en->name) + 1, 4);
 	sz += roundup(en->datasz, 4);
 
 	return sz;
@@ -1028,7 +1028,7 @@ static int writenote(struct memelfnote *
 {
 	struct elf_note en;
 
-	en.n_namesz = strlen(men->name);
+	en.n_namesz = strlen(men->name) + 1;
 	en.n_descsz = men->datasz;
 	en.n_type = men->type;
 
_

Patches currently in -mm which might be from magnus@valinux.co.jp are

origin.patch

