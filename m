From: akpm@linux-foundation.org
Subject: + alpha-handle-kcalloc-failure.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:13 -0800
Message-ID: <200802230734.m1N7Y1m9018268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786AbYBWICx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:02:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim@meyering.net, ink@jurassic.park.msu.ru, meyering@redhat.com, rth@twiddle.net


The patch titled
     alpha: handle kcalloc failure
has been added to the -mm tree.  Its filename is
     alpha-handle-kcalloc-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

usbaudio-handle-kcalloc-failure.patch
9p-handle-kstrdup-and-match_strdup-failure.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch
