From: akpm@linux-foundation.org
Subject: + kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch added to -mm tree
Date: Thu, 06 Nov 2008 17:01:08 -0800
Message-ID: <200811070101.mA7118mh030105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753333AbYKGBBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 20:01:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, h-shimamoto@ct.jp.nec.com, laijs@cn.fujitsu.com


The patch titled
     kprobes: bugfix: try_module_get even if calling_mod is NULL
has been added to the -mm tree.  Its filename is
     kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch

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
Subject: kprobes: bugfix: try_module_get even if calling_mod is NULL
From: Masami Hiramatsu <mhiramat@redhat.com>

Get probed module even if the caller is in the kernel core code.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-bugfix-try_module_get-even-if-calling_mod-is-null kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-bugfix-try_module_get-even-if-calling_mod-is-null
+++ a/kernel/kprobes.c
@@ -630,7 +630,7 @@ static int __kprobes __register_kprobe(s
 		 * avoid incrementing the module refcount, so as to allow
 		 * unloading of self probing modules.
 		 */
-		if (calling_mod && calling_mod != probed_mod) {
+		if (calling_mod != probed_mod) {
 			if (unlikely(!try_module_get(probed_mod)))
 				return -EINVAL;
 			p->mod_refcounted = 1;
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch

