From: akpm@linux-foundation.org
Subject: - powerpc-stop-the-toc-overflowing-for-large-builds.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:14 -0800
Message-ID: <200712202337.lBKNbErI018872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759117AbXLTXsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, benh@kernel.crashing.org, kamalesh@linux.vnet.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: stop the TOC overflowing for large builds.
has been removed from the -mm tree.  Its filename was
     powerpc-stop-the-toc-overflowing-for-large-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: stop the TOC overflowing for large builds.
From: Stephen Rothwell <sfr@canb.auug.org.au>

On Tue, 13 Nov 2007 16:35:06 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>
> The 2.6.24-rc2-git3 kernel build fails during linking
>
>   KSYM    .tmp_kallsyms1.S
>   AS      .tmp_kallsyms1.o
>   LD      .tmp_vmlinux2
>   KSYM    .tmp_kallsyms2.S
>   AS      .tmp_kallsyms2.o
>   LD      .tmp_vmlinux3
>   KSYM    .tmp_kallsyms3.S
>   AS      .tmp_kallsyms3.o
>   LD      vmlinux.o
> ld: TOC section size exceeds 64k
> make: *** [vmlinux.o] Error 1

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/Makefile~powerpc-stop-the-toc-overflowing-for-large-builds arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-stop-the-toc-overflowing-for-large-builds
+++ a/arch/powerpc/kernel/Makefile
@@ -3,7 +3,7 @@
 #
 
 ifeq ($(CONFIG_PPC64),y)
-EXTRA_CFLAGS	+= -mno-minimal-toc
+CFLAGS_prom_init.o	+= -mno-minimal-toc
 endif
 ifeq ($(CONFIG_PPC32),y)
 CFLAGS_prom_init.o      += -fPIC
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
git-powerpc.patch
