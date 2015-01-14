From: akpm@linux-foundation.org
Subject: + kexec-add-bit-definitions-for-kimage-entry-flags.patch added to -mm tree
Date: Tue, 13 Jan 2015 16:47:39 -0800
Message-ID: <54b5bcab.0diqdgDKwtPWUeoW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbANArk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:47:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoff@infradead.org, arnd@arndb.de, benh@kernel.crashing.org, hpa@zytor.com, max@stro.at, mmarek@suse.cz, pebolle@tiscali.nl, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add bit definitions for kimage entry flags
has been added to the -mm tree.  Its filename is
     kexec-add-bit-definitions-for-kimage-entry-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-add-bit-definitions-for-kimage-entry-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-add-bit-definitions-for-kimage-entry-flags.patch

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
Subject: kexec: add bit definitions for kimage entry flags

Define new kexec preprocessor macros IND_*_BIT that define the bit
position of the kimage entry flags.  Change the existing IND_* flag macros
to be defined as bit shifts of the corresponding IND_*_BIT macros.  Also
wrap all C language code in kexec.h with #if !defined(__ASSEMBLY__) so
assembly files can include kexec.h to get the IND_* and IND_*_BIT macros.

Some CPU instruction sets have tests for bit position which are convenient
in implementing routines that operate on the kimage entry list.  The
addition of these bit position macros in a common location will avoid
duplicate definitions and the chance that changes to the IND_* flags will
not be propagated to assembly files.

Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Maximilian Attems <max@stro.at>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/kexec.h~kexec-add-bit-definitions-for-kimage-entry-flags include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-add-bit-definitions-for-kimage-entry-flags
+++ a/include/linux/kexec.h
@@ -1,6 +1,18 @@
 #ifndef LINUX_KEXEC_H
 #define LINUX_KEXEC_H
 
+#define IND_DESTINATION_BIT 0
+#define IND_INDIRECTION_BIT 1
+#define IND_DONE_BIT        2
+#define IND_SOURCE_BIT      3
+
+#define IND_DESTINATION  (1 << IND_DESTINATION_BIT)
+#define IND_INDIRECTION  (1 << IND_INDIRECTION_BIT)
+#define IND_DONE         (1 << IND_DONE_BIT)
+#define IND_SOURCE       (1 << IND_SOURCE_BIT)
+
+#if !defined(__ASSEMBLY__)
+
 #include <uapi/linux/kexec.h>
 
 #ifdef CONFIG_KEXEC
@@ -64,10 +76,6 @@
  */
 
 typedef unsigned long kimage_entry_t;
-#define IND_DESTINATION  0x1
-#define IND_INDIRECTION  0x2
-#define IND_DONE         0x4
-#define IND_SOURCE       0x8
 
 struct kexec_segment {
 	/*
@@ -311,4 +319,7 @@ struct task_struct;
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
 #endif /* CONFIG_KEXEC */
+
+#endif /* !defined(__ASSEBMLY__) */
+
 #endif /* LINUX_KEXEC_H */
_

Patches currently in -mm which might be from geoff@infradead.org are

kexec-fix-make-headers_check.patch
kexec-simplify-conditional.patch
kexec-add-bit-definitions-for-kimage-entry-flags.patch
kexec-add-ind_flags-macro.patch

