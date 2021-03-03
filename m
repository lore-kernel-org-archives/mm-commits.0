Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913A1C15504
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 606FD64EC0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhCDA7O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355608AbhCDAcG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:32:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9AF764EDB;
        Wed,  3 Mar 2021 23:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614813124;
        bh=JbT+HA6oeK7pDPva/zM/ypHXIZXsvFFWNMiy51kNWfY=;
        h=Date:From:To:Subject:From;
        b=c7TrD/1F/T+p07Cn9XLo6YcvXnOmB4ZPyEGxIXde2EoKLkXTb9LnGgBXptDkEdas3
         HeTxq4oOgItyrgEM3NmhQThvGWHxJaSCR6tiLJ1BoWggaIYp7fnj7Ecvk16/LJhH74
         vYKI+JOKhyIa4hlPmnpL/hBVNUrGdqilvqnbLL0o=
Date:   Wed, 03 Mar 2021 15:12:03 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, christophe.leroy@csgroup.eu,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org
Subject:  + kfence-fix-printk-format-for-ptrdiff_t.patch added to
 -mm tree
Message-ID: <20210303231203.d4m554F5t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: fix printk format for ptrdiff_t
has been added to the -mm tree.  Its filename is
     kfence-fix-printk-format-for-ptrdiff_t.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-fix-printk-format-for-ptrdiff_t.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-fix-printk-format-for-ptrdiff_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: fix printk format for ptrdiff_t

Use %td for ptrdiff_t.

Link: https://lkml.kernel.org/r/3abbe4c9-16ad-c168-a90f-087978ccd8f7@csgroup.eu
Link: https://lkml.kernel.org/r/20210303121157.3430807-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/report.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/kfence/report.c~kfence-fix-printk-format-for-ptrdiff_t
+++ a/mm/kfence/report.c
@@ -116,12 +116,12 @@ void kfence_print_object(struct seq_file
 	lockdep_assert_held(&meta->lock);
 
 	if (meta->state == KFENCE_OBJECT_UNUSED) {
-		seq_con_printf(seq, "kfence-#%zd unused\n", meta - kfence_metadata);
+		seq_con_printf(seq, "kfence-#%td unused\n", meta - kfence_metadata);
 		return;
 	}
 
 	seq_con_printf(seq,
-		       "kfence-#%zd [0x%p-0x%p"
+		       "kfence-#%td [0x%p-0x%p"
 		       ", size=%d, cache=%s] allocated by task %d:\n",
 		       meta - kfence_metadata, (void *)start, (void *)(start + size - 1), size,
 		       (cache && cache->name) ? cache->name : "<destroyed>", meta->alloc_track.pid);
@@ -204,7 +204,7 @@ void kfence_report_error(unsigned long a
 
 		pr_err("BUG: KFENCE: out-of-bounds %s in %pS\n\n", get_access_type(is_write),
 		       (void *)stack_entries[skipnr]);
-		pr_err("Out-of-bounds %s at 0x%p (%luB %s of kfence-#%zd):\n",
+		pr_err("Out-of-bounds %s at 0x%p (%luB %s of kfence-#%td):\n",
 		       get_access_type(is_write), (void *)address,
 		       left_of_object ? meta->addr - address : address - meta->addr,
 		       left_of_object ? "left" : "right", object_index);
@@ -213,14 +213,14 @@ void kfence_report_error(unsigned long a
 	case KFENCE_ERROR_UAF:
 		pr_err("BUG: KFENCE: use-after-free %s in %pS\n\n", get_access_type(is_write),
 		       (void *)stack_entries[skipnr]);
-		pr_err("Use-after-free %s at 0x%p (in kfence-#%zd):\n",
+		pr_err("Use-after-free %s at 0x%p (in kfence-#%td):\n",
 		       get_access_type(is_write), (void *)address, object_index);
 		break;
 	case KFENCE_ERROR_CORRUPTION:
 		pr_err("BUG: KFENCE: memory corruption in %pS\n\n", (void *)stack_entries[skipnr]);
 		pr_err("Corrupted memory at 0x%p ", (void *)address);
 		print_diff_canary(address, 16, meta);
-		pr_cont(" (in kfence-#%zd):\n", object_index);
+		pr_cont(" (in kfence-#%td):\n", object_index);
 		break;
 	case KFENCE_ERROR_INVALID:
 		pr_err("BUG: KFENCE: invalid %s in %pS\n\n", get_access_type(is_write),
@@ -230,7 +230,7 @@ void kfence_report_error(unsigned long a
 		break;
 	case KFENCE_ERROR_INVALID_FREE:
 		pr_err("BUG: KFENCE: invalid free in %pS\n\n", (void *)stack_entries[skipnr]);
-		pr_err("Invalid free of 0x%p (in kfence-#%zd):\n", (void *)address,
+		pr_err("Invalid free of 0x%p (in kfence-#%td):\n", (void *)address,
 		       object_index);
 		break;
 	}
_

Patches currently in -mm which might be from elver@google.com are

kfence-fix-printk-format-for-ptrdiff_t.patch

