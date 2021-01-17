Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD3AC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 19:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6AC207B5
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 19:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbhAQTgH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 14:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730192AbhAQTeR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 14:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AABA224BD;
        Sun, 17 Jan 2021 19:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610912016;
        bh=JnKZGsdkmsWsXeVuJ9mA4Lqwp5FRe54gQoJtdC40Esc=;
        h=Date:From:To:Subject:From;
        b=s2jGimeYljORzCWcRlBiT4GNxwF/53vLHeZ3MGkMRFvW2tcm1RRZ2oe2qclr0PWXp
         MmsfvtEpA1JbPiewtPVz1UDIXJKn+KHkPTQ6cdEmAVwg+lbehxKnZFSZm5NjO+Vp6n
         oTCmaQceA8x99X0JcWuCcgf/DYz2bUaA9yDlqhrQ=
Date:   Sun, 17 Jan 2021 11:33:34 -0800
From:   akpm@linux-foundation.org
To:     akinobu.mita@gmail.com, john.ogness@linutronix.de,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, roman.fietze@magna.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, timur@kernel.org
Subject:  +
 lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses.patch
 added to -mm tree
Message-ID: <20210117193334.ox1To39I2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/hexdump: introduce DUMP_PREFIX_UNHASHED for unhashed addresses
has been added to the -mm tree.  Its filename is
     lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Timur Tabi <timur@kernel.org>
Subject: lib/hexdump: introduce DUMP_PREFIX_UNHASHED for unhashed addresses

Patch series "introduce DUMP_PREFIX_UNHASHED for hex dumps".

First patch updates print_hex_dump() and related functions to
allow callers to print hex dumps with unhashed addresses.  It
adds a new prefix type, so existing code is unchanged.

Second patch changes a page poising function to use the new address type. 
This is an example of a change.

Hashed addresses make very little sense for hex dumps, which print
addresses in 16- or 32-byte increments.  Typical use-case is to correlate
an addresses in between one of these increments with some other address,
but that can't be done if the addresses are hashed.  I expect most
developers to want to replace their usage of DUMP_PREFIX_ADDRESS with
DUMP_PREFIX_UNHASHED, now that they have the opportunity.


This patch (of 2):

Hashed addresses are useless in hexdumps unless you're comparing with
other hashed addresses, which is unlikely.  However, there's no need to
break existing code, so introduce a new prefix type that prints unhashed
addresses.

Link: https://lkml.kernel.org/r/20210116220950.47078-1-timur@kernel.org
Link: https://lkml.kernel.org/r/20210116220950.47078-2-timur@kernel.org
Signed-off-by: Timur Tabi <timur@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Roman Fietze <roman.fietze@magna.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c          |    3 +++
 include/linux/printk.h |    8 +++++---
 lib/hexdump.c          |    9 +++++++--
 lib/seq_buf.c          |    9 +++++++--
 4 files changed, 22 insertions(+), 7 deletions(-)

--- a/fs/seq_file.c~lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses
+++ a/fs/seq_file.c
@@ -864,6 +864,9 @@ void seq_hex_dump(struct seq_file *m, co
 		remaining -= rowsize;
 
 		switch (prefix_type) {
+		case DUMP_PREFIX_UNHASHED:
+			seq_printf(m, "%s%px: ", prefix_str, ptr + i);
+			break;
 		case DUMP_PREFIX_ADDRESS:
 			seq_printf(m, "%s%p: ", prefix_str, ptr + i);
 			break;
--- a/include/linux/printk.h~lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses
+++ a/include/linux/printk.h
@@ -567,7 +567,8 @@ extern const struct file_operations kmsg
 enum {
 	DUMP_PREFIX_NONE,
 	DUMP_PREFIX_ADDRESS,
-	DUMP_PREFIX_OFFSET
+	DUMP_PREFIX_OFFSET,
+	DUMP_PREFIX_UNHASHED,
 };
 extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 			      int groupsize, char *linebuf, size_t linebuflen,
@@ -612,8 +613,9 @@ static inline void print_hex_dump_debug(
  * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
- * @prefix_type: controls whether prefix of an offset, address, or none
- *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @prefix_type: controls whether prefix of an offset, hashed address,
+ *  unhashed address, or none is printed (%DUMP_PREFIX_OFFSET,
+ *  %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_UNHASHED, %DUMP_PREFIX_NONE)
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  *
--- a/lib/hexdump.c~lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses
+++ a/lib/hexdump.c
@@ -211,8 +211,9 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * @level: kernel log level (e.g. KERN_DEBUG)
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
- * @prefix_type: controls whether prefix of an offset, address, or none
- *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @prefix_type: controls whether prefix of an offset, hashed address,
+ *  unhashed address, or none is printed (%DUMP_PREFIX_OFFSET,
+ *  %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_UNHASHED, %DUMP_PREFIX_NONE)
  * @rowsize: number of bytes to print per line; must be 16 or 32
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @buf: data blob to dump
@@ -256,6 +257,10 @@ void print_hex_dump(const char *level, c
 				   linebuf, sizeof(linebuf), ascii);
 
 		switch (prefix_type) {
+		case DUMP_PREFIX_UNHASHED:
+			printk("%s%s%px: %s\n",
+			       level, prefix_str, ptr + i, linebuf);
+			break;
 		case DUMP_PREFIX_ADDRESS:
 			printk("%s%s%p: %s\n",
 			       level, prefix_str, ptr + i, linebuf);
--- a/lib/seq_buf.c~lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses
+++ a/lib/seq_buf.c
@@ -335,8 +335,9 @@ int seq_buf_to_user(struct seq_buf *s, c
  * @s: seq_buf descriptor
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
- * @prefix_type: controls whether prefix of an offset, address, or none
- *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @prefix_type: controls whether prefix of an offset, hashed address,
+ *  unhashed address, or none is printed (%DUMP_PREFIX_OFFSET,
+ *  %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_UNHASHED, %DUMP_PREFIX_NONE)
  * @rowsize: number of bytes to print per line; must be 16 or 32
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @buf: data blob to dump
@@ -374,6 +375,10 @@ int seq_buf_hex_dump(struct seq_buf *s,
 				   linebuf, sizeof(linebuf), ascii);
 
 		switch (prefix_type) {
+		case DUMP_PREFIX_UNHASHED:
+			ret = seq_buf_printf(s, "%s%px: %s\n",
+			       prefix_str, ptr + i, linebuf);
+			break;
 		case DUMP_PREFIX_ADDRESS:
 			ret = seq_buf_printf(s, "%s%p: %s\n",
 			       prefix_str, ptr + i, linebuf);
_

Patches currently in -mm which might be from timur@kernel.org are

lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses.patch
mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem.patch

