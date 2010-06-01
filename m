From: akpm@linux-foundation.org
Subject: + tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:51:59 -0700
Message-ID: <201006012151.o51LpxAF021027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243Ab0FAVwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com, hughd@google.com, tim.c.chen@linux.intel.com


The patch titled
     tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix
has been added to the -mm tree.  Its filename is
     tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment typo
repair kerneldoc

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/qtoken.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN lib/qtoken.c~tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix lib/qtoken.c
--- a/lib/qtoken.c~tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix
+++ a/lib/qtoken.c
@@ -58,7 +58,7 @@
  * the cache is disabled (i.e. value -1).  For this case,
  * @tokens are returned to common pool.
  * If the number of tokens in current cpu's cache exceed
- * a a highmark, we will return the extra tokens into the
+ * a highmark, we will return the extra tokens into the
  * common pool.
  */
 void qtoken_return(struct qtoken *token_jar, unsigned long tokens)
@@ -100,7 +100,7 @@ void qtoken_return(struct qtoken *token_
 EXPORT_SYMBOL(qtoken_return);
 
 /**
- * qtoken_reap cache: Move tokens from cache into common pool in token jar
+ * qtoken_reap_cache - move tokens from cache into common pool in token jar
  *
  * @token_jar: pointer to token jar
  *
@@ -123,7 +123,7 @@ static void qtoken_reap_cache(struct qto
 }
 
 /**
- * qtoken_from pool: Get tokens from common pool in token jar
+ * qtoken_from_pool - get tokens from common pool in token jar
  *
  * @token_jar: pointer to struct qtoken
  * @tokens: the number of tokens to acquire from token jar
@@ -150,7 +150,7 @@ static int qtoken_from_pool(struct qtoke
 }
 
 /**
- * qtoken_get: Get tokens from token jar
+ * qtoken_get - get tokens from token jar
  *
  * @token_jar: pointer to struct qtoken
  * @tokens: the number of tokens to acquire from token jar
@@ -217,7 +217,7 @@ int qtoken_get(struct qtoken *token_jar,
 EXPORT_SYMBOL(qtoken_get);
 
 /**
- * qtoken_init: Init token jar
+ * qtoken_init - init token jar
  *
  * @token_jar: pointer to token jar
  * @total_tokens: the total number of tokens that the token jar holds
@@ -266,7 +266,7 @@ void qtoken_free(struct qtoken *token_ja
 EXPORT_SYMBOL(qtoken_free);
 
 /**
- * qtoken_avail: Calculates token available in token jar
+ * qtoken_avail - calculates token available in token jar
  *
  * @token_jar: pointer to token jar
  *
@@ -295,7 +295,7 @@ unsigned long qtoken_avail(struct qtoken
 EXPORT_SYMBOL(qtoken_avail);
 
 /**
- * qtoken_resize: Resize the total number of tokens in token jar
+ * qtoken_resize - resize the total number of tokens in token jar
  *
  * @token_jar: pointer to token jar
  * @new_size: new total number of tokens in token jar
@@ -337,7 +337,7 @@ void qtoken_return(struct qtoken *token_
 EXPORT_SYMBOL(qtoken_return);
 
 /**
- * qtoken_get: Get tokens from token jar
+ * qtoken_get - get tokens from token jar
  *
  * @token_jar: pointer to struct qtoken
  * @tokens: the number of tokens to acquire from token jar
@@ -364,7 +364,7 @@ int qtoken_get(struct qtoken *token_jar,
 EXPORT_SYMBOL(qtoken_get);
 
 /**
- * qtoken_init: Init token jar
+ * qtoken_init - init token jar
  *
  * @token_jar: pointer to token jar
  * @total_tokens: the total number of tokens that the token jar holds
@@ -383,7 +383,7 @@ int qtoken_init(struct qtoken *token_jar
 EXPORT_SYMBOL(qtoken_init);
 
 /**
- * qtoken_free: Free token jar
+ * qtoken_free - free token jar
  *
  * @token_jar: pointer to token jar
  *
@@ -397,7 +397,7 @@ void qtoken_free(struct qtoken *token_ja
 EXPORT_SYMBOL(qtoken_free);
 
 /**
- * qtoken_avail: Calculate the tokens available in token jar
+ * qtoken_avail - calculate the tokens available in token jar
  *
  * @token_jar: pointer to token jar
  *
@@ -409,7 +409,7 @@ unsigned long qtoken_avail(struct qtoken
 EXPORT_SYMBOL(qtoken_avail);
 
 /**
- * qtoken_resize: Resize the total number of tokens in token jar
+ * qtoken_resize - resize the total number of tokens in token jar
  *
  * @token_jar: pointer to token jar
  * @new_size: new total number of tokens in token jar
@@ -434,7 +434,7 @@ EXPORT_SYMBOL(qtoken_resize);
 #endif /* CONFIG_SMP */
 
 /**
- * qtoken_total: Return the total number of tokens configured for token jar
+ * qtoken_total - return the total number of tokens configured for token jar
  *
  * @token_jar: pointer to token jar
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
arch-x86-kernel-add-missing-spin_unlock.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
lib-kobject_ueventc-fix-conig_net=n-warning.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

