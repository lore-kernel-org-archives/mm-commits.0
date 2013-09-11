From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-track-vma-changes-with-vm_softdirty-bit-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 13:59:48 -0700
Message-ID: <5230d9c4.XcmL65fcMsDbYo9N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3IKU7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, xemul@parallels.com, sfr@canb.auug.org.au, rob@landley.net, rdunlap@infradead.org, peterz@infradead.org, mtosatti@redhat.com, mpm@selenic.com, luto@amacapital.net, kosaki.motohiro@gmail.com, gorcunov@openvz.org, aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org, gorcunov@gmail.com

Subject: [folded-merged] mm-track-vma-changes-with-vm_softdirty-bit-fix.patch removed from -mm tree
To: gorcunov@gmail.com,akpm@linux-foundation.org,aneesh.kumar@linux.vnet.ibm.com,gorcunov@openvz.org,kosaki.motohiro@gmail.com,luto@amacapital.net,mpm@selenic.com,mtosatti@redhat.com,peterz@infradead.org,rdunlap@infradead.org,rob@landley.net,sfr@canb.auug.org.au,xemul@parallels.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:59:48 -0700


The patch titled
     Subject: docs: Document soft dirty behaviour for freshly created memory regions, v2
has been removed from the -mm tree.  Its filename was
     mm-track-vma-changes-with-vm_softdirty-bit-fix.patch

This patch was dropped because it was folded into mm-track-vma-changes-with-vm_softdirty-bit.patch

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

mm-track-vma-changes-with-vm_softdirty-bit.patch
mm-make-sure-_page_swp_soft_dirty-bit-is-not-set-on-present-pte.patch
fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str.patch

