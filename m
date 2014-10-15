From: akpm@linux-foundation.org
Subject: +
 arch-x86-purgatory-makefile-supress-kexec-purgatoryc-is-up-to-date-message.patch added to -mm tree
Date: Wed, 15 Oct 2014 12:53:06 -0700
Message-ID: <543ed0a2.9YIqwNc+EnDbXE5j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaJOTxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 15:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaowang@redhat.com, bhe@redhat.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/purgatory/Makefile: supress kexec-purgatory.c is up to date message
has been added to the -mm tree.  Its filename is
     arch-x86-purgatory-makefile-supress-kexec-purgatoryc-is-up-to-date-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-purgatory-makefile-supress-kexec-purgatoryc-is-up-to-date-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-purgatory-makefile-supress-kexec-purgatoryc-is-up-to-date-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: WANG Chao <chaowang@redhat.com>
Subject: arch/x86/purgatory/Makefile: supress kexec-purgatory.c is up to date message

Supress this unnecessary message during kernel re-build
(CONFIG_KEXEC_FILE=y):

make[1]: `arch/x86/purgatory/kexec-purgatory.c' is up to date.

(@ is used to suppress echoing. See
https://www.gnu.org/software/make/manual/html_node/Echoing.html)

Signed-off-by: WANG Chao <chaowang@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/purgatory/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/purgatory/Makefile~arch-x86-purgatory-makefile-supress-kexec-purgatoryc-is-up-to-date-message arch/x86/purgatory/Makefile
--- a/arch/x86/purgatory/Makefile~arch-x86-purgatory-makefile-supress-kexec-purgatoryc-is-up-to-date-message
+++ a/arch/x86/purgatory/Makefile
@@ -24,6 +24,7 @@ quiet_cmd_bin2c = BIN2C   $@
 
 $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
 	$(call if_changed,bin2c)
+	@:
 
 
 obj-$(CONFIG_KEXEC_FILE)	+= kexec-purgatory.o
_

Patches currently in -mm which might be from chaowang@redhat.com are

origin.patch
arch-x86-purgatory-makefile-supress-kexec-purgatoryc-is-up-to-date-message.patch

