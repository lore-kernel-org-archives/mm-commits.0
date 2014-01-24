From: akpm@linux-foundation.org
Subject: [merged]
 lib-parserc-put-export_symbols-in-the-conventional-place.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:49 -0800
Message-ID: <52e2b861./eaRS/+Z9MfZXxWj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, changbin.du@gmail.com, akpm@linux-foundation.org

Subject: [merged] lib-parserc-put-export_symbols-in-the-conventional-place.patch removed from -mm tree
To: akpm@linux-foundation.org,changbin.du@gmail.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:49 -0800


The patch titled
     Subject: lib/parser.c: put EXPORT_SYMBOLs in the conventional place
has been removed from the -mm tree.  Its filename was
     lib-parserc-put-export_symbols-in-the-conventional-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/parser.c: put EXPORT_SYMBOLs in the conventional place

Cc: Du, Changbin <changbin.du@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN lib/parser.c~lib-parserc-put-export_symbols-in-the-conventional-place lib/parser.c
--- a/lib/parser.c~lib-parserc-put-export_symbols-in-the-conventional-place
+++ a/lib/parser.c
@@ -113,6 +113,7 @@ int match_token(char *s, const match_tab
 
 	return p->token;
 }
+EXPORT_SYMBOL(match_token);
 
 /**
  * match_number: scan a number in the given base from a substring_t
@@ -163,6 +164,7 @@ int match_int(substring_t *s, int *resul
 {
 	return match_number(s, result, 0);
 }
+EXPORT_SYMBOL(match_int);
 
 /**
  * match_octal: - scan an octal representation of an integer from a substring_t
@@ -177,6 +179,7 @@ int match_octal(substring_t *s, int *res
 {
 	return match_number(s, result, 8);
 }
+EXPORT_SYMBOL(match_octal);
 
 /**
  * match_hex: - scan a hex representation of an integer from a substring_t
@@ -191,6 +194,7 @@ int match_hex(substring_t *s, int *resul
 {
 	return match_number(s, result, 16);
 }
+EXPORT_SYMBOL(match_hex);
 
 /**
  * match_wildcard: - parse if a string matches given wildcard pattern
@@ -241,6 +245,7 @@ bool match_wildcard(const char *pattern,
 		++p;
 	return !*p;
 }
+EXPORT_SYMBOL(match_wildcard);
 
 /**
  * match_strlcpy: - Copy the characters from a substring_t to a sized buffer
@@ -263,6 +268,7 @@ size_t match_strlcpy(char *dest, const s
 	}
 	return ret;
 }
+EXPORT_SYMBOL(match_strlcpy);
 
 /**
  * match_strdup: - allocate a new string with the contents of a substring_t
@@ -280,11 +286,4 @@ char *match_strdup(const substring_t *s)
 		match_strlcpy(p, s, sz);
 	return p;
 }
-
-EXPORT_SYMBOL(match_token);
-EXPORT_SYMBOL(match_int);
-EXPORT_SYMBOL(match_octal);
-EXPORT_SYMBOL(match_hex);
-EXPORT_SYMBOL(match_wildcard);
-EXPORT_SYMBOL(match_strlcpy);
 EXPORT_SYMBOL(match_strdup);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

