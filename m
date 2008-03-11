From: akpm@linux-foundation.org
Subject: + kprobes-kprobe-booster-for-ia64-fix.patch added to -mm tree
Date: Mon, 10 Mar 2008 17:16:35 -0700
Message-ID: <200803110016.m2B0GZaR013161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYCKAW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 20:22:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, bibo.mao@intel.com, jkenisto@us.ibm.com, prasanna@in.ibm.com, rusty.lynch@intel.com, shaohua.li@intel.com, tony.luck@intel.com


The patch titled
     kprobes: fix prepare_booster to get correct slot
has been added to the -mm tree.  Its filename is
     kprobes-kprobe-booster-for-ia64-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: fix prepare_booster to get correct slot
From: Masami Hiramatsu <mhiramat@redhat.com>

Fix to get correct slot number from probing address in prepare_booster.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: bibo,mao <bibo.mao@intel.com>
Cc: Rusty Lynch <rusty.lynch@intel.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/kprobes.c~kprobes-kprobe-booster-for-ia64-fix arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~kprobes-kprobe-booster-for-ia64-fix
+++ a/arch/ia64/kernel/kprobes.c
@@ -565,7 +565,7 @@ static int __kprobes can_boost(bundle_t 
 static void __kprobes prepare_booster(struct kprobe *p)
 {
 	unsigned long addr = (unsigned long)p->addr & ~0xFULL;
-	unsigned int slot = addr & 0xf;
+	unsigned int slot = (unsigned long)p->addr & 0xf;
 	struct kprobe *other_kp;
 
 	if (can_boost(&p->ainsn.insn[0].bundle, slot, addr)) {
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch

