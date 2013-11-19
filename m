From: akpm@linux-foundation.org
Subject: + lib-parserc-put-export_symbols-in-the-conventional-place.patch
 added to -mm tree
Date: Tue, 19 Nov 2013 15:36:20 -0800
Message-ID: <528bf5f4.DRzWTBZxQpoSCjWJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3KSXgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 18:36:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, changbin.du@gmail.com, akpm@linux-foundation.org

Subject: + lib-parserc-put-export_symbols-in-the-conventional-place.patch added to -mm tree
To: akpm@linux-foundation.org,changbin.du@gmail.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 15:36:20 -0800


The patch titled
     Subject: lib/parser.c: put EXPORT_SYMBOLs in the conventional place
has been added to the -mm tree.  Its filename is
     lib-parserc-put-export_symbols-in-the-conventional-place.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-parserc-put-export_symbols-in-the-conventional-place.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-parserc-put-export_symbols-in-the-conventional-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch

