Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD1EC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26C02223E4
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgLaSYL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgLaSYL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:24:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66EFD224B0;
        Thu, 31 Dec 2020 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438988;
        bh=bsHiDG0KWW7I0TvfhdIliSBtG0unlTyQcb2UaTssUK0=;
        h=Date:From:To:Subject:From;
        b=AQ5FC30GgFibI0AlQkyPF56plo62K6HtX8u1+/7F78zvqn4r24RqPjmiaa6zP7oo6
         EfWFKn8ZjLVPOytpF+NekuJAcYeMfeJFQwgTaif83qkxTSn5a/RRetgPFFViQiocZ/
         f77jxaj/Stky2lIMvlGABdUlG910HTxDZAenAJmw=
Date:   Thu, 31 Dec 2020 10:23:08 -0800
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, jpoimboe@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rdunlap@infradead.org
Subject:  [merged]
 kdev_t-always-inline-major-minor-helper-functions.patch removed from -mm
 tree
Message-ID: <20201231182308.k3rq8qbBB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kdev_t: always inline major/minor helper functions
has been removed from the -mm tree.  Its filename was
     kdev_t-always-inline-major-minor-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: kdev_t: always inline major/minor helper functions

Silly GCC doesn't always inline these trivial functions.

Fixes the following warning:

  arch/x86/kernel/sys_ia32.o: warning: objtool: cp_stat64()+0xd8: call to new_encode_dev() with UACCESS enabled

Link: https://lkml.kernel.org/r/984353b44a4484d86ba9f73884b7306232e25e30.1608737428.git.jpoimboe@redhat.com
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>	[build-tested]
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdev_t.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/kdev_t.h~kdev_t-always-inline-major-minor-helper-functions
+++ a/include/linux/kdev_t.h
@@ -21,61 +21,61 @@
 	})
 
 /* acceptable for old filesystems */
-static inline bool old_valid_dev(dev_t dev)
+static __always_inline bool old_valid_dev(dev_t dev)
 {
 	return MAJOR(dev) < 256 && MINOR(dev) < 256;
 }
 
-static inline u16 old_encode_dev(dev_t dev)
+static __always_inline u16 old_encode_dev(dev_t dev)
 {
 	return (MAJOR(dev) << 8) | MINOR(dev);
 }
 
-static inline dev_t old_decode_dev(u16 val)
+static __always_inline dev_t old_decode_dev(u16 val)
 {
 	return MKDEV((val >> 8) & 255, val & 255);
 }
 
-static inline u32 new_encode_dev(dev_t dev)
+static __always_inline u32 new_encode_dev(dev_t dev)
 {
 	unsigned major = MAJOR(dev);
 	unsigned minor = MINOR(dev);
 	return (minor & 0xff) | (major << 8) | ((minor & ~0xff) << 12);
 }
 
-static inline dev_t new_decode_dev(u32 dev)
+static __always_inline dev_t new_decode_dev(u32 dev)
 {
 	unsigned major = (dev & 0xfff00) >> 8;
 	unsigned minor = (dev & 0xff) | ((dev >> 12) & 0xfff00);
 	return MKDEV(major, minor);
 }
 
-static inline u64 huge_encode_dev(dev_t dev)
+static __always_inline u64 huge_encode_dev(dev_t dev)
 {
 	return new_encode_dev(dev);
 }
 
-static inline dev_t huge_decode_dev(u64 dev)
+static __always_inline dev_t huge_decode_dev(u64 dev)
 {
 	return new_decode_dev(dev);
 }
 
-static inline int sysv_valid_dev(dev_t dev)
+static __always_inline int sysv_valid_dev(dev_t dev)
 {
 	return MAJOR(dev) < (1<<14) && MINOR(dev) < (1<<18);
 }
 
-static inline u32 sysv_encode_dev(dev_t dev)
+static __always_inline u32 sysv_encode_dev(dev_t dev)
 {
 	return MINOR(dev) | (MAJOR(dev) << 18);
 }
 
-static inline unsigned sysv_major(u32 dev)
+static __always_inline unsigned sysv_major(u32 dev)
 {
 	return (dev >> 18) & 0x3fff;
 }
 
-static inline unsigned sysv_minor(u32 dev)
+static __always_inline unsigned sysv_minor(u32 dev)
 {
 	return dev & 0x3ffff;
 }
_

Patches currently in -mm which might be from jpoimboe@redhat.com are


