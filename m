From: akpm@linux-foundation.org
Subject: + lib-add-s390-to-atomic64_dec_if_positive-archs.patch added to -mm tree
Date: Wed, 02 Jun 2010 11:54:37 -0700
Message-ID: <201006021854.o52IsbNa010695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971Ab0FBSzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 14:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, hpa@zytor.com, luca@luca-barbieri.com


The patch titled
     lib: add s390 to atomic64_dec_if_positive archs
has been added to the -mm tree.  Its filename is
     lib-add-s390-to-atomic64_dec_if_positive-archs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: add s390 to atomic64_dec_if_positive archs
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Add s390 to list of architectures that have atomic64_dec_if_positive
implemented so we get rid of this warning:

lib/atomic64_test.c:129:2: warning: #warning Please implement
atomic64_dec_if_positive for your architecture, and add it to the IF above

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Luca Barbieri <luca@luca-barbieri.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/atomic64_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/atomic64_test.c~lib-add-s390-to-atomic64_dec_if_positive-archs lib/atomic64_test.c
--- a/lib/atomic64_test.c~lib-add-s390-to-atomic64_dec_if_positive-archs
+++ a/lib/atomic64_test.c
@@ -113,7 +113,8 @@ static __init int test_atomic64(void)
 	r += one;
 	BUG_ON(v.counter != r);
 
-#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(_ASM_GENERIC_ATOMIC64_H)
+#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || \
+    defined(CONFIG_S390) || defined(_ASM_GENERIC_ATOMIC64_H)
 	INIT(onestwos);
 	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
 	r -= one;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
fs-compat_rw_copy_check_uvector-add-missing-compat_ptr-call.patch
ramoops-add-has_iomem-dependency.patch
linux-next.patch
lib-add-s390-to-atomic64_dec_if_positive-archs.patch
drivers-s390-net-use-memdup_user.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-provide-init_mm-mm_context-initializer.patch

