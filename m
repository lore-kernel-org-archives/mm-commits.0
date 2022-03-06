Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BF7C433F5
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 23:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiCFXP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 18:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiCFXP1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 18:15:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D86E1EAD9
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 15:14:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E450B60F99
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 23:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41969C340EF;
        Sun,  6 Mar 2022 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646608473;
        bh=Y0Ud6DHBkjildEYHEFVj72PEbD+/KiB1qsLd+2TTZrc=;
        h=Date:To:From:Subject:From;
        b=btJsNei7gH72TgVYFnDTYKu8Em8DT9ZjNPw8oBFYtLTgtAcAvmDgPnepEQECfhRO3
         iUWAESWxdhJDyouB/tsvQNNqw9YbAlEa+vsZE7yvytPF+r5jLIHyIeC6Oz5yxgLKWD
         S34z4dD8+aj59pqfB5RbW/fvHmlkmJH7ONIWQurw=
Date:   Sun, 06 Mar 2022 15:14:32 -0800
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        tiantao6@hisilicon.com, mike.travis@hpe.com,
        linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bitmap-fix-many-kernel-doc-warnings.patch added to -mm tree
Message-Id: <20220306231433.41969C340EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: fix many kernel-doc warnings
has been added to the -mm tree.  Its filename is
     lib-bitmap-fix-many-kernel-doc-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-fix-many-kernel-doc-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-fix-many-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: bitmap: fix many kernel-doc warnings

Fix kernel-doc warings in lib/bitmap.c:

../lib/bitmap.c:498: warning: Function parameter or member 'buf' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:498: warning: Function parameter or member 'maskp' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:498: warning: Function parameter or member 'nmaskbits' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:498: warning: Function parameter or member 'off' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:498: warning: Function parameter or member 'count' not described in 'bitmap_print_to_buf'
../lib/bitmap.c:561: warning: contents before sections
../lib/bitmap.c:606: warning: Function parameter or member 'buf' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:606: warning: Function parameter or member 'maskp' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:606: warning: Function parameter or member 'nmaskbits' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:606: warning: Function parameter or member 'off' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:606: warning: Function parameter or member 'count' not described in 'bitmap_print_list_to_buf'
../lib/bitmap.c:819: warning: missing initial short description on line:
 * bitmap_parselist_user()

This still leaves 15 warnings for function return values not described,
similar to this one:
bitmap.c:890: warning: No description found for return value of 'bitmap_parse'

Link: https://lkml.kernel.org/r/20220306065823.5153-1-rdunlap@infradead.org
Fixes: 1fae562983ca ("cpumask: introduce cpumap_print_list/bitmask_to_buf to support large bitmask and list")
Fixes: 4b060420a596 ("bitmap, irq: add smp_affinity_list interface to /proc/irq")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tian Tao <tiantao6@hisilicon.com>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/lib/bitmap.c~lib-bitmap-fix-many-kernel-doc-warnings
+++ a/lib/bitmap.c
@@ -492,6 +492,11 @@ EXPORT_SYMBOL(bitmap_print_to_pagebuf);
  * @list: indicates whether the bitmap must be list
  *      true:  print in decimal list format
  *      false: print in hexadecimal bitmask format
+ * @buf: buffer into which string is placed
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ * @off: in the string from which we are copying, We copy to @buf
+ * @count: the maximum number of bytes to print
  */
 static int bitmap_print_to_buf(bool list, char *buf, const unsigned long *maskp,
 		int nmaskbits, loff_t off, size_t count)
@@ -512,6 +517,11 @@ static int bitmap_print_to_buf(bool list
 
 /**
  * bitmap_print_bitmask_to_buf  - convert bitmap to hex bitmask format ASCII string
+ * @buf: buffer into which string is placed
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ * @off: in the string from which we are copying, We copy to @buf
+ * @count: the maximum number of bytes to print
  *
  * The bitmap_print_to_pagebuf() is used indirectly via its cpumap wrapper
  * cpumap_print_to_pagebuf() or directly by drivers to export hexadecimal
@@ -553,12 +563,6 @@ static int bitmap_print_to_buf(bool list
  * move to use bin_attribute. In result, we have to pass the corresponding
  * parameters such as off, count from bin_attribute show entry to this API.
  *
- * @buf: buffer into which string is placed
- * @maskp: pointer to bitmap to convert
- * @nmaskbits: size of bitmap, in bits
- * @off: in the string from which we are copying, We copy to @buf
- * @count: the maximum number of bytes to print
- *
  * The role of cpumap_print_bitmask_to_buf() and cpumap_print_list_to_buf()
  * is similar with cpumap_print_to_pagebuf(),  the difference is that
  * bitmap_print_to_pagebuf() mainly serves sysfs attribute with the assumption
@@ -597,6 +601,11 @@ EXPORT_SYMBOL(bitmap_print_bitmask_to_bu
 
 /**
  * bitmap_print_list_to_buf  - convert bitmap to decimal list format ASCII string
+ * @buf: buffer into which string is placed
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ * @off: in the string from which we are copying, We copy to @buf
+ * @count: the maximum number of bytes to print
  *
  * Everything is same with the above bitmap_print_bitmask_to_buf() except
  * the print format.
@@ -807,7 +816,8 @@ EXPORT_SYMBOL(bitmap_parselist);
 
 
 /**
- * bitmap_parselist_user()
+ * bitmap_parselist_user() - convert user buffer's list format ASCII
+ * string to bitmap
  *
  * @ubuf: pointer to user buffer containing string.
  * @ulen: buffer size in bytes.  If string is smaller than this
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
lib-bitmap-fix-many-kernel-doc-warnings.patch
inith-improve-__setup-and-early_param-documentation.patch
init-mainc-return-1-from-handled-__setup-functions.patch
docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch

