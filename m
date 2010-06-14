From: akpm@linux-foundation.org
Subject: + x86-proper-init-of-memtype-subtree_max_end.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:03:15 -0700
Message-ID: <201006141903.o5EJ3GEM025325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab0FNTEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:04:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venki@google.com, casteyde.christian@free.fr, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: proper init of memtype subtree_max_end
has been added to the -mm tree.  Its filename is
     x86-proper-init-of-memtype-subtree_max_end.patch

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
Subject: x86: proper init of memtype subtree_max_end
From: Venkatesh Pallipadi <venki@google.com>

subtree_max_end that was recently added to struct memtype was not getting
properly initialized resulting in

WARNING: kmemcheck: Caught 64-bit read from uninitialized memory
in memtype_rb_augment_cb()
reported here
https://bugzilla.kernel.org/show_bug.cgi?id=16092

This change fixes the problem.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Reported-by: Christian Casteyde <casteyde.christian@free.fr>
Tested-by: Christian Casteyde <casteyde.christian@free.fr>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat.c        |    2 +-
 arch/x86/mm/pat_rbtree.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/pat.c~x86-proper-init-of-memtype-subtree_max_end arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~x86-proper-init-of-memtype-subtree_max_end
+++ a/arch/x86/mm/pat.c
@@ -302,7 +302,7 @@ int reserve_memtype(u64 start, u64 end, 
 		return -EINVAL;
 	}
 
-	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
+	new  = kzalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
diff -puN arch/x86/mm/pat_rbtree.c~x86-proper-init-of-memtype-subtree_max_end arch/x86/mm/pat_rbtree.c
--- a/arch/x86/mm/pat_rbtree.c~x86-proper-init-of-memtype-subtree_max_end
+++ a/arch/x86/mm/pat_rbtree.c
@@ -226,6 +226,7 @@ int rbt_memtype_check_insert(struct memt
 		if (ret_type)
 			new->type = *ret_type;
 
+		new->subtree_max_end = new->end;
 		memtype_rb_insert(&memtype_rbroot, new);
 	}
 	return err;
_

Patches currently in -mm which might be from venki@google.com are

x86-proper-init-of-memtype-subtree_max_end.patch

