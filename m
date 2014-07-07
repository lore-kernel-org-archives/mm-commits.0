From: akpm@linux-foundation.org
Subject: + kbuild-explain-stack-protector-strong-config-logic.patch added
 to -mm tree
Date: Mon, 07 Jul 2014 12:16:03 -0700
Message-ID: <53baf1f3.4F/pg51TVZwCl3cN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:53748 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaGGTQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 15:16:05 -0400
Received: by mail-ve0-f201.google.com with SMTP id jz11so672716veb.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 12:16:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ak@linux.intel.com, akpm@linux-foundation.org, mhocko@suse.cz, mmarek@suse.cz, rdunlap@infradead.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ./Makefile: explain stack-protector-strong CONFIG logic
has been added to the -mm tree.  Its filename is
     kbuild-explain-stack-protector-strong-config-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kbuild-explain-stack-protector-strong-config-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kbuild-explain-stack-protector-strong-config-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ./Makefile: explain stack-protector-strong CONFIG logic

This adds a hopefully helpful comment above the (seemingly weird) compiler
flag selection logic.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN Makefile~kbuild-explain-stack-protector-strong-config-logic Makefile
--- a/Makefile~kbuild-explain-stack-protector-strong-config-logic
+++ a/Makefile
@@ -633,6 +633,22 @@ KBUILD_CFLAGS += $(call cc-option,-Wfram
 endif
 
 # Handle stack protector mode.
+#
+# Since kbuild can potentially perform two passes (first with the old
+# .config values and then with updated .config values), we cannot error out
+# if a desired compiler option is unsupported. If we were to error, kbuild
+# could never get to the second pass and actually notice that we changed
+# the option to something that was supported.
+#
+# Additionally, we don't want to fallback and/or silently change which compiler
+# flags will be used, since that leads to producing kernels with different
+# security feature characteristics depending on the compiler used. ("But I
+# selected CC_STACKPROTECTOR_STRONG! Why did it build with _REGULAR?!")
+#
+# The middle ground is to warn here so that the failed option is obvious, but
+# to let the build fail with bad compiler flags so that we can't produce a
+# kernel when there is a CONFIG and compiler mismatch.
+#
 ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   ifeq ($(call cc-option, $(stackp-flag)),)
_

Patches currently in -mm which might be from keescook@chromium.org are

kbuild-explain-stack-protector-strong-config-logic.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

