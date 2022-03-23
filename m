Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70896C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345378AbiCWXHa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345385AbiCWXH1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EF090275
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A63B0B8214D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48729C36AE3;
        Wed, 23 Mar 2022 23:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076754;
        bh=qsNtJO1EDFMTWeba9rFDogMOxGvEm9wYJEUnCCUlB9M=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=LQtAxDe8Esd0GikdLQbs0oaNVtI3e5UYvvW9ecWbJ/C7MeFkvKOR3l0jcVMLgTXQ7
         mG5Xr+yT/TGCmpx6EYFxpsyxZMC4qblfCESTgHiKs64L1n1DzxsV5C+wAEemTlCzJj
         soXvhE2yfZp70JafpL3GvY8SNZGqQh6oiGzeghnA=
Date:   Wed, 23 Mar 2022 16:05:53 -0700
To:     yury.norov@gmail.com, tiantao6@hisilicon.com, mike.travis@hpe.com,
        linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org,
        andriy.shevchenko@linux.intel.com, rdunlap@infradead.org,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 12/41] lib: bitmap: fix many kernel-doc warnings
Message-Id: <20220323230554.48729C36AE3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
