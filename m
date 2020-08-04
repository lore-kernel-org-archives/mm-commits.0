Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDD1C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D15C2245C
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511015;
	bh=zw4s7TPWJNfm2BEZVIXC8M87hR+mCgknLOIFWeceNKc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=CRpacbioUie6SU9tEKLAfgNXlksEYtOQC6PNoDMIX+whT4cl4h2oBD/7YpbOHmPKc
	 SB5cAAqFoXWptuVvQhNJAqvy9gWFpfC3cZWE8lQwnCc4lqc2g5Mqm8gW2PfdkJBUqu
	 HqkUJpJaxU3hY38fzJkbasYpC1g/sKZOvxVmwoGI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgHDDQz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729524AbgHDDQy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:16:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0A592086A;
        Tue,  4 Aug 2020 03:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511014;
        bh=zw4s7TPWJNfm2BEZVIXC8M87hR+mCgknLOIFWeceNKc=;
        h=Date:From:To:Subject:From;
        b=Civ1AJL33etfBw5Sfw6vzuPjpsbyubIV9l39N5mE62vzwZaLvdwN4V4jegh86YyiB
         Lulpt3TdZT7jBo16qzt4wLz+Q5CeXI7Z0R931Bl56LF8/+0Fe5urvVDRnW/I4m0IxE
         CzG5mhrRytaTArwCmc4dfEIk2LrMelbFZbJTWbeQ=
Date:   Mon, 03 Aug 2020 20:16:53 -0700
From:   akpm@linux-foundation.org
To:     amir73il@gmail.com, hannes@cmpxchg.org, hughd@google.com,
        jlayton@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  + tmpfs-support-64-bit-inums-per-sb-fix.patch added to
 -mm tree
Message-ID: <20200804031653.Tc5MASFr7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: support 64-bit inums per-sb fix
has been added to the -mm tree.  Its filename is
     tmpfs-support-64-bit-inums-per-sb-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tmpfs-support-64-bit-inums-per-sb-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-support-64-bit-inums-per-sb-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: support 64-bit inums per-sb fix

Expanded Chris's Documentation and Kconfig help on tmpfs inode64. 
TMPFS_INODE64 still there, still default N, but writing down its very
limited limitation does make me wonder again if we want the option.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008011928010.13320@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.rst |   13 ++++++++++---
 fs/Kconfig                          |   16 +++++++++++-----
 2 files changed, 21 insertions(+), 8 deletions(-)

--- a/Documentation/filesystems/tmpfs.rst~tmpfs-support-64-bit-inums-per-sb-fix
+++ a/Documentation/filesystems/tmpfs.rst
@@ -153,11 +153,18 @@ parameters with chmod(1), chown(1) and c
 tmpfs has a mount option to select whether it will wrap at 32- or 64-bit inode
 numbers:
 
+=======   ========================
 inode64   Use 64-bit inode numbers
 inode32   Use 32-bit inode numbers
+=======   ========================
+
+On a 32-bit kernel, inode32 is implicit, and inode64 is refused at mount time.
+On a 64-bit kernel, CONFIG_TMPFS_INODE64 sets the default.  inode64 avoids the
+possibility of multiple files with the same inode number on a single device;
+but risks glibc failing with EOVERFLOW once 33-bit inode numbers are reached -
+if a long-lived tmpfs is accessed by 32-bit applications so ancient that
+opening a file larger than 2GiB fails with EINVAL.
 
-On 64-bit, the default is set by CONFIG_TMPFS_INODE64. On 32-bit, inode64 is
-not legal and will produce an error at mount time.
 
 So 'mount -t tmpfs -o size=10G,nr_inodes=10k,mode=700 tmpfs /mytmpfs'
 will give you tmpfs instance on /mytmpfs which can allocate 10GB
@@ -170,5 +177,5 @@ RAM/SWAP in 10240 inodes and it is only
    Hugh Dickins, 4 June 2007
 :Updated:
    KOSAKI Motohiro, 16 Mar 2010
-Updated:
+:Updated:
    Chris Down, 13 July 2020
--- a/fs/Kconfig~tmpfs-support-64-bit-inums-per-sb-fix
+++ a/fs/Kconfig
@@ -207,12 +207,18 @@ config TMPFS_INODE64
 	default n
 	help
 	  tmpfs has historically used only inode numbers as wide as an unsigned
-	  int. In some cases this can cause wraparound, potentially resulting in
-	  multiple files with the same inode number on a single device. This option
-	  makes tmpfs use the full width of ino_t by default, similarly to the
-	  inode64 mount option.
+	  int. In some cases this can cause wraparound, potentially resulting
+	  in multiple files with the same inode number on a single device. This
+	  option makes tmpfs use the full width of ino_t by default, without
+	  needing to specify the inode64 option when mounting.
 
-	  To override this default, use the inode32 or inode64 mount options.
+	  But if a long-lived tmpfs is to be accessed by 32-bit applications so
+	  ancient that opening a file larger than 2GiB fails with EINVAL, then
+	  the INODE64 config option and inode64 mount option risk operations
+	  failing with EOVERFLOW once 33-bit inode numbers are reached.
+
+	  To override this configured default, use the inode32 or inode64
+	  option when mounting.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-support-64-bit-inums-per-sb-fix.patch
mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch
khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch
khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch
khugepaged-retract_page_tables-remember-to-test-exit.patch
khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch

