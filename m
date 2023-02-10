Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CFBC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBJAwu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbjBJAwq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB07B6779C
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 124B4CE270E
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56634C433EF;
        Fri, 10 Feb 2023 00:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990362;
        bh=10bkJ6qSpWZDaSFT2B7UE7oCHHtdQNj8ByZ9yr7C41U=;
        h=Date:To:From:Subject:From;
        b=gI3w6Ak07V34QrXGC+SI+VaYOBpaC3uSz8u12+CcjyMjVbRGaRGFC8UrnHWbWRmHG
         G968o/Uin7/+ISVsAwrT2LVyKJmXF+1IFipuREWp67sb01EtLtmoIqjpcPdUuOjXef
         cuyBqVMqW/xketNbBan2bew9M9IYnrF1/I1NmvFQ=
Date:   Thu, 09 Feb 2023 16:52:41 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ipc-shm-use-the-vma-iterator-for-munmap-calls.patch removed from -mm tree
Message-Id: <20230210005242.56634C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc/shm: use the vma iterator for munmap calls
has been removed from the -mm tree.  Its filename was
     ipc-shm-use-the-vma-iterator-for-munmap-calls.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: ipc/shm: use the vma iterator for munmap calls
Date: Fri, 20 Jan 2023 11:26:16 -0500

Pass through the vma iterator to do_vmi_munmap() to handle the iterator
state internally

Link: https://lkml.kernel.org/r/20230120162650.984577-16-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/ipc/shm.c~ipc-shm-use-the-vma-iterator-for-munmap-calls
+++ a/ipc/shm.c
@@ -1786,8 +1786,8 @@ long ksys_shmdt(char __user *shmaddr)
 			 */
 			file = vma->vm_file;
 			size = i_size_read(file_inode(vma->vm_file));
-			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start, NULL);
-			mas_pause(&vmi.mas);
+			do_vmi_munmap(&vmi, mm, vma->vm_start,
+			      vma->vm_end - vma->vm_start, NULL, false);
 			/*
 			 * We discovered the size of the shm segment, so
 			 * break out of here and fall through to the next
@@ -1810,10 +1810,9 @@ long ksys_shmdt(char __user *shmaddr)
 		/* finding a matching vma now does not alter retval */
 		if ((vma->vm_ops == &shm_vm_ops) &&
 		    ((vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) &&
-		    (vma->vm_file == file)) {
-			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start, NULL);
-			mas_pause(&vmi.mas);
-		}
+		    (vma->vm_file == file))
+			do_vmi_munmap(&vmi, mm, vma->vm_start,
+			      vma->vm_end - vma->vm_start, NULL, false);
 
 		vma = vma_next(&vmi);
 	}
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


