From: akpm@linux-foundation.org
Subject: + kernel-modulesc-fix-warning.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:03:44 -0700
Message-ID: <201009212203.o8LM3ilR004082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab0IUWEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mirq-linux@rere.qmqm.pl, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     kernel/modules.c: fix warning
has been added to the -mm tree.  Its filename is
     kernel-modulesc-fix-warning.patch

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
Subject: kernel/modules.c: fix warning
From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

Building with CONFIG_KALLSYMS=n gives following warning:

kernel/module.c: In function `post_relocation':
kernel/module.c:2534:2: warning: passing argument 2 of `add_kallsyms' discards qualifiers from pointer target type
kernel/module.c:2038:13: note: expected `struct load_info *' but argument is of type `const struct load_info *'

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/module.c~kernel-modulesc-fix-warning kernel/module.c
--- a/kernel/module.c~kernel-modulesc-fix-warning
+++ a/kernel/module.c
@@ -2035,7 +2035,7 @@ static inline void layout_symtab(struct 
 {
 }
 
-static void add_kallsyms(struct module *mod, struct load_info *info)
+static void add_kallsyms(struct module *mod, const struct load_info *info)
 {
 }
 #endif /* CONFIG_KALLSYMS */
_

Patches currently in -mm which might be from mirq-linux@rere.qmqm.pl are

kernel-modulesc-fix-warning.patch

