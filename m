Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB94AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiANWFQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58264 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWFQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 594F3B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56DBC36AE9;
        Fri, 14 Jan 2022 22:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197914;
        bh=JBh4/ao6a8cwJd+fW2YVjUpV2pIP7+/GDPGAhN/WGsA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=S7y+GQ8mIDp6bw70lYmSKj5kkVdSzJYclCv2hOLSPl6H9ZPfuQ/gcmLZhWkai04a8
         Z4vmFv4a4l9UIroOZ+ccJ5B8rtmEaM174YPvdyg1ByXpddOs0taUTHqGLspjgfdNpc
         wd7zNoao7KG31AHpznsLTSoWdGVADSZz0YvdOwAI=
Date:   Fri, 14 Jan 2022 14:05:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     agruenba@redhat.com, akpm@linux-foundation.org,
        christophe.leroy@csgroup.eu, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 043/146] gup: avoid multiple user access
 locking/unlocking in fault_in_{read/write}able
Message-ID: <20220114220513.oOei0Zeeb%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: gup: avoid multiple user access locking/unlocking in fault_in_{read/write}able

fault_in_readable() and fault_in_writeable() perform __get_user() and
__put_user() in a loop, implying multiple user access locking/unlocking.

To avoid that, use user access blocks.

Link: https://lkml.kernel.org/r/720dcf79314acca1a78fae56d478cc851952149d.1637084492.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/gup.c~gup-avoid-multiple-user-access-locking-unlocking-in-fault_in_read-writeable
+++ a/mm/gup.c
@@ -1672,21 +1672,22 @@ size_t fault_in_writeable(char __user *u
 
 	if (unlikely(size == 0))
 		return 0;
+	if (!user_write_access_begin(uaddr, size))
+		return size;
 	if (!PAGE_ALIGNED(uaddr)) {
-		if (unlikely(__put_user(0, uaddr) != 0))
-			return size;
+		unsafe_put_user(0, uaddr, out);
 		uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
 	}
 	end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
 	if (unlikely(end < start))
 		end = NULL;
 	while (uaddr != end) {
-		if (unlikely(__put_user(0, uaddr) != 0))
-			goto out;
+		unsafe_put_user(0, uaddr, out);
 		uaddr += PAGE_SIZE;
 	}
 
 out:
+	user_write_access_end();
 	if (size > uaddr - start)
 		return size - (uaddr - start);
 	return 0;
@@ -1771,21 +1772,22 @@ size_t fault_in_readable(const char __us
 
 	if (unlikely(size == 0))
 		return 0;
+	if (!user_read_access_begin(uaddr, size))
+		return size;
 	if (!PAGE_ALIGNED(uaddr)) {
-		if (unlikely(__get_user(c, uaddr) != 0))
-			return size;
+		unsafe_get_user(c, uaddr, out);
 		uaddr = (const char __user *)PAGE_ALIGN((unsigned long)uaddr);
 	}
 	end = (const char __user *)PAGE_ALIGN((unsigned long)start + size);
 	if (unlikely(end < start))
 		end = NULL;
 	while (uaddr != end) {
-		if (unlikely(__get_user(c, uaddr) != 0))
-			goto out;
+		unsafe_get_user(c, uaddr, out);
 		uaddr += PAGE_SIZE;
 	}
 
 out:
+	user_read_access_end();
 	(void)c;
 	if (size > uaddr - start)
 		return size - (uaddr - start);
_
