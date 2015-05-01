From: akpm@linux-foundation.org
Subject: + change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch
 added to -mm tree
Date: Fri, 01 May 2015 15:40:07 -0700
Message-ID: <554400c7.xaeSc6qC2yA88tyG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbEAWkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 18:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: palmer@dabbelt.com, bobby.prani@gmail.com, cmetcalf@ezchip.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, richard@nod.at, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/wait.h: change wait_on_bit*() to take an unsigned long*, not a void*
has been added to the -mm tree.  Its filename is
     change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: include/linux/wait.h: change wait_on_bit*() to take an unsigned long*, not a void*

The implementations of wait_on_bit*() will only work with long-aligned
memory on systems that don't support misaligned loads and stores.  This
patch changes the function prototypes to ensure that the compiler will
enforce alignment.

Running

  make defconfig
  make KFLAGS="-Werror"

seems to indicate that, as of c56fb6564dcd ("Fix a misaligned load inside
ptrace_attach()"), there are now no users of non-long-aligned calls to
wait_on_bit*().  I additionally tried a few "make randconfig" attempts,
none of which failed to compile for this reason.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/wait.h~change-wait_on_bit-to-take-an-unsigned-long-not-a-void include/linux/wait.h
--- a/include/linux/wait.h~change-wait_on_bit-to-take-an-unsigned-long-not-a-void
+++ a/include/linux/wait.h
@@ -969,7 +969,7 @@ extern int bit_wait_io_timeout(struct wa
  * on that signal.
  */
 static inline int
-wait_on_bit(void *word, int bit, unsigned mode)
+wait_on_bit(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
 	if (!test_bit(bit, word))
@@ -994,7 +994,7 @@ wait_on_bit(void *word, int bit, unsigne
  * on that signal.
  */
 static inline int
-wait_on_bit_io(void *word, int bit, unsigned mode)
+wait_on_bit_io(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
 	if (!test_bit(bit, word))
@@ -1020,7 +1020,8 @@ wait_on_bit_io(void *word, int bit, unsi
  * received a signal and the mode permitted wakeup on that signal.
  */
 static inline int
-wait_on_bit_timeout(void *word, int bit, unsigned mode, unsigned long timeout)
+wait_on_bit_timeout(unsigned long *word, int bit, unsigned mode,
+		    unsigned long timeout)
 {
 	might_sleep();
 	if (!test_bit(bit, word))
@@ -1047,7 +1048,8 @@ wait_on_bit_timeout(void *word, int bit,
  * on that signal.
  */
 static inline int
-wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
+wait_on_bit_action(unsigned long *word, int bit, wait_bit_action_f *action,
+		   unsigned mode)
 {
 	might_sleep();
 	if (!test_bit(bit, word))
@@ -1075,7 +1077,7 @@ wait_on_bit_action(void *word, int bit,
  * the @mode allows that signal to wake the process.
  */
 static inline int
-wait_on_bit_lock(void *word, int bit, unsigned mode)
+wait_on_bit_lock(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
 	if (!test_and_set_bit(bit, word))
@@ -1099,7 +1101,7 @@ wait_on_bit_lock(void *word, int bit, un
  * the @mode allows that signal to wake the process.
  */
 static inline int
-wait_on_bit_lock_io(void *word, int bit, unsigned mode)
+wait_on_bit_lock_io(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
 	if (!test_and_set_bit(bit, word))
@@ -1125,7 +1127,8 @@ wait_on_bit_lock_io(void *word, int bit,
  * the @mode allows that signal to wake the process.
  */
 static inline int
-wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
+wait_on_bit_lock_action(unsigned long *word, int bit, wait_bit_action_f *action,
+			unsigned mode)
 {
 	might_sleep();
 	if (!test_and_set_bit(bit, word))
_

Patches currently in -mm which might be from palmer@dabbelt.com are

fix-a-misaligned-load-inside-ptrace_attach.patch
change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch
change-all-uses-of-jobctl_-from-int-to-long.patch

