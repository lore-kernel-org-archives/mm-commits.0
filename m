From: akpm@linux-foundation.org
Subject: [merged] bitopsh-improve-sign_extend32s-documentation.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 11:46:16 -0800
Message-ID: <5640f808.mL8edoAFvSte6QLW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbbKITqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:46:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, a.p.zijlstra@chello.nl, acme@kernel.org, dvlasenk@redhat.com, hpa@zytor.com, linux@horizon.com, linux@rasmusvillemoes.dk, martin.kepplinger@theobroma-systems.com, maxime.coquelin@st.com, mingo@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops.h: improve sign_extend32()'s documentation
has been removed from the -mm tree.  Its filename was
     bitopsh-improve-sign_extend32s-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: bitops.h: improve sign_extend32()'s documentation

It is often overlooked that sign_extend32(), despite its name, is safe to
use for 16 and 8 bit types as well.  This should help prevent sign
extension being done manually some other way.

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

 include/linux/bitops.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/bitops.h~bitopsh-improve-sign_extend32s-documentation include/linux/bitops.h
--- a/include/linux/bitops.h~bitopsh-improve-sign_extend32s-documentation
+++ a/include/linux/bitops.h
@@ -164,6 +164,8 @@ static inline __u8 ror8(__u8 word, unsig
  * sign_extend32 - sign extend a 32-bit value using specified bit as sign-bit
  * @value: value to sign extend
  * @index: 0 based bit index (0<=index<32) to sign bit
+ *
+ * This is safe to use for 16- and 8-bit types as well.
  */
 static inline __s32 sign_extend32(__u32 value, int index)
 {
_

Patches currently in -mm which might be from martink@posteo.de are

arch-sh-use-sign_extend64-for-sign-extension.patch
arch-x86-use-sign_extend64-for-sign-extension.patch

