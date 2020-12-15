Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D31C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A710E22473
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgLODHO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgLODG7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:59 -0500
Date:   Mon, 14 Dec 2020 19:06:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001578;
        bh=NwJO++7QK5ROsFz/OL/8Th4cLIDb0WSWGl/3XKJ4EVM=;
        h=From:To:Subject:In-Reply-To:From;
        b=YqNmsclZXbdQEnKvpIOTmvFWi2RJ0NHk+i+ZYDaUKVeR8SFBhAJ1mOYSElsjzAbLH
         0mlp6AgmlTQx2qDw4R/0elb317v7hr/eajW8+jgOZICQXCLwhKzaNAQZsBD/+YHMQJ
         kzLm3bkj/lcW+6A2IX7s7aif86UQ6Hm4CdoRvb2k=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, hughd@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 054/200] tmpfs: fix Documentation nits
Message-ID: <20201215030617.5cjzweaVA%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: tmpfs: fix Documentation nits

Fix a typo, punctuation, use uppercase for CPUs, and limit
tmpfs to keeping only its files in virtual memory (phrasing).

Link: https://lkml.kernel.org/r/20201202010934.18566-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/filesystems/tmpfs.rst~tmpfs-fix-documentation-nits
+++ a/Documentation/filesystems/tmpfs.rst
@@ -4,7 +4,7 @@
 Tmpfs
 =====
 
-Tmpfs is a file system which keeps all files in virtual memory.
+Tmpfs is a file system which keeps all of its files in virtual memory.
 
 
 Everything in tmpfs is temporary in the sense that no files will be
@@ -35,7 +35,7 @@ tmpfs has the following uses:
    memory.
 
    This mount does not depend on CONFIG_TMPFS. If CONFIG_TMPFS is not
-   set, the user visible part of tmpfs is not build. But the internal
+   set, the user visible part of tmpfs is not built. But the internal
    mechanisms are always present.
 
 2) glibc 2.2 and above expects tmpfs to be mounted at /dev/shm for
@@ -50,7 +50,7 @@ tmpfs has the following uses:
    This mount is _not_ needed for SYSV shared memory. The internal
    mount is used for that. (In the 2.3 kernel versions it was
    necessary to mount the predecessor of tmpfs (shm fs) to use SYSV
-   shared memory)
+   shared memory.)
 
 3) Some people (including me) find it very convenient to mount it
    e.g. on /tmp and /var/tmp and have a big swap partition. And now
@@ -83,7 +83,7 @@ If nr_blocks=0 (or size=0), blocks will
 if nr_inodes=0, inodes will not be limited.  It is generally unwise to
 mount with such options, since it allows any user with write access to
 use up all the memory on the machine; but enhances the scalability of
-that instance in a system with many cpus making intensive use of it.
+that instance in a system with many CPUs making intensive use of it.
 
 
 tmpfs has a mount option to set the NUMA memory allocation policy for
_
