Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55295C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 19:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C84961214
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 19:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhIWTCl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 15:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242794AbhIWTCl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 15:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5E5A61038;
        Thu, 23 Sep 2021 19:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632423669;
        bh=ypfJWkWIVPBW3d2Z08TSi3BUyxwJFWjxgVrMaTuOXcE=;
        h=Date:From:To:Subject:From;
        b=AoMUmBO2JKk5jVEY3n8T0QScim2sb2gQZefJHtZ7NUm3DAnPX0EASUQM9kUjTgZbk
         AWYeZYxKJXPIrSZ8KOXlXwGxCAKUwWWVieb/9lbUFkB/sFx5wLXG8cEkMXxH8+eNyx
         YSXtekQ8neBvgXSQ8i40IKr+sQwBasD6+NBpLvkE=
Date:   Thu, 23 Sep 2021 12:01:08 -0700
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, keescook@chromium.org, len.baker@gmx.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org
Subject:  [merged]
 assoc_array-avoid-open-coded-arithmetic-in-allocator-arguments.patch
 removed from -mm tree
Message-ID: <20210923190108.SdcAWpOfh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: assoc_array: avoid open coded arithmetic in allocator arguments
has been removed from the -mm tree.  Its filename was
     assoc_array-avoid-open-coded-arithmetic-in-allocator-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Len Baker <len.baker@gmx.com>
Subject: assoc_array: avoid open coded arithmetic in allocator arguments

As noted in the "Deprecated Interfaces, Language Features, Attributes, and
Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing.  This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting.  Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the struct_size() helper to do the arithmetic instead of the
argument "size + count * size" in the kmalloc() and kzalloc() functions.

Also, take the opportunity to refactor the memcpy() calls to use the
struct_size() and flex_array_size() helpers.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Link: https://lkml.kernel.org/r/20210919110913.39386-1-len.baker@gmx.com
Signed-off-by: Len Baker <len.baker@gmx.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/assoc_array.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/lib/assoc_array.c~assoc_array-avoid-open-coded-arithmetic-in-allocator-arguments
+++ a/lib/assoc_array.c
@@ -741,8 +741,7 @@ all_leaves_cluster_together:
 	keylen = round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 	keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
 
-	new_s0 = kzalloc(sizeof(struct assoc_array_shortcut) +
-			 keylen * sizeof(unsigned long), GFP_KERNEL);
+	new_s0 = kzalloc(struct_size(new_s0, index_key, keylen), GFP_KERNEL);
 	if (!new_s0)
 		return false;
 	edit->new_meta[2] = assoc_array_shortcut_to_ptr(new_s0);
@@ -849,8 +848,8 @@ static bool assoc_array_insert_mid_short
 		keylen = round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 		keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
 
-		new_s0 = kzalloc(sizeof(struct assoc_array_shortcut) +
-				 keylen * sizeof(unsigned long), GFP_KERNEL);
+		new_s0 = kzalloc(struct_size(new_s0, index_key, keylen),
+				 GFP_KERNEL);
 		if (!new_s0)
 			return false;
 		edit->new_meta[1] = assoc_array_shortcut_to_ptr(new_s0);
@@ -864,7 +863,7 @@ static bool assoc_array_insert_mid_short
 		new_n0->parent_slot = 0;
 
 		memcpy(new_s0->index_key, shortcut->index_key,
-		       keylen * sizeof(unsigned long));
+		       flex_array_size(new_s0, index_key, keylen));
 
 		blank = ULONG_MAX << (diff & ASSOC_ARRAY_KEY_CHUNK_MASK);
 		pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, diff, blank);
@@ -899,8 +898,8 @@ static bool assoc_array_insert_mid_short
 		keylen = round_up(shortcut->skip_to_level, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 		keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
 
-		new_s1 = kzalloc(sizeof(struct assoc_array_shortcut) +
-				 keylen * sizeof(unsigned long), GFP_KERNEL);
+		new_s1 = kzalloc(struct_size(new_s1, index_key, keylen),
+				 GFP_KERNEL);
 		if (!new_s1)
 			return false;
 		edit->new_meta[2] = assoc_array_shortcut_to_ptr(new_s1);
@@ -913,7 +912,7 @@ static bool assoc_array_insert_mid_short
 		new_n0->slots[sc_slot] = assoc_array_shortcut_to_ptr(new_s1);
 
 		memcpy(new_s1->index_key, shortcut->index_key,
-		       keylen * sizeof(unsigned long));
+		       flex_array_size(new_s1, index_key, keylen));
 
 		edit->set[1].ptr = &side->back_pointer;
 		edit->set[1].to = assoc_array_shortcut_to_ptr(new_s1);
@@ -1490,13 +1489,12 @@ descend:
 		shortcut = assoc_array_ptr_to_shortcut(cursor);
 		keylen = round_up(shortcut->skip_to_level, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 		keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
-		new_s = kmalloc(sizeof(struct assoc_array_shortcut) +
-				keylen * sizeof(unsigned long), GFP_KERNEL);
+		new_s = kmalloc(struct_size(new_s, index_key, keylen),
+				GFP_KERNEL);
 		if (!new_s)
 			goto enomem;
 		pr_devel("dup shortcut %p -> %p\n", shortcut, new_s);
-		memcpy(new_s, shortcut, (sizeof(struct assoc_array_shortcut) +
-					 keylen * sizeof(unsigned long)));
+		memcpy(new_s, shortcut, struct_size(new_s, index_key, keylen));
 		new_s->back_pointer = new_parent;
 		new_s->parent_slot = shortcut->parent_slot;
 		*new_ptr_pp = new_parent = assoc_array_shortcut_to_ptr(new_s);
_

Patches currently in -mm which might be from len.baker@gmx.com are


