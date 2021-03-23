Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9430C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 23 Mar 2021 08:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3608619C4
	for <mm-commits@archiver.kernel.org>; Tue, 23 Mar 2021 08:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhCWICD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Mar 2021 04:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhCWIBb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Mar 2021 04:01:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91308619BA;
        Tue, 23 Mar 2021 08:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616486491;
        bh=WwGrDRvIduKtYjbRZ8PUE60XGc2UQIeVzw1JeczIe2U=;
        h=Date:From:To:Subject:From;
        b=weG0KaaJ9dz47EJ6x6Lf2j2DkDdURJ/Ck4R+tyxDMifnERb4p0tGeGtYPiuxqr20n
         UgnnY+ds/+W5j0nNhbixeJcEuym6x4pD0rx6DlJ++N1G0Ev0vnN5E6FgATE1RwHM/4
         kkOweekMTesstjUp6uBQNMdpsbMbVx9Ks1q4TMMs=
Date:   Tue, 23 Mar 2021 01:01:30 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux@armlinux.org.uk, maninder1.s@samsung.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org, penberg@kernel.org,
        rientjes@google.com, v.narang@samsung.com, vbabka@suse.cz,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 mm-slub-fixing-backtrace-of-objects-because-of-redzone-adjustment.patch
 removed from -mm tree
Message-ID: <20210323080130.iutiJJyRp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: fix backtrace of objects because of redzone adjustment
has been removed from the -mm tree.  Its filename was
     mm-slub-fixing-backtrace-of-objects-because-of-redzone-adjustment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: mm/slub: fix backtrace of objects because of redzone adjustment

Fix commit 8e7f37f2aaa5 ("mm: Add mem_dump_obj() to print source of memory
block")

With the current code the backtrace of an allocated object is wrong:

/ # cat /proc/meminfo
[   14.969843]  slab kmalloc-64 start c8ab0140 data offset 64 pointer offset 0 size 64 allocated at 0x6b6b6b6b
[   14.970635]     0x6b6b6b6b
[   14.970794]     0x6b6b6b6b
[   14.970932]     0x6b6b6b6b
[   14.971077]     0x6b6b6b6b
[   14.971202]     0x6b6b6b6b
[   14.971317]     0x6b6b6b6b
[   14.971423]     0x6b6b6b6b
[   14.971635]     0x6b6b6b6b
[   14.971740]     0x6b6b6b6b
[   14.971871]     0x6b6b6b6b
[   14.972229]     0x6b6b6b6b
[   14.972363]     0x6b6b6b6b
[   14.972505]     0xa56b6b6b
[   14.972631]     0xbbbbbbbb
[   14.972734]     0xc8ab0400
[   14.972891]     meminfo_proc_show+0x40/0x4fc

Because the red zone was not adjusted from the object address.  after
adding this fixup for redzone, the backtrace is correct:

/ # cat /proc/meminfo
[   14.870782]  slab kmalloc-64 start c8ab0140 data offset 64 pointer offset 128 size 64 allocated at meminfo_proc_show+0x40/0x4f4
[   14.871817]     meminfo_proc_show+0x40/0x4f4
[   14.872035]     seq_read_iter+0x18c/0x4c4
[   14.872229]     proc_reg_read_iter+0x84/0xac
[   14.872433]     generic_file_splice_read+0xe8/0x17c
[   14.872621]     splice_direct_to_actor+0xb8/0x290
[   14.872747]     do_splice_direct+0xa0/0xe0
[   14.872896]     do_sendfile+0x2d0/0x438
[   14.873044]     sys_sendfile64+0x12c/0x140
[   14.873229]     ret_fast_syscall+0x0/0x58
[   14.873372]     0xbe861de4

Link: https://lkml.kernel.org/r/1615891032-29160-1-git-send-email-maninder1.s@samsung.com
Fixes: 8e7f37f2aaa5 ("mm: Add mem_dump_obj() to print source of memory
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~mm-slub-fixing-backtrace-of-objects-because-of-redzone-adjustment
+++ a/mm/slub.c
@@ -3991,6 +3991,7 @@ void kmem_obj_info(struct kmem_obj_info
 	    !(s->flags & SLAB_STORE_USER))
 		return;
 #ifdef CONFIG_SLUB_DEBUG
+	objp = fixup_red_left(s, objp);
 	trackp = get_track(s, objp, TRACK_ALLOC);
 	kpp->kp_ret = (void *)trackp->addr;
 #ifdef CONFIG_STACKTRACE
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

arm-print-alloc-free-paths-for-address-in-registers.patch

