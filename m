Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576BCEB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 20:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjGLUxj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 16:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGLUxi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 16:53:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80728171D
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 13:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F496617EC
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 20:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678A7C433C7;
        Wed, 12 Jul 2023 20:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689195216;
        bh=jqYA8bgxG1rflzy+RRNgiz6qCHqv58awaVlOuXB3IJI=;
        h=Date:To:From:Subject:From;
        b=EAjstrQejpJf5kmZ5xcGD3T7iRY8lsrj7Oo+LjaqcmPQrHYvJ0xZGwmIEue9E555q
         2Lfphtc5/haGSm1ONFBiIbefg+8wRFjBcQqvxZGa06ODh4of9GVFZctUUNSu/x7NrG
         EJAm7s4U0O0zsxhd0G4ZVquUn200AfzyZGYNHl+k=
Date:   Wed, 12 Jul 2023 13:53:35 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stephen.smalley.work@gmail.com, paul@paul-moore.com,
        eparis@parisplace.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selinux-use-vma_is_stack-and-vma_is_heap-fix.patch added to mm-unstable branch
Message-Id: <20230712205336.678A7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selinux-use-vma_is_stack-and-vma_is_heap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selinux-use-vma_is_stack-and-vma_is_heap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selinux-use-vma_is_stack-and-vma_is_heap-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selinux-use-vma_is_stack-and-vma_is_heap-fix
Date: Wed Jul 12 01:42:33 PM PDT 2023

fix build

security/selinux/hooks.c: In function 'selinux_file_mprotect':
security/selinux/hooks.c:3768:42: error: suggest parentheses around '&&' within '||' [-Werror=parentheses]
 3768 |                 } else if (!vma->vm_file && vma_is_stack(vma) ||
      |                            ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
security/selinux/hooks.c:3769:59: error: expected statement before ')' token
 3769 |                             vma_is_stack_for_current(vma))) {
      |                                                           ^
security/selinux/hooks.c:3768:24: error: this 'if' clause does not guard... [-Werror=misleading-indentation]
 3768 |                 } else if (!vma->vm_file && vma_is_stack(vma) ||
      |                        ^~
security/selinux/hooks.c:3769:61: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
 3769 |                             vma_is_stack_for_current(vma))) {
      |                                                             ^
security/selinux/hooks.c:3772:19: error: expected '}' before 'else'
 3772 |                 } else if (vma->vm_file && vma->anon_vma) {
      |                   ^~~~
security/selinux/hooks.c:3780:25: error: 'rc' undeclared (first use in this function); did you mean 'rq'?
 3780 |                         rc = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
      |                         ^~
      |                         rq
security/selinux/hooks.c:3780:25: note: each undeclared identifier is reported only once for each function it appears in
security/selinux/hooks.c: At top level:
security/selinux/hooks.c:3786:9: error: expected identifier or '(' before 'return'
 3786 |         return file_map_prot_check(vma->vm_file, prot, vma->vm_flags&VM_SHARED);
      |         ^~~~~~
security/selinux/hooks.c:3787:1: error: expected identifier or '(' before '}' token
 3787 | }
      | ^
security/selinux/hooks.c: In function 'selinux_file_mprotect':
security/selinux/hooks.c:3784:9: error: control reaches end of non-void function [-Werror=return-type]
 3784 |         }
      |         ^

Cc: Eric Paris <eparis@parisplace.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/security/selinux/hooks.c~selinux-use-vma_is_stack-and-vma_is_heap-fix
+++ a/security/selinux/hooks.c
@@ -3765,8 +3765,9 @@ static int selinux_file_mprotect(struct
 		if (vma_is_heap(vma)) {
 			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECHEAP, NULL);
-		} else if (!vma->vm_file && vma_is_stack(vma) ||
-			    vma_is_stack_for_current(vma))) {
+		} else if (!vma->vm_file &&
+			  	(vma_is_stack(vma) ||
+				 vma_is_stack_for_current(vma))) {
 			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECSTACK, NULL);
 		} else if (vma->vm_file && vma->anon_vma) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

