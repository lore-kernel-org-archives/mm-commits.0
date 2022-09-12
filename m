Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5AAECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiILE5L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiILE44 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B6427FFD
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0D09B80C74
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78804C433D7;
        Mon, 12 Sep 2022 04:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958597;
        bh=Gy3w9jzgIjBDk2+mJiQ/m18J3gMqT5V3YF5Fmics+j8=;
        h=Date:To:From:Subject:From;
        b=HAGHUZy5o5E/m2smbXKQVBzMTECTIwZ9/UomNB6jr3QZaxxxkSb5k4DDI/Db3sgH4
         59ukPI0ItHogqOidLtgCnxjKKumCEzbPL53TIqWEZDarmmT5dIjXD9k35MFiwUSWKE
         Xl2U4S6lmTG5CBCAKxC2PkRbk/PUu4n1GYlKlNso=
Date:   Sun, 11 Sep 2022 21:56:36 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] iversion-use-atomic64_try_cmpxchg.patch removed from -mm tree
Message-Id: <20220912045637.78804C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iversion: use atomic64_try_cmpxchg)
has been removed from the -mm tree.  Its filename was
     iversion-use-atomic64_try_cmpxchg.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: iversion: use atomic64_try_cmpxchg)
Date: Sun, 21 Aug 2022 21:30:11 +0200

Use atomic64_try_cmpxchg instead of
atomic64_cmpxchg (*ptr, old, new) == old in inode_set_max_iversion_raw,
inode_maybe_inc_version and inode_query_iversion. x86 CMPXCHG instruction
returns success in ZF flag, so this change saves a compare after cmpxchg
(and related move instruction in front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails, enabling further code simplifications.

The loop in inode_maybe_inc_iversion improves from:

    5563:	48 89 ca             	mov    %rcx,%rdx
    5566:	48 89 c8             	mov    %rcx,%rax
    5569:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
    556d:	48 83 c2 02          	add    $0x2,%rdx
    5571:	f0 48 0f b1 16       	lock cmpxchg %rdx,(%rsi)
    5576:	48 39 c1             	cmp    %rax,%rcx
    5579:	0f 84 85 fc ff ff    	je     5204 <...>
    557f:	48 89 c1             	mov    %rax,%rcx
    5582:	eb df                	jmp    5563 <...>

to:

    5563:	48 89 c2             	mov    %rax,%rdx
    5566:	48 83 e2 fe          	and    $0xfffffffffffffffe,%rdx
    556a:	48 83 c2 02          	add    $0x2,%rdx
    556e:	f0 48 0f b1 11       	lock cmpxchg %rdx,(%rcx)
    5573:	0f 84 8b fc ff ff    	je     5204 <...>
    5579:	eb e8                	jmp    5563 <...>

Link: https://lkml.kernel.org/r/20220821193011.88208-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iversion.h |   32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

--- a/include/linux/iversion.h~iversion-use-atomic64_try_cmpxchg
+++ a/include/linux/iversion.h
@@ -123,17 +123,12 @@ inode_peek_iversion_raw(const struct ino
 static inline void
 inode_set_max_iversion_raw(struct inode *inode, u64 val)
 {
-	u64 cur, old;
+	u64 cur = inode_peek_iversion_raw(inode);
 
-	cur = inode_peek_iversion_raw(inode);
-	for (;;) {
+	do {
 		if (cur > val)
 			break;
-		old = atomic64_cmpxchg(&inode->i_version, cur, val);
-		if (likely(old == cur))
-			break;
-		cur = old;
-	}
+	} while (!atomic64_try_cmpxchg(&inode->i_version, &cur, val));
 }
 
 /**
@@ -197,7 +192,7 @@ inode_set_iversion_queried(struct inode
 static inline bool
 inode_maybe_inc_iversion(struct inode *inode, bool force)
 {
-	u64 cur, old, new;
+	u64 cur, new;
 
 	/*
 	 * The i_version field is not strictly ordered with any other inode
@@ -211,19 +206,14 @@ inode_maybe_inc_iversion(struct inode *i
 	 */
 	smp_mb();
 	cur = inode_peek_iversion_raw(inode);
-	for (;;) {
+	do {
 		/* If flag is clear then we needn't do anything */
 		if (!force && !(cur & I_VERSION_QUERIED))
 			return false;
 
 		/* Since lowest bit is flag, add 2 to avoid it */
 		new = (cur & ~I_VERSION_QUERIED) + I_VERSION_INCREMENT;
-
-		old = atomic64_cmpxchg(&inode->i_version, cur, new);
-		if (likely(old == cur))
-			break;
-		cur = old;
-	}
+	} while (!atomic64_try_cmpxchg(&inode->i_version, &cur, new));
 	return true;
 }
 
@@ -304,10 +294,10 @@ inode_peek_iversion(const struct inode *
 static inline u64
 inode_query_iversion(struct inode *inode)
 {
-	u64 cur, old, new;
+	u64 cur, new;
 
 	cur = inode_peek_iversion_raw(inode);
-	for (;;) {
+	do {
 		/* If flag is already set, then no need to swap */
 		if (cur & I_VERSION_QUERIED) {
 			/*
@@ -320,11 +310,7 @@ inode_query_iversion(struct inode *inode
 		}
 
 		new = cur | I_VERSION_QUERIED;
-		old = atomic64_cmpxchg(&inode->i_version, cur, new);
-		if (likely(old == cur))
-			break;
-		cur = old;
-	}
+	} while (!atomic64_try_cmpxchg(&inode->i_version, &cur, new));
 	return cur >> I_VERSION_QUERIED_SHIFT;
 }
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are


