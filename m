Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EE6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357496AbiCYBhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357499AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AF433A24
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76B41B82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350E2C340EC;
        Fri, 25 Mar 2022 01:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172031;
        bh=TeeIJlG3DaCa8chK5Ra4DB/sELxZIeBgV74MQ5wlLAw=;
        h=Date:To:From:Subject:From;
        b=HPv2k4VIM+ifFvO+UebwYv0AcvNwsEQY+oe3RXxpZ3oRkpG9fSU4Hs05zfMWYB5YR
         LLMwXJrfvoI2omO9wffCT9nXyMngOepm2ZfESrr0UyxUFABTkQDnJqAhsoEMJrV1CV
         zg8opbngzzQsw4AUymcboewcyYRz+pedk5u3clwI=
Date:   Thu, 24 Mar 2022 18:33:50 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        tiantao6@hisilicon.com, mike.travis@hpe.com,
        linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-bitmap-fix-many-kernel-doc-warnings.patch removed from -mm tree
Message-Id: <20220325013351.350E2C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: fix many kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     lib-bitmap-fix-many-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


