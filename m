From: akpm@linux-foundation.org
Subject: + kexec-add-ind_flags-macro.patch added to -mm tree
Date: Tue, 13 Jan 2015 16:47:41 -0800
Message-ID: <54b5bcad.LfcaUKaJIrJTwdC7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbANArm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:47:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoff@infradead.org, arnd@arndb.de, benh@kernel.crashing.org, hpa@zytor.com, max@stro.at, mmarek@suse.cz, pebolle@tiscali.nl, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add IND_FLAGS macro
has been added to the -mm tree.  Its filename is
     kexec-add-ind_flags-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-add-ind_flags-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-add-ind_flags-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geoff Levand <geoff@infradead.org>
Subject: kexec: add IND_FLAGS macro

Add a new kexec preprocessor macro IND_FLAGS, which is the bitwise OR of
all the possible kexec IND_ kimage_entry indirection flags.  Having this
macro allows for simplified code in the prosessing of the kexec
kimage_entry items.  Also, remove the local powerpc definition and use the
generic one.

Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Maximilian Attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/machine_kexec_64.c |    2 --
 include/linux/kexec.h                  |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/machine_kexec_64.c~kexec-add-ind_flags-macro arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~kexec-add-ind_flags-macro
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -96,8 +96,6 @@ int default_machine_kexec_prepare(struct
 	return 0;
 }
 
-#define IND_FLAGS (IND_DESTINATION | IND_INDIRECTION | IND_DONE | IND_SOURCE)
