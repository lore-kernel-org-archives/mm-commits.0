From: akpm@linux-foundation.org
Subject: [merged] jiffies-force-inlining-of-mumsecs_to_jiffies.patch
 removed from -mm tree
Date: Thu, 13 Aug 2015 12:45:49 -0700
Message-ID: <55ccf3ed.prl3jcdLfMoCSz/p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbbHMTpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Aug 2015 15:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, mingo@kernel.org, peterz@infradead.org, rientjes@google.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: jiffies: force inlining of {m,u}msecs_to_jiffies()
has been removed from the -mm tree.  Its filename was
     jiffies-force-inlining-of-mumsecs_to_jiffies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: jiffies: force inlining of {m,u}msecs_to_jiffies()

With this config:
http://busybox.net/~vda/kernel_config_OPTIMIZE_INLINING_and_Os
gcc-4.7.2 generates many copies of these tiny functions:

msecs_to_jiffies (45 copies):
55                      push   %rbp
48 89 e5                mov    %rsp,%rbp
e8 59 ec 03 00          callq  __msecs_to_jiffies
5d                      pop    %rbp
c3                      retq

usecs_to_jiffies (10 copies):
55                      push   %rbp
48 89 e5                mov    %rsp,%rbp
e8 5d 54 5e ff          callq  __usecs_to_jiffies
5d                      pop    %rbp
c3                      retq

See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66122

This patch fixes this via s/inline/__always_inline/

    text     data      bss       dec     hex filename
86970954 17195912 36659200 140826066 864d5d2 vmlinux.before
86966150 17195912 36659200 140821262 864c30e vmlinux

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/jiffies.h~jiffies-force-inlining-of-mumsecs_to_jiffies include/linux/jiffies.h
--- a/include/linux/jiffies.h~jiffies-force-inlining-of-mumsecs_to_jiffies
+++ a/include/linux/jiffies.h
@@ -351,7 +351,7 @@ static inline unsigned long _msecs_to_ji
  * directly here and from __msecs_to_jiffies() in the case where
  * constant folding is not possible.
  */
-static inline unsigned long msecs_to_jiffies(const unsigned int m)
+static __always_inline unsigned long msecs_to_jiffies(const unsigned int m)
 {
 	if (__builtin_constant_p(m)) {
 		if ((int)m < 0)
@@ -398,7 +398,7 @@ static inline unsigned long _usecs_to_ji
  * directly here and from __msecs_to_jiffies() in the case where
  * constant folding is not possible.
  */
-static inline unsigned long usecs_to_jiffies(const unsigned int u)
+static __always_inline unsigned long usecs_to_jiffies(const unsigned int u)
 {
 	if (__builtin_constant_p(u)) {
 		if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
_

Patches currently in -mm which might be from dvlasenk@redhat.com are

linux-next.patch

