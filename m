From: akpm@linux-foundation.org
Subject: + proc-fix-missing-reference-of-mm.patch added to -mm tree
Date: Thu, 21 Jan 2016 13:17:41 -0800
Message-ID: <56a14af5.ZGcVP3Ww6dnQ43tf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbcAUVRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 16:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, hannes@cmpxchg.org, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix missing reference of mm
has been added to the -mm tree.  Its filename is
     proc-fix-missing-reference-of-mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fix-missing-reference-of-mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-missing-reference-of-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: proc: fix missing reference of mm

The defconfig build of blackfin was failing with the error:
fs/proc/task_nommu.c: In function 'is_stack':
fs/proc/task_nommu.c:132:28: error: 'mm' undeclared (first use in this function)

While reverting /proc/<pid>/maps [stack:TID] annotation a reference to
mm was missed.

Fixes: e87d4fd02f40 ("proc: revert /proc/<pid>/maps [stack:TID] annotation")
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/task_nommu.c~proc-fix-missing-reference-of-mm fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-fix-missing-reference-of-mm
+++ a/fs/proc/task_nommu.c
@@ -126,6 +126,7 @@ unsigned long task_statm(struct mm_struc
 static int is_stack(struct proc_maps_private *priv,
 		    struct vm_area_struct *vma, int is_pid)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int stack = 0;
 
 	if (is_pid) {
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

reiserfs-fix-dereference-of-err_ptr.patch
proc-fix-missing-reference-of-mm.patch

