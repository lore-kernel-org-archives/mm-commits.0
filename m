From: akpm@linux-foundation.org
Subject: + mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch added to -mm tree
Date: Mon, 24 Jan 2011 13:42:04 -0800
Message-ID: <201101242142.p0OLg4Y0012127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab1AXVmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 16:42:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org


The patch titled
     mm/memcontrol.c: fix uninitialized variable use in mem_cgroup_move_parent()
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch

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
Subject: mm/memcontrol.c: fix uninitialized variable use in mem_cgroup_move_parent()
From: Jesper Juhl <jj@chaosbits.net>

In mm/memcontrol.c::mem_cgroup_move_parent() there's a path that jumps to
the 'put_back' label

  	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
  	if (ret || !parent)
  		goto put_back;
where we'll

  	if (charge > PAGE_SIZE)
  		compound_unlock_irqrestore(page, flags);

but, we have not assigned anything to 'flags' at this point, nor have we
called 'compound_lock_irqsave()' (which is what sets 'flags').  The
'put_back' label should be moved below the call to
compound_unlock_irqrestore() as per this patch.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent
+++ a/mm/memcontrol.c
@@ -2292,9 +2292,10 @@ static int mem_cgroup_move_parent(struct
 	ret = mem_cgroup_move_account(pc, child, parent, true, charge);
 	if (ret)
 		mem_cgroup_cancel_charge(parent, charge);
-put_back:
+
 	if (charge > PAGE_SIZE)
 		compound_unlock_irqrestore(page, flags);
+put_back:
 	putback_lru_page(page);
 put:
 	put_page(page);
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
linux-next.patch
mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
audit-always-follow-va_copy-with-va_end.patch

