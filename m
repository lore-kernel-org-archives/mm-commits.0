From: akpm@linux-foundation.org
Subject: + mm-track-vma-changes-with-vm_softdirty-bit-fix.patch added to
 -mm tree
Date: Tue, 20 Aug 2013 15:28:34 -0700
Message-ID: <5213ed92.6zeNlS2jfpIQsfec%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3HTW2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 18:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, xemul@parallels.com, sfr@canb.auug.org.au, rob@landley.net, rdunlap@infradead.org, peterz@infradead.org, mtosatti@redhat.com, mpm@selenic.com, luto@amacapital.net, kosaki.motohiro@gmail.com, gorcunov@openvz.org, aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org, gorcunov@gmail.com

Subject: + mm-track-vma-changes-with-vm_softdirty-bit-fix.patch added to -mm tree
To: gorcunov@gmail.com,akpm@linux-foundation.org,aneesh.kumar@linux.vnet.ibm.com,gorcunov@openvz.org,kosaki.motohiro@gmail.com,luto@amacapital.net,mpm@selenic.com,mtosatti@redhat.com,peterz@infradead.org,rdunlap@infradead.org,rob@landley.net,sfr@canb.auug.org.au,xemul@parallels.com,xiaoguangrong@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 15:28:34 -0700


The patch titled
     Subject: docs: Document soft dirty behaviour for freshly created memory regions, v2
has been added to the -mm tree.  Its filename is
     mm-track-vma-changes-with-vm_softdirty-bit-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-track-vma-changes-with-vm_softdirty-bit-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: docs: Document soft dirty behaviour for freshly created memory regions, v2

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/soft-dirty.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/vm/soft-dirty.txt~mm-track-vma-changes-with-vm_softdirty-bit-fix Documentation/vm/soft-dirty.txt
--- a/Documentation/vm/soft-dirty.txt~mm-track-vma-changes-with-vm_softdirty-bit-fix
+++ a/Documentation/vm/soft-dirty.txt
@@ -28,6 +28,13 @@ This is so, since the pages are still ma
 the kernel does is finds this fact out and puts both writable and soft-dirty
 bits on the PTE.
 
+  While in most cases tracking memory changes by #PF-s is more than enough
+there is still a scenario when we can lose soft dirty bits -- a task
+unmaps a previously mapped memory region and then maps a new one at exactly
+the same place. When unmap is called, the kernel internally clears PTE values
+including soft dirty bits. To notify user space application about such
+memory region renewal the kernel always marks new memory regions (and
+expanded regions) as soft dirty.
 
   This feature is actively used by the checkpoint-restore project. You
 can find more details about it on http://criu.org
_

Patches currently in -mm which might be from gorcunov@gmail.com are

arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers.patch
mm-track-vma-changes-with-vm_softdirty-bit.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch

