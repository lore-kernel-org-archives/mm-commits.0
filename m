Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8E2C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC2A261CBE
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhGHBKO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhGHBKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D07961CCC;
        Thu,  8 Jul 2021 01:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706452;
        bh=zhScqdfzfl5g76XvOy5b6haeDQR/R6hNOnriJt2cScQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s0z7DkH1dW7QRrBVnzjE6weiyWSR17sJ55NLyz8dEpqD2leq6nc3Ck9jNrTJV7fmW
         K/M++f3Vd/qnmrwETrcLCqaBH/Jm3kk8KJim3p4WpGPhjdRbArqysaQSLJfVySY0aw
         Yv4vX3O8k236DsHKV1cLQHO4YqWhaj+hDbI9FRPo=
Date:   Wed, 07 Jul 2021 18:07:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jacob.e.keller@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 02/54] lib: fix spelling mistakes
Message-ID: <20210708010731.vbpjpmOZz%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: lib: fix spelling mistakes

Fix some spelling mistakes in comments:
permanentely ==> permanently
wont ==> won't
remaning ==> remaining
succed ==> succeed
shouldnt ==> shouldn't
alpha-numeric ==> alphanumeric
storeing ==> storing
funtion ==> function
documenation ==> documentation
Determin ==> Determine
intepreted ==> interpreted
ammount ==> amount
obious ==> obvious
interupts ==> interrupts
occured ==> occurred
asssociated ==> associated
taking into acount ==> taking into account
squence ==> sequence
stil ==> still
contiguos ==> contiguous
matchs ==> matches

Link: https://lkml.kernel.org/r/20210607072555.12416-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug             |    6 +++---
 lib/asn1_encoder.c            |    2 +-
 lib/devres.c                  |    2 +-
 lib/dynamic_debug.c           |    2 +-
 lib/fonts/font_pearl_8x8.c    |    2 +-
 lib/kfifo.c                   |    2 +-
 lib/list_sort.c               |    2 +-
 lib/nlattr.c                  |    4 ++--
 lib/oid_registry.c            |    2 +-
 lib/pldmfw/pldmfw.c           |    2 +-
 lib/reed_solomon/test_rslib.c |    2 +-
 lib/refcount.c                |    2 +-
 lib/rhashtable.c              |    2 +-
 lib/sbitmap.c                 |    2 +-
 lib/scatterlist.c             |    4 ++--
 lib/seq_buf.c                 |    2 +-
 lib/sort.c                    |    2 +-
 lib/stackdepot.c              |    2 +-
 lib/vsprintf.c                |    2 +-
 19 files changed, 23 insertions(+), 23 deletions(-)

--- a/lib/asn1_encoder.c~lib-fix-spelling-mistakes
+++ a/lib/asn1_encoder.c
@@ -181,7 +181,7 @@ EXPORT_SYMBOL_GPL(asn1_encode_oid);
 /**
  * asn1_encode_length() - encode a length to follow an ASN.1 tag
  * @data: pointer to encode at
- * @data_len: pointer to remaning length (adjusted by routine)
+ * @data_len: pointer to remaining length (adjusted by routine)
  * @len: length to encode
  *
  * This routine can encode lengths up to 65535 using the ASN.1 rules.
--- a/lib/devres.c~lib-fix-spelling-mistakes
+++ a/lib/devres.c
@@ -355,7 +355,7 @@ static void pcim_iomap_release(struct de
  * detach.
  *
  * This function might sleep when the table is first allocated but can
- * be safely called without context and guaranteed to succed once
+ * be safely called without context and guaranteed to succeed once
  * allocated.
  */
 void __iomem * const *pcim_iomap_table(struct pci_dev *pdev)
--- a/lib/dynamic_debug.c~lib-fix-spelling-mistakes
+++ a/lib/dynamic_debug.c
@@ -991,7 +991,7 @@ static int ddebug_dyndbg_param_cb(char *
 
 	ddebug_exec_queries((val ? val : "+p"), modname);
 
-	return 0; /* query failure shouldnt stop module load */
+	return 0; /* query failure shouldn't stop module load */
 }
 
 /* handle both dyndbg and $module.dyndbg params at boot */
--- a/lib/fonts/font_pearl_8x8.c~lib-fix-spelling-mistakes
+++ a/lib/fonts/font_pearl_8x8.c
@@ -3,7 +3,7 @@
 /*                                            */
 /*       Font file generated by cpi2fnt       */
 /*       ------------------------------       */
-/*       Combined with the alpha-numeric      */
+/*       Combined with the alphanumeric       */
 /*       portion of Greg Harp's old PEARL     */
 /*       font (from earlier versions of       */
 /*       linux-m86k) by John Shifflett        */
--- a/lib/Kconfig.debug~lib-fix-spelling-mistakes
+++ a/lib/Kconfig.debug
@@ -1282,7 +1282,7 @@ config PROVE_RAW_LOCK_NESTING
 	 option expect lockdep splats until these problems have been fully
 	 addressed which is work in progress. This config switch allows to
 	 identify and analyze these problems. It will be removed and the
-	 check permanentely enabled once the main issues have been fixed.
+	 check permanently enabled once the main issues have been fixed.
 
 	 If unsure, select N.
 
@@ -1448,7 +1448,7 @@ config DEBUG_LOCKING_API_SELFTESTS
 	  Say Y here if you want the kernel to run a short self-test during
 	  bootup. The self-test checks whether common types of locking bugs
 	  are detected by debugging mechanisms or not. (if you disable
-	  lock debugging then those bugs wont be detected of course.)
+	  lock debugging then those bugs won't be detected of course.)
 	  The following locking APIs are covered: spinlocks, rwlocks,
 	  mutexes and rwsems.
 
@@ -1928,7 +1928,7 @@ config FAIL_IO_TIMEOUT
 	  thus exercising the error handling.
 
 	  Only works with drivers that use the generic timeout handling,
-	  for others it wont do anything.
+	  for others it won't do anything.
 
 config FAIL_FUTEX
 	bool "Fault-injection capability for futexes"
--- a/lib/kfifo.c~lib-fix-spelling-mistakes
+++ a/lib/kfifo.c
@@ -415,7 +415,7 @@ static unsigned int __kfifo_peek_n(struc
 	)
 
 /*
- * __kfifo_poke_n internal helper function for storeing the length of
+ * __kfifo_poke_n internal helper function for storing the length of
  * the record into the fifo
  */
 static void __kfifo_poke_n(struct __kfifo *fifo, unsigned int n, size_t recsize)
--- a/lib/list_sort.c~lib-fix-spelling-mistakes
+++ a/lib/list_sort.c
@@ -104,7 +104,7 @@ static void merge_final(void *priv, list
  * @head: the list to sort
  * @cmp: the elements comparison function
  *
- * The comparison funtion @cmp must return > 0 if @a should sort after
+ * The comparison function @cmp must return > 0 if @a should sort after
  * @b ("@a > @b" if you want an ascending sort), and <= 0 if @a should
  * sort before @b *or* their original order should be preserved.  It is
  * always called with the element that came first in the input in @a,
--- a/lib/nlattr.c~lib-fix-spelling-mistakes
+++ a/lib/nlattr.c
@@ -619,7 +619,7 @@ static int __nla_validate_parse(const st
  * Validates all attributes in the specified attribute stream against the
  * specified policy. Validation depends on the validate flags passed, see
  * &enum netlink_validation for more details on that.
- * See documenation of struct nla_policy for more details.
+ * See documentation of struct nla_policy for more details.
  *
  * Returns 0 on success or a negative error code.
  */
@@ -633,7 +633,7 @@ int __nla_validate(const struct nlattr *
 EXPORT_SYMBOL(__nla_validate);
 
 /**
- * nla_policy_len - Determin the max. length of a policy
+ * nla_policy_len - Determine the max. length of a policy
  * @policy: policy to use
  * @n: number of policies
  *
--- a/lib/oid_registry.c~lib-fix-spelling-mistakes
+++ a/lib/oid_registry.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL_GPL(parse_OID);
  * @bufsize: The size of the buffer
  *
  * The OID is rendered into the buffer in "a.b.c.d" format and the number of
- * bytes is returned.  -EBADMSG is returned if the data could not be intepreted
+ * bytes is returned.  -EBADMSG is returned if the data could not be interpreted
  * and -ENOBUFS if the buffer was too small.
  */
 int sprint_oid(const void *data, size_t datasize, char *buffer, size_t bufsize)
--- a/lib/pldmfw/pldmfw.c~lib-fix-spelling-mistakes
+++ a/lib/pldmfw/pldmfw.c
@@ -82,7 +82,7 @@ pldm_check_fw_space(struct pldmfw_priv *
  * @bytes_to_move: number of bytes to move the offset forward by
  *
  * Check that there is enough space past the current offset, and then move the
- * offset forward by this ammount.
+ * offset forward by this amount.
  *
  * Returns: zero on success, or -EFAULT if the image is too small to fit the
  * expected length.
--- a/lib/reed_solomon/test_rslib.c~lib-fix-spelling-mistakes
+++ a/lib/reed_solomon/test_rslib.c
@@ -385,7 +385,7 @@ static void test_bc(struct rs_control *r
 
 			/*
 			 * We check that the returned word is actually a
-			 * codeword. The obious way to do this would be to
+			 * codeword. The obvious way to do this would be to
 			 * compute the syndrome, but we don't want to replicate
 			 * that code here. However, all the codes are in
 			 * systematic form, and therefore we can encode the
--- a/lib/refcount.c~lib-fix-spelling-mistakes
+++ a/lib/refcount.c
@@ -164,7 +164,7 @@ EXPORT_SYMBOL(refcount_dec_and_lock);
  * @flags: saved IRQ-flags if the is acquired
  *
  * Same as refcount_dec_and_lock() above except that the spinlock is acquired
- * with disabled interupts.
+ * with disabled interrupts.
  *
  * Return: true and hold spinlock if able to decrement refcount to 0, false
  *         otherwise
--- a/lib/rhashtable.c~lib-fix-spelling-mistakes
+++ a/lib/rhashtable.c
@@ -703,7 +703,7 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_exit);
  *
  * Returns zero if successful.
  *
- * Returns -EAGAIN if resize event occured.  Note that the iterator
+ * Returns -EAGAIN if resize event occurred.  Note that the iterator
  * will rewind back to the beginning and you may use it immediately
  * by calling rhashtable_walk_next.
  *
--- a/lib/sbitmap.c~lib-fix-spelling-mistakes
+++ a/lib/sbitmap.c
@@ -583,7 +583,7 @@ void sbitmap_queue_clear(struct sbitmap_
 	/*
 	 * Once the clear bit is set, the bit may be allocated out.
 	 *
-	 * Orders READ/WRITE on the asssociated instance(such as request
+	 * Orders READ/WRITE on the associated instance(such as request
 	 * of blk_mq) by this bit for avoiding race with re-allocation,
 	 * and its pair is the memory barrier implied in __sbitmap_get_word.
 	 *
--- a/lib/scatterlist.c~lib-fix-spelling-mistakes
+++ a/lib/scatterlist.c
@@ -38,7 +38,7 @@ EXPORT_SYMBOL(sg_next);
  * @sg:		The scatterlist
  *
  * Description:
- * Allows to know how many entries are in sg, taking into acount
+ * Allows to know how many entries are in sg, taking into account
  * chaining as well
  *
  **/
@@ -59,7 +59,7 @@ EXPORT_SYMBOL(sg_nents);
  *
  * Description:
  * Determines the number of entries in sg that are required to meet
- * the supplied length, taking into acount chaining as well
+ * the supplied length, taking into account chaining as well
  *
  * Returns:
  *   the number of sg entries needed, negative error on failure
--- a/lib/seq_buf.c~lib-fix-spelling-mistakes
+++ a/lib/seq_buf.c
@@ -289,7 +289,7 @@ int seq_buf_path(struct seq_buf *s, cons
 }
 
 /**
- * seq_buf_to_user - copy the squence buffer to user space
+ * seq_buf_to_user - copy the sequence buffer to user space
  * @s: seq_buf descriptor
  * @ubuf: The userspace memory location to copy to
  * @cnt: The amount to copy
--- a/lib/sort.c~lib-fix-spelling-mistakes
+++ a/lib/sort.c
@@ -51,7 +51,7 @@ static bool is_aligned(const void *base,
  * which basically all CPUs have, to minimize loop overhead computations.
  *
  * For some reason, on x86 gcc 7.3.0 adds a redundant test of n at the
- * bottom of the loop, even though the zero flag is stil valid from the
+ * bottom of the loop, even though the zero flag is still valid from the
  * subtract (since the intervening mov instructions don't alter the flags).
  * Gcc 8.1.0 doesn't have that problem.
  */
--- a/lib/stackdepot.c~lib-fix-spelling-mistakes
+++ a/lib/stackdepot.c
@@ -11,7 +11,7 @@
  * Instead, stack depot maintains a hashtable of unique stacktraces. Since alloc
  * and free stacks repeat a lot, we save about 100x space.
  * Stacks are never removed from depot, so we store them contiguously one after
- * another in a contiguos memory allocation.
+ * another in a contiguous memory allocation.
  *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
--- a/lib/vsprintf.c~lib-fix-spelling-mistakes
+++ a/lib/vsprintf.c
@@ -3417,7 +3417,7 @@ int vsscanf(const char *buf, const char
 
 	while (*fmt) {
 		/* skip any white space in format */
-		/* white space in format matchs any amount of
+		/* white space in format matches any amount of
 		 * white space, including none, in the input.
 		 */
 		if (isspace(*fmt)) {
_
