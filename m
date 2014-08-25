From: akpm@linux-foundation.org
Subject: + purgatory-add-clean-up-for-purgatory-directory.patch added to
 -mm tree
Date: Mon, 25 Aug 2014 14:55:15 -0700
Message-ID: <53fbb0c3.ZRYw/7t+168N1BU3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:42385 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597AbaHYVzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Aug 2014 17:55:16 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so3731884pab.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2014 14:55:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mwelling@ieee.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: purgatory: add clean-up for purgatory directory
has been added to the -mm tree.  Its filename is
     purgatory-add-clean-up-for-purgatory-directory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/purgatory-add-clean-up-for-purgatory-directory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/purgatory-add-clean-up-for-purgatory-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Welling <mwelling@ieee.org>
Subject: kexec: purgatory: add clean-up for purgatory directory

Without this patch the kexec-purgatory.c and purgatory.ro files are not
removed after make mrproper.

Signed-off-by: Michael Welling <mwelling@ieee.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Makefile~purgatory-add-clean-up-for-purgatory-directory arch/x86/Makefile
--- a/arch/x86/Makefile~purgatory-add-clean-up-for-purgatory-directory
+++ a/arch/x86/Makefile
@@ -251,6 +251,7 @@ archclean:
 	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
+	$(Q)$(MAKE) $(clean)=arch/x86/purgatory
 
 PHONY += kvmconfig
 kvmconfig:
_

Patches currently in -mm which might be from mwelling@ieee.org are

purgatory-add-clean-up-for-purgatory-directory.patch

