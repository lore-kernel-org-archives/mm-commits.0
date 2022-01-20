Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0670CC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377820AbiATVYm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377818AbiATVYl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC430C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A6A460A3C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF22BC340E0;
        Thu, 20 Jan 2022 21:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713880;
        bh=GWC/iHSMf7Q291uFelgiEje8fXk68HOXIFmP14EmA4Q=;
        h=Date:From:To:Subject:From;
        b=yD6kNR/1Ha/5ahlWsWcyxfmYiK3vgEhEP6fSZ6UhfXXy7AT/2GTTeBpImcMpmgGmM
         P3DJBdARzd4JnCHCjpRr/JDFgtQgSRIYWQNJZvDB0udITx2gOIoogQdX66Hac4jWKU
         hUgBAPoAHz0xdpwIdKn0BVljgV1AwcIJelt0xdnU=
Date:   Thu, 20 Jan 2022 13:24:40 -0800
From:   akpm@linux-foundation.org
To:     agruenba@redhat.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?gup-avoid-multiple-user-access-locking-unlocking-in-fault?=
 =?US-ASCII?Q?=5Fin=5Fread-writeable.patch?= removed from -mm tree
Message-ID: <20220120212440.QdZiSu8eV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gup: avoid multiple user access locking/unlocking in fault_in_{read/write}able
has been removed from the -mm tree.  Its filename was
     gup-avoid-multiple-user-access-locking-unlocking-in-fault_in_read-writeable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


