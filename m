From: akpm@linux-foundation.org
Subject: + aslr-fix-stack-randomization-on-64-bit-systems.patch added to
 -mm tree
Date: Tue, 17 Feb 2015 14:14:02 -0800
Message-ID: <54e3bd2a.0hySSV3zTF0Vo/wz%akpm__37202.6798934259$1424211257$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbBQWOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 17:14:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hecmargi@upv.es, iripoll@upv.es, keescook@chromium.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ASLR: fix stack randomization on 64-bit systems
has been added to the -mm tree.  Its filename is
     aslr-fix-stack-randomization-on-64-bit-systems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aslr-fix-stack-randomization-on-64-bit-systems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aslr-fix-stack-randomization-on-64-bit-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hector Marco-Gisbert <hecmargi@upv.es>
Subject: ASLR: fix stack randomization on 64-bit systems

The issue is that the stack for processes is not properly randomized on 64
bit architectures due to an integer overflow.

The affected function is randomize_stack_top() in file "fs/binfmt_elf.c":

static unsigned long randomize_stack_top(unsigned long stack_top)
{
         unsigned int random_variable = 0;

         if ((current->flags & PF_RANDOMIZE) &&
                 !(current->personality & ADDR_NO_RANDOMIZE)) {
                 random_variable = get_random_int() & STACK_RND_MASK;
                 random_variable <<= PAGE_SHIFT;
         }
         return PAGE_ALIGN(stack_top) + random_variable;
         return PAGE_ALIGN(stack_top) - random_variable;
}

Note that it declares the "random_variable" variable as "unsigned int". 
Since the result of the shifting operation between STACK_RND_MASK (which
is 0x3fffff on x86_64, 22 bits) and PAGE_SHIFT (which is 12 on x86_64):

random_variable <<= PAGE_SHIFT;

then the two leftmost bits are dropped when storing the result in the
"random_variable".  This variable shall be at least 34 bits long to hold
the (22+12) result.

These two dropped bits have an impact on the entropy of process stack. 
Concretely, the total stack entropy is reduced by four: from 2^28 to 2^30
(One fourth of expected entropy).

This patch restores back the entropy by correcting the types involved in
the operations in the functions randomize_stack_top() and
stack_maxrandom_size().

The successful fix can be tested with:
$ for i in `seq 1 10`; do cat /proc/self/maps | grep stack; done
7ffeda566000-7ffeda587000 rw-p 00000000 00:00 0                          [stack]
7fff5a332000-7fff5a353000 rw-p 00000000 00:00 0                          [stack]
7ffcdb7a1000-7ffcdb7c2000 rw-p 00000000 00:00 0                          [stack]
7ffd5e2c4000-7ffd5e2e5000 rw-p 00000000 00:00 0                          [stack]
...

Once corrected, the leading bytes should be between 7ffc and 7fff, rather
than always being 7fff.

CVE-2015-1593

[keescook@chromium.org: rebase, fix 80 char, clean up commit message, add test example, cve]
Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Ismael Ripoll <iripoll@upv.es>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/mmap.c |    6 +++---
 fs/binfmt_elf.c    |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/mmap.c~aslr-fix-stack-randomization-on-64-bit-systems arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~aslr-fix-stack-randomization-on-64-bit-systems
+++ a/arch/x86/mm/mmap.c
@@ -35,12 +35,12 @@ struct va_alignment __read_mostly va_ali
 	.flags = -1,
 };
 
-static unsigned int stack_maxrandom_size(void)
+static unsigned long stack_maxrandom_size(void)
 {
-	unsigned int max = 0;
+	unsigned long max = 0;
 	if ((current->flags & PF_RANDOMIZE) &&
 		!(current->personality & ADDR_NO_RANDOMIZE)) {
-		max = ((-1U) & STACK_RND_MASK) << PAGE_SHIFT;
+		max = ((-1UL) & STACK_RND_MASK) << PAGE_SHIFT;
 	}
 
 	return max;
diff -puN fs/binfmt_elf.c~aslr-fix-stack-randomization-on-64-bit-systems fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~aslr-fix-stack-randomization-on-64-bit-systems
+++ a/fs/binfmt_elf.c
@@ -645,11 +645,12 @@ out:
 
 static unsigned long randomize_stack_top(unsigned long stack_top)
 {
-	unsigned int random_variable = 0;
+	unsigned long random_variable = 0;
 
 	if ((current->flags & PF_RANDOMIZE) &&
 		!(current->personality & ADDR_NO_RANDOMIZE)) {
-		random_variable = get_random_int() & STACK_RND_MASK;
+		random_variable = (unsigned long) get_random_int();
+		random_variable &= STACK_RND_MASK;
 		random_variable <<= PAGE_SHIFT;
 	}
 #ifdef CONFIG_STACK_GROWSUP
_

Patches currently in -mm which might be from hecmargi@upv.es are

aslr-fix-stack-randomization-on-64-bit-systems.patch

