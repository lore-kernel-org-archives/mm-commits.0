Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5C5C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjC1XXU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjC1XWG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5A830C4
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24EF7B81EEC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDE4C433D2;
        Tue, 28 Mar 2023 23:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045720;
        bh=I57GqLXPQLPDmRWOHOi8VS0ybv5pHJ1kZll6XORDCYQ=;
        h=Date:To:From:Subject:From;
        b=L1gXMpBthgrmpdaY7LDgzV4Njwukj/ZDK8WBVsKNugGB7rpYU23Oz8C1eiKx3MTpW
         mQ1KBXOXUQo/6mRFbY5WHqDBexf5L+d6Yr++UhsiyoopeMlQ3buPKOmOnKFmAaUhpp
         Ao5STjnz4g58D0KQzI9FWl9cifVmCaD8+U/iqhzM=
Date:   Tue, 28 Mar 2023 16:22:00 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        xhao@linux.alibaba.com, willy@infradead.org, p.raghav@samsung.com,
        keescook@chromium.org, hughd@google.com, david@redhat.com,
        dave@stgolabs.net, brauner@kernel.org, a.manzanares@samsung.com,
        mcgrof@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-remove-check-for-folio-lock-on-writepage.patch removed from -mm tree
Message-Id: <20230328232200.CEDE4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: remove check for folio lock on writepage()
has been removed from the -mm tree.  Its filename was
     shmem-remove-check-for-folio-lock-on-writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: shmem: remove check for folio lock on writepage()
Date: Thu, 9 Mar 2023 15:05:40 -0800

Patch series "tmpfs: add the option to disable swap", v2.

I'm doing this work as part of future experimentation with tmpfs and the
page cache, but given a common complaint found about tmpfs is the
innability to work without the page cache I figured this might be useful
to others.  It turns out it is -- at least Christian Brauner indicates
systemd uses ramfs for a few use-cases because they don't want to use swap
and so having this option would let them move over to using tmpfs for
those small use cases, see systemd-creds(1).

To see if you hit swap:

mkswap /dev/nvme2n1
swapon /dev/nvme2n1
free -h

With swap - what we see today
=============================
mount -t tmpfs            -o size=5G           tmpfs /data-tmpfs/
dd if=/dev/urandom of=/data-tmpfs/5g-rand2 bs=1G count=5
free -h
               total        used        free      shared  buff/cache   available
Mem:           3.7Gi       2.6Gi       1.2Gi       2.2Gi       2.2Gi       1.2Gi
Swap:           99Gi       2.8Gi        97Gi


Without swap
=============

free -h
               total        used        free      shared  buff/cache   available
Mem:           3.7Gi       387Mi       3.4Gi       2.1Mi        57Mi       3.3Gi
Swap:           99Gi          0B        99Gi
mount -t tmpfs            -o size=5G -o noswap tmpfs /data-tmpfs/
dd if=/dev/urandom of=/data-tmpfs/5g-rand2 bs=1G count=5
free -h
               total        used        free      shared  buff/cache   available
Mem:           3.7Gi       2.6Gi       1.2Gi       2.3Gi       2.3Gi       1.1Gi
Swap:           99Gi        21Mi        99Gi

The mix and match remount testing
=================================

# Cannot disable swap after it was first enabled:
mount -t tmpfs            -o size=5G           tmpfs /data-tmpfs/
mount -t tmpfs -o remount -o size=5G -o noswap tmpfs /data-tmpfs/
mount: /data-tmpfs: mount point not mounted or bad option.
       dmesg(1) may have more information after failed mount system call.
dmesg -c
tmpfs: Cannot disable swap on remount

# Remount with the same noswap option is OK:
mount -t tmpfs            -o size=5G -o noswap tmpfs /data-tmpfs/
mount -t tmpfs -o remount -o size=5G -o noswap tmpfs /data-tmpfs/
dmesg -c

# Trying to enable swap with a remount after it first disabled:
mount -t tmpfs            -o size=5G -o noswap tmpfs /data-tmpfs/
mount -t tmpfs -o remount -o size=5G           tmpfs /data-tmpfs/
mount: /data-tmpfs: mount point not mounted or bad option.
       dmesg(1) may have more information after failed mount system call.
dmesg -c
tmpfs: Cannot enable swap on remount if it was disabled on first mount


This patch (of 6):

Matthew notes we should not need to check the folio lock on the
writepage() callback so remove it.  This sanity check has been lingering
since linux-history days.  We remove this as we tidy up the writepage()
callback to make things a bit clearer.

Link: https://lkml.kernel.org/r/20230309230545.2930737-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20230309230545.2930737-2-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Tested-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/shmem.c~shmem-remove-check-for-folio-lock-on-writepage
+++ a/mm/shmem.c
@@ -1361,7 +1361,6 @@ static int shmem_writepage(struct page *
 		folio_clear_dirty(folio);
 	}
 
-	BUG_ON(!folio_test_locked(folio));
 	mapping = folio->mapping;
 	index = folio->index;
 	inode = mapping->host;
_

Patches currently in -mm which might be from mcgrof@kernel.org are


