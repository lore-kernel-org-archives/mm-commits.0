Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87790C64EC4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 23:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjCIXTH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Mar 2023 18:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjCIXTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2023 18:19:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D61E274F
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 15:18:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 463F861D20
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 23:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946CEC433D2;
        Thu,  9 Mar 2023 23:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678403927;
        bh=Sluwu4mV52WuWRde+kiE9rFNXFR9wNQQ0ex0PofTmN0=;
        h=Date:To:From:Subject:From;
        b=0HG0133qtFc2uZKGuqQOh3aQ9geQUa5a+clVh7x6Ip6oZ49nBo/amcPzxFlK67M0N
         j3IKN6T+v2J4plCRKtfPgi2Dh8jjE3AFfsTtPdzxyB4lCvPHNd0+Wzk2v1ht4UlPsS
         mO6jypsVpS2fJvflYrqaC/Snfp16LiykXX+Lgge4=
Date:   Thu, 09 Mar 2023 15:18:46 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        willy@infradead.org, p.raghav@samsung.com, keescook@chromium.org,
        hughd@google.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, a.manzanares@samsung.com, mcgrof@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-remove-check-for-folio-lock-on-writepage.patch added to mm-unstable branch
Message-Id: <20230309231847.946CEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: remove check for folio lock on writepage()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-remove-check-for-folio-lock-on-writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-remove-check-for-folio-lock-on-writepage.patch

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
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
---


--- a/mm/shmem.c~shmem-remove-check-for-folio-lock-on-writepage
+++ a/mm/shmem.c
@@ -1336,7 +1336,6 @@ static int shmem_writepage(struct page *
 		folio_clear_dirty(folio);
 	}
 
-	BUG_ON(!folio_test_locked(folio));
 	mapping = folio->mapping;
 	index = folio->index;
 	inode = mapping->host;
_

Patches currently in -mm which might be from mcgrof@kernel.org are

shmem-remove-check-for-folio-lock-on-writepage.patch
shmem-set-shmem_writepage-variables-early.patch
shmem-move-reclaim-check-early-on-writepages.patch
shmem-skip-page-split-if-were-not-reclaiming.patch
shmem-update-documentation.patch
shmem-add-support-to-ignore-swap.patch

