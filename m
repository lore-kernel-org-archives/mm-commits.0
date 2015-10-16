From: akpm@linux-foundation.org
Subject: + bitopsh-add-sign_extend64.patch added to -mm tree
Date: Fri, 16 Oct 2015 14:18:43 -0700
Message-ID: <562169b3.4/0NJ+NCbTYYe93C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbbJPVSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 17:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, a.p.zijlstra@chello.nl, acme@kernel.org, dvlasenk@redhat.com, hpa@zytor.com, linux@horizon.com, linux@rasmusvillemoes.dk, martin.kepplinger@theobroma-systems.com, maxime.coquelin@st.com, mingo@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops.h: add sign_extend64()
has been added to the -mm tree.  Its filename is
     bitopsh-add-sign_extend64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitopsh-add-sign_extend64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitopsh-add-sign_extend64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: bitops.h: add sign_extend64()

Months back, this was discussed, see https://lkml.org/lkml/2015/1/18/289
The result was the 64-bit version being "likely fine", "valuable" and
"correct".  The discussion fell asleep but since there are possible users,
let's add it.

Signed-off-by: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: George Spelvin <linux@horizon.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/bitops.h~bitopsh-add-sign_extend64 include/linux/bitops.h
--- a/include/linux/bitops.h~bitopsh-add-sign_extend64
+++ a/include/linux/bitops.h
@@ -173,6 +173,17 @@ static inline __s32 sign_extend32(__u32
 	return (__s32)(value << shift) >> shift;
 }
 
+/**
+ * sign_extend64 - sign extend a 64-bit value using specified bit as sign-bit
+ * @value: value to sign extend
+ * @index: 0 based bit index (0<=index<64) to sign bit
+ */
+static inline __s64 sign_extend64(__u64 value, int index)
+{
+	__u8 shift = 63 - index;
+	return (__s64)(value << shift) >> shift;
+}
+
 static inline unsigned fls_long(unsigned long l)
 {
 	if (sizeof(l) == 4)
_

Patches currently in -mm which might be from martink@posteo.de are

bitopsh-improve-sign_extend32s-documentation.patch
bitopsh-add-sign_extend64.patch
arch-sh-use-sign_extend64-for-sign-extension.patch
arch-sh-use-sign_extend64-for-sign-extension-2.patch
arch-x86-use-sign_extend64-for-sign-extension.patch

